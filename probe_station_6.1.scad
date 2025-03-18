$fn = 100;

g  = 0.010; // технический зазор
G  = 0.051; // точность фотополимерного принтера
pg = 0.400; // погрешность принтера

// винт M3
M3D  =  3.00;
M3Dk =  5.60;
M3K  =  1.65;
M3L  = 50.00-M3K;

M4D  =  4.00;

M6Nd = 10.00/cos(30); M6Nl = 5.00;
M5Nd =  8.00/cos(30); M5Nl = 4.00;
M4Nd =  7.00/cos(30); M4Nl = 3.20;
M3Nd =  5.50/cos(30); M3Nl = 2.40;
M2Nd =  4.00/cos(30); M2Nl = 1.60;

/*
 * Винт
 * D  - диаметр резьбы
 * L  - длина резьбы
 * Dk - диаметр шляпки
 * K  - высота шляпки
 */
module screw(D, L, Dk, K)
{
	screw_hat(D, Dk, K);
	translate([0, 0, K-0.001])
	screw_body(D, L+0.001);
}
module screw_hat (D, Dk, K) {cylinder(d1 = Dk, d2 = D, h = K       );}
module screw_body(D, L)     {cylinder(d  = D ,         h = L       );}
module screw_nut (D, L)     {cylinder(d  = D ,         h = L, $fn=6);}

// параметры контакта p50b1
PD1 =  0.500; // диаметр острия
PD2 =  0.680; // диаметр оболочки
PH0 =  0.433; // высота заточки
PH1 =  3.350; // высота острия
PH2 = 13.000; // высота оболочки

module probe()
{
	color("Silver")
	{
		cylinder(d1=0, d2=PD1, h=PH0);
		translate([0, 0, PH0])
		cylinder(d=PD1, h=PH1-PH0);
	}

	color("Gold")
	translate([0, 0, PH1])
	cylinder(d=PD2, h=PH2);
}

PH_L = 50;
PH_H = 4;
PH_W = 7;

module probe_holder()
{
	A = 10;

	L = PH_L;
	H = PH_H;
	W = PH_W+1;

	L1 = L/2;

	W1 = 10.00;

	H1 =  4.00;
	H2 =  3.50;

	D1 =  1.30;
	D2 =  1.65;
	D3 =  2.00;

	S = (H1+2*H2)*cos(A)+(D3/2)*sin(A);

	difference()
	{
		union()
		{
			rotate([0, A, 0])
			translate([0, 0, H1])
			cylinder(d1 = D1, d2 = D2, h = H2);

			hull()
			{
				rotate([0, A, 0])
				translate([0, 0, H1 + H2])
				cylinder(d1 = D2, d2 = D3, h = H2);

				intersection()
				{
					rotate([0, A, 0])
					translate([0, 0, H1 + 2*H2])
					cylinder(d = D3, h = H2);

					translate([0, -W/2, S-H])
					cube([L, W, H]);
				}

				translate([L1, -W/2, S-H])
				cube([L-L1, W, H]);
			}

			translate([L1, -W/2, S-H])
			cube([L-L1, W, H]);

			translate([L-H/2, -W/2, 0])
			hull()
			{
				translate([H/2-H/10/2, 0, H/10/2])
				rotate([-90, 0, 0])
				cylinder(d = H/10, h = W);

				translate([-H/2, 0, S-H])
				cube([H, W, H]);
			}
		}

		union()
		{
			rotate([0, A, 0])
			cylinder(d = PD2 + 4*G, h = PH1 + PH2);

			hull()
			{
				translate([L1-1, 0, -g])
				cylinder(d = 3.5, h = S + 2*g);

				translate([L-5, 0, -g])
				cylinder(d = 3.5, h = S + 2*g);
			}

			translate([0, 0, 8.8])
			rotate([0, 45+10, 0])
			translate([-11, -5, 0])
			cube([11, 11, 11]);

			translate([L+g, W/2-1, S-2])
			rotate([0, -90, 0])
			cylinder(d = 1.0, h = L1+0.2);

			translate([L1, W/2-1, S-2])
			rotate([0, -90+10, 7.5])
			cylinder(d = 1.0, h = L1);

			translate([L+g, -W/2+1, S-2])
			rotate([0, -90, 0])
			cylinder(d = 1.0, h = L1+0.2);

			translate([L1, -W/2+1, S-2])
			rotate([0, -90+10, -7.5])
			cylinder(d = 1.0, h = L1);
		}
	}
}

T_W = 130;
T_L = 130;
T_H = 5;

module table()
{
	// table size
	W0 = T_W;
	L0 = T_L;
	H0 = T_H;

	// sample part size
	W1 = 26;
	L1 = 26;
	H1 = 2;

	$fn = 20;

	difference()
	{
		cube([W0, L0, H0], center = true);

		translate([0, 0, (H0-H1+g)/2])
		cube([W1+pg, L1+pg, H1+g], center = true);

		translate([0, 0, -H0/2])
		for(i = [-0.5:1:0.5])
		for(j = [-0.5:1:0.5])
		{
			x = i * (W0-10);
			y = j * (L0-10);

			translate([x, y, H0+g])
			rotate([180, 0, 0])
			screw(M3D+0.5, H0 + 2*g, M3Dk+0.5, M3K);
		}

		n = 8;
		a0 = 360/n;
		for(a = [a0/2:a0:a0/2+(n-1)*a0])
		rotate([0, 0, a])
		{
			translate([42, 0, 0])
			cylinder(d = 4.2, h = H0 + 2*g, center = true);
		}

		n1 = 4;
		a1 = 360/n1;
		for(a = [0:a1:(n1-1)*a1])
		rotate([0, 0, a])
		{
			translate([25/2+3, 0, 0])
			cylinder(d = 4.2, h = H0 + 2*g, center = true);
		}
	}
}

// ==================== CARTRIDGE ====================

C_W = 25+1;
C_L = 25+1;
C_H = 2;

C_w1 = 10.000;
C_l1 = 10.000;

C_w2 =  9.517;
C_l2 = 10.286;

C_w3 = 12.800;
C_l3 = 13.780;

C_g  = 0.200;

// электрод
EW1 = C_w1;
EL1 = C_l1;
EH1 = 0.46;

EW2 = C_w2;
EL2 = C_l2;
EH2 = 0.46;

EW3 = C_w3;
EL3 = C_l3;
EH3 = 0.46;

module electrode(w, l, h)
{
	color("red")
	cube([w, l, h], center = true);
}

module cartridge(_w, _l)
{
	W = C_W;
	L = C_L;
	H = C_H;

	w = _w + C_g;
	l = _l + C_g;

	difference()
	{
		union()
		{
			minkowski()
			{
				cube([W-1.0, L-1.0, H-0.1], center = true);
				cylinder(d = 1.0, h = 0.1, center = true);
			}

			rotate([0, 0, +45]) translate([+14, 0, 3/2]) cube([5, 1, 3], center = true);
			rotate([0, 0, +45]) translate([-14, 0, 3/2]) cube([5, 1, 3], center = true);
			rotate([0, 0, -45]) translate([+14, 0, 3/2]) cube([5, 1, 3], center = true);
			rotate([0, 0, -45]) translate([-14, 0, 3/2]) cube([5, 1, 3], center = true);
		}

		translate([0, 0, H/2-0.5/2+g/2])
		cube([w, l, 0.5+g], center = true);

		translate([0, 0, H/2-1/2+g/2]) cube([18,  1, 1+g], center = true);
		translate([0, 0, H/2-1/2+g/2]) cube([ 1, 18, 1+g], center = true);
	}
}

module cartridge1()
{
	W = C_W;
	L = C_L;
	H = C_H;

	difference()
	{
		cartridge(C_w1, C_l1);

		translate([0, L/2-2, H/2-0.5])
		linear_extrude(0.5+g)
		text("10.000 x 10.000", size = 1.8, halign = "center", valign = "center");
	}
}

module cartridge2()
{
	W = C_W;
	L = C_L;
	H = C_H;

	difference()
	{
		cartridge(C_w2, C_l2);

		translate([0, L/2-2, H/2-0.5])
		linear_extrude(0.5+g)
		text("9.517 x 10.286", size = 1.8, halign = "center", valign = "center");
	}
}

module cartridge3()
{
	W = C_W;
	L = C_L;
	H = C_H;

	difference()
	{
		cartridge(C_w3, C_l3);

		translate([0, L/2-2, H/2-0.5])
		linear_extrude(0.5+g)
		text("12.800 x 13.780", size = 1.8, halign = "center", valign = "center");
	}
}

// ==================== FITTING ====================

fnD = (26 + pg)/cos(30);
fnL = 6;

module fitting_nut()
{
	screw_nut(fnD, fnL);
	translate([0, 0, fnL-g])
	cylinder(d = 21, h = fnL);
}

// ==================== LABYRINTE ====================

labD1 = 14.8;
labD4 = 26.0;

module labyr1()
{
	D1 = 14.8;
	D2 =  2.0;
	D3 =  6.0;
	D4 = 26.0;
	L1 = D1;
	L2 = D1/6;

	A = 180;
	N = 5;
	M = 8;

	da = A/N;
	dl = L1/N;
	X = D1/2-D2/2-1;

	difference()
	{
		union()
		{
			cylinder(d = D1, h = L1);
			translate([0, 0, -L2])
			cylinder(d = D4, h = L2);
		}
		translate([0, 0, L1-L2])
		cylinder(d = D1-2, h = L2+g);

		translate([0, 0, -L2])
		for(a = [0:360/M:360-360/M])
		for(i = [0:1:N-1])
		rotate([0, 0, a])
		hull()
		{
			rotate([0, 0, da*(i%2)])
			translate([X, 0, dl*i])
			cylinder(d = D2, h=g, center = true);

			rotate([0, 0, da*((i+1)%2)])
			translate([X, 0, dl*(i+1)])
			cylinder(d = D2, h=g, center = true);
		}
	}
}

module labyr2()
{
	D1 = 14.8;
	D2 =  2.0;
	D3 =  6.0;
	D4 = 35.0;
	L1 = D1;
	L2 = D1/6;

	A = 180;
	N = 5;
	M = 8;

	da = A/N;
	dl = L1/N;
	X = D1/2-D2/2-1;

	translate([0, 0, L2])
	difference()
	{
		union()
		{
			cylinder(d = D1, h = L1);
			translate([0, 0, -L2])
			cylinder(d = D4, h = L2);
		}

		translate([0, 0, L1-L2])
		cylinder(d = D1-2, h = L2+g);

		for(a = [0:60:300])
		rotate([0, 0, a])
		translate([25/2, 0, -L2])
		{
			translate([0, 0, L2/2])
			rotate([0, 0, 30])
			screw_nut (M3Nd+2*0.2, 4-2+g);

			translate([0, 0, -g])
			cylinder(d = 3.1, h = L2+2*g);
		}

		translate([0, 0, -L2])
		for(a = [0:360/M:360-360/M])
		for(i = [0:1:N-1])
		rotate([0, 0, a])
		hull()
		{
			rotate([0, 0, da*(i%2)])
			translate([X, 0, dl*i])
			cylinder(d = D2, h=g, center = true);

			rotate([0, 0, da*((i+1)%2)])
			translate([X, 0, dl*(i+1)])
			cylinder(d = D2, h=g, center = true);
		}
	}
}

// ==================== BOX ====================

B_W = 150;
B_L = 150;
B_H = 40.0;
B_H2 = 45.0;

module box()
{
	W = B_W;
	L = B_L;
	H = B_H;

	d = 3;

	D1 = 14+pg;
	H1 = 2;
	D2 = 11+pg;
	H2 = 9;
	H21 = 1;

	D3 = 12.5+pg;
	H3 = 2;
	D4 = 10.2+pg;
	H4 = 8.1;
	H41 = 9.2+pg;

	difference()
	{
		cube([W, L, H], center = true);

		translate([0, 0, (d+g)/2])
		cube([W-2*d, L-2*d, H-d+g], center = true);

		translate([-W/2+1.5  , +27.5/2, H/2-8.5]) rotate([0,+90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([-W/2+1.5+g, +27.5/2, H/2-8.5]) rotate([0,-90,0]) screw_body(M4D +pg,    3+2*g);
		translate([-W/2+1.5  , -27.5/2, H/2-8.5]) rotate([0,+90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([-W/2+1.5+g, -27.5/2, H/2-8.5]) rotate([0,-90,0]) screw_body(M4D +pg,    3+2*g);
		translate([+W/2-1.5  , +27.5/2, H/2-8.5]) rotate([0,-90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([+W/2-1.5-g, +27.5/2, H/2-8.5]) rotate([0,+90,0]) screw_body(M4D +pg,    3+2*g);
		translate([+W/2-1.5  , -27.5/2, H/2-8.5]) rotate([0,-90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([+W/2-1.5-g, -27.5/2, H/2-8.5]) rotate([0,+90,0]) screw_body(M4D +pg,    3+2*g);

		for(i = [-1.5:1:1.5])
		{
			translate([i*25, -L/2-g, 0]) rotate([-90, 0, 0]) cylinder(d = D1, h = H1+g);
			translate([i*25, -L/2-g, 0]) rotate([-90, 0, 0])
			difference()
			{
				cylinder(d = D2, h = H2+g);
				translate([-D2/2+H21/2-g/2, 0, H2/2]) cube([H21+g, D2, H2+2*g], center = true);
			}
		}

		for(i = [-1.5:1:1.5])
		{
			translate([i*25, +L/2+g, 0]) rotate([+90, 0, 0]) cylinder(d = D3, h = H3+g);
			translate([i*25, +L/2+g, 0]) rotate([+90, 0, 0])
			intersection()
			{
				cylinder(d = D4, h = H4+g);
				translate([0, 0, H4/2]) cube([H41+g, D4, H4+2*g], center = true);
			}
		}

		translate([-B_W/2+fnL+1.5, -B_L/4, 0])
		rotate([0, -90, 0])
		fitting_nut();
	}

	difference()
	{
		union()
		{
			translate([-(W/2-10), -(L/2-10), -5/2]) cube([20, 20, H-5], center = true);
			translate([-(W/2-10), +(L/2-10), -5/2]) cube([20, 20, H-5], center = true);
			translate([+(W/2-10), -(L/2-10), -5/2]) cube([20, 20, H-5], center = true);
			translate([+(W/2-10), +(L/2-10), -5/2]) cube([20, 20, H-5], center = true);
		}

		union()
		{
			translate([-(W/2-15), -(L/2-15), H/2-10/2-5]) cylinder(d = 4.2, h = 10+g, center = true);
			translate([-(W/2-15), +(L/2-15), H/2-10/2-5]) cylinder(d = 4.2, h = 10+g, center = true);
			translate([+(W/2-15), -(L/2-15), H/2-10/2-5]) cylinder(d = 4.2, h = 10+g, center = true);
			translate([+(W/2-15), +(L/2-15), H/2-10/2-5]) cylinder(d = 4.2, h = 10+g, center = true);
		}
	}

	intersection()
	{
		difference()
		{
			cube([B_W-12, B_L-12, H  ], center = true);
			cube([T_W+3 , T_L+3 , H+g], center = true);
		}

		union()
		{
			translate([-(W/2-10), -(L/2-10), 0]) cube([20, 20, H-2], center = true);
			translate([-(W/2-10), +(L/2-10), 0]) cube([20, 20, H-2], center = true);
			translate([+(W/2-10), -(L/2-10), 0]) cube([20, 20, H-2], center = true);
			translate([+(W/2-10), +(L/2-10), 0]) cube([20, 20, H-2], center = true);
		}
	}
}

module cover()
{
	W = B_W;
	L = B_L;
	H = B_H2;

	d = 3.1;

	difference()
	{
		union()
		{
			difference()
			{
				cube([W, L, H], center = true);

				translate([0, 0, (d+g)/2])
				cube([W-2*d, L-2*d, H-d+g], center = true);

				// translate([W/2-labD4/2-5, -(L/2-labD4/2-5), -H/2-g])
				// cylinder(d = labD1, h = d + 2*g);
			}

			translate([0, 0, d/2])
			difference()
			{
				cube([W-2*d  , L-2*d  , H+d  ], center = true);
				cube([W-2*d-2, L-2*d-2, H+d+g], center = true);
			}
		}

		translate([-W/2+1.5  , +26.5/2, H/2-19]) rotate([0,+90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([-W/2+1.5+g, +26.5/2, H/2-19]) rotate([0,-90,0]) screw_body(M4D +pg,    3+2*g);
		translate([-W/2+1.5  , -26.5/2, H/2-19]) rotate([0,+90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([-W/2+1.5+g, -26.5/2, H/2-19]) rotate([0,-90,0]) screw_body(M4D +pg,    3+2*g);
		translate([+W/2-1.5  , +26.5/2, H/2-19]) rotate([0,-90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([+W/2-1.5-g, +26.5/2, H/2-19]) rotate([0,+90,0]) screw_body(M4D +pg,    3+2*g);
		translate([+W/2-1.5  , -26.5/2, H/2-19]) rotate([0,-90,0]) screw_nut (M4Nd+pg, M4Nl+  g);
		translate([+W/2-1.5-g, -26.5/2, H/2-19]) rotate([0,+90,0]) screw_body(M4D +pg,    3+2*g);

		union()
		{
			translate([0, 0, -H/2-g])
			cylinder(d = 17.5, h = d+2*g);

			for(a = [0:60:300])
			rotate([0, 0, a])
			translate([25/2, 0, -H/2-g])
			cylinder(d = 3.1, h = d+2*g);

			for(a = [0:60:300])
			rotate([0, 0, a])
			translate([25/2, 0, -H/2-g])
			{
				translate([0, 0, 1.5])
				rotate([0, 0, 30])
				screw_nut (M3Nd+pg, d-g);
			}
		}

		translate([W/2-25, -(L/2-25), 0])
		{
			translate([0, 0, -H/2-g])
			cylinder(d = 17.5, h = d+2*g);

			for(a = [0:60:300])
			rotate([0, 0, a])
			translate([25/2, 0, -H/2-g])
			cylinder(d = 3.1, h = d+2*g);

			for(a = [0:60:300])
			rotate([0, 0, a])
			translate([25/2, 0, -H/2-g])
			{
				translate([0, 0, 1.5])
				rotate([0, 0, 30])
				screw_nut (M3Nd+pg, d-g);
			}
		}
	}
}

// ==================== OPTICS ====================

module fiber_sma_holder()
{
	h1 =  2.60;
	w1 = 12.70;
	l1 = 12.70;
	d1 = 16.10;

	d2 = 3.24; // центральное отверстие
	d3 = 2.54; // отверстие крепления

	w2 = 6.11;

	h2 = 12.08;
	d4 =  5.30;

	// фланец
	difference()
	{
		intersection()
		{
			translate([-w1/2, -l1/2, 0])
			cube([w1, l1, h1]);

			cylinder(d = d1, h = h1);
		}

		// центральное отверстие
		translate([0, 0, -g])
		cylinder(d = d2, h = h1+2*g);

		// отверстия крепления
		for(a = [45:90:360-45])
		rotate([0, 0, a])
		translate([w2, 0, -g])
		cylinder(d = d3, h = h1+2*g);
	}

	difference()
	{
		cylinder(d = d4, h = h2);
		// центральное отверстие
		translate([0, 0, -g])
		cylinder(d = d2, h = h2+2*g);
	}
}

module fiber_fc_holder()
{
	h1 =  2.00;
	w1 = 15.00; // ширина фланца
	l1 = 15.00; // длина фланца
	d1 = 19.10; // диаметр "среза" углов

	d2 = 2.70; // центральное отверстие
	d3 = 2.60; // отверстие крепления
	d31 = 4.0; // углубление отверстия крепления

	w2 = 13.40/2;

	h2 = 7.44;
	d4 = 8.00;

	h3 = 2.0;
	d5 = 6.50;

	// фланец
	difference()
	{
		union()
		{
			intersection()
			{
				translate([-w1/2, -l1/2, 0])
				cube([w1, l1, h1]);

				cylinder(d = d1, h = h1);
			}

			cylinder(d = d4, h = h2);
		}

		// центральное отверстие
		translate([0, 0, -g])
		{
			cylinder(d = d2, h = h2+2*g);
			cylinder(d = d5, h = 2+g);
		}

		// отверстия крепления
		for(a = [45:90:360-45])
		rotate([0, 0, a])
		translate([w2, 0, 0])
		{
			translate([0, 0, -g])
			cylinder(d = d3, h = h1+2*g);
			translate([0, 0, 0.5])
			cylinder(d = d31, h = h1-0.5+g);
		}
	}
}

module fiber_fc_holder2()
{
	d1 = 2.70+0.2; // центральное отверстие
	
	h2 = 2.0-0.2;
	d2 = 6.50-0.2;


	// D1 = 

}

module lens_holder1()
{
	d0 = 12.70;
	d1 = d0 + 2*0.2;
	d2 = d0 - 2*0.5;
	d3 = 3.10;
	d4 = 5.30;
	h1 = 2.00;
	h2 = 1.00;

	D0 = 35;
	D1 = 25;

	difference()
	{
		cylinder(d = D0, h = h1);

		for(a = [0:60:360])
		rotate([0, 0, a])
		translate([D1/2, 0, -g])
		cylinder(d = d3, h = h1+2*g);

		translate([0, 0, -g])
		cylinder(d = d2, h = h1+2*g);

		translate([0, 0, h2])
		cylinder(d = d1, h = h1-h2+g);
	}
}

module lens_holder2()
{
	d0 = 12.70;
	d1 = d0 + 2*0.2;
	d2 = d0 - 2*0.5;
	d3 = 3.10;
	d4 = 5.30;
	h1 = 2.00;
	h2 = 1.00;

	D0 = 35;
	D1 = 25;

	difference()
	{
		cylinder(d = D0, h = h1);

		for(a = [0:120:360])
		rotate([0, 0, a])
		translate([D1/2, 0, -g])
		cylinder(d = d3, h = h1+2*g);

		for(a = [60:120:360])
		rotate([0, 0, a])
		translate([D1/2, 0, -g])
		rotate([0, 0, 30])
		screw_nut (M3Nd+2*0.2, h1+2*g);


		translate([0, 0, -g])
		cylinder(d = d2, h = h1+2*g);

		translate([0, 0, h2])
		cylinder(d = d1, h = h1-h2+g);
	}
}

module fh_holder()
{
	d0 = 12.70;
	d1 = d0 + 2*0.2;
	d2 = d0 - 2*0.5;
	d3 =  3.10;
	d4 =  5.30;
	h1 =  4.00;
	h2 = 10.00;

	D0 = 35;
	D1 = 25;

	difference()
	{
		union()
		{
			cylinder(d = D0  , h = h1);
			cylinder(d = d0+5, h = h2);
		}

		for(a = [0:60:300])
		rotate([0, 0, a])
		translate([D1/2, 0, 0])
		{
			translate([0, 0, 2.0])
			rotate([0, 0, 30])
			screw_nut (M3Nd+2*0.2, h1-2+g);

			translate([0, 0, -g])
			cylinder(d = d3, h = h1+2*g);
		}

		translate([0, 0, -g])
		cylinder(d1 = d0, d2 = 4, h = h2-2+2*g);
		translate([0, 0, -g])
		cylinder(d = 4, h = h2+2*g);

		for(a = [0:90:360])
		rotate([0, 0, a])
		translate([6.11, 0, -g])
		{
			screw_nut (M2Nd+2*0.2, h2-2+g);
			cylinder(d = 2.54, h = h2+2*g);
		}
	}
}

module fc_holder1()
{
	DW = 2;    // толщина стенок

	Fl = 24.5; // фокус линзы
	Dl = 12.7; // диаметр линзы
	Al = 30;   // угол для линзы
	Hl = 2.1;  // толщина линзы на краю

	Lf = 15.0; // сторона фланца
	Df = 2.1;  // толщина фланца

	w1 = 2.0;
	w2 = Hl + 0.1;
	w3 = 1.0;
	w5 = 1.0;
	w4 = Fl - w3 - w2/2 - w5;
	w6 = 0.2;
	w7 = 1.0;
	w8 = Df + 0.1;
	w9 = 1.0;

	l1 = Dl - 1.0;
	l2 = Dl + 0.4;
	l3 = l1;
	l4 = 16.0;
	l5 = 5.0;
	l6 = 10.0;
	l7 = l5;
	l8 = Lf + 0.1;
	l9 = l8 - 4.0;

	// большая части
	W1 = 70;
	L1 = 70;
	H1 = 10;
	D1 = 40;

	// меньшая часть
	W2 = w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8 + w9 - DW;
	L2 = 20.0;
	H2 = H1;

	// часть коллиматора
	difference()
	{
		translate([0, -L2, 0])
		cube([W2, L2, H2]);

		translate([-g, -L2+DW, DW])
		cube([W2 + 2*g, L2-2*DW, H2-DW+g]);
	}

	// основная часть
	difference()
	{
		translate([W2, -L1, 0])
		cube([W1, L1, H1]);

		translate([W2+DW, -L1+DW, DW])
		cube([W1-2*DW, L1-2*DW, H1-DW+g]);

		translate([W2-g, -L2+DW, DW])
		cube([DW + 2*g, L2-2*DW, H2-DW+g]);

		translate([W2+W1/2, -L2-D1/2, -g])
		cylinder(d = D1, h = DW+2*g);

		translate([W1+W2-DW-g, -2*DW, H1/2-2])
		rotate([0, 90, 0])
		cylinder(d = 1.5, h = DW+2*g);

		translate([W1+W2-DW-g, -2*DW, H1/2+2])
		rotate([0, 90, 0])
		cylinder(d = 1.5, h = DW+2*g);
	}

	// цилиндрическая стенка
	difference()
	{
		translate([W2+W1/2, -L2-D1/2, 0])
		cylinder(d = D1, h = H1);

		translate([W2+W1/2, -L2-D1/2, -g])
		cylinder(d = D1-2*DW, h = H1+2*g);
	}

	// направляющие
	union()
	{
		DW1 = DW/2-0.1;
		DW2 = DW/2+0.1;
		
		translate([0, -DW, H1])
		cube([W1+W2-DW2, DW1, 1.0]);

		translate([0, -L2+DW2, H1])
		cube([W2+DW, DW1, 1.0]);

		translate([W2+DW2, -L1+DW2, H1])
		cube([W1-2*DW2, DW1, 1.0]);

		translate([W2+DW2, -L1+DW2, H1])
		cube([DW1, L1-L2+DW-DW2, 1.0]);

		translate([W1+W2-DW, -L1+DW2, H1])
		cube([DW1, L1-2*DW2, 1.0]);

		difference()
		{
			translate([W2+W1/2, -L2-D1/2, H1])
			cylinder(d = D1, h = 1.0);

			translate([W2+W1/2, -L2-D1/2, H1-g])
			cylinder(d = D1-2*DW1, h = 1.0+2*g);
		}
	}

	// перегородки
	union()
	{
		difference()
		{
			translate([0, -L2, 0])
			cube([w1, L2, H1]);

			translate([-g, -L2/2, H1])
			rotate([0, 90, 0])
			cylinder(d = l1, h = w1+2*g);

			translate([w1/2, -L2/2, H1])
			rotate([0, 90, 0])
			cylinder(d1 = l1, d2 = l2, h = w1/2+g);
		}

		translate([w1, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w2, L2, H1]);

			translate([-g, -L2/2, H1])
			rotate([0, 90, 0])
			cylinder(d = l2, h = w2+2*g);
		}

		translate([w1+w2, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w3, L2, H1]);

			translate([-g, -L2/2, H1])
			rotate([0, 90, 0])
			cylinder(d = l3, h = w3+2*g);
		}

		translate([w1+w2+w3+w4, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w5, L2, H1]);

			translate([-g, -L2/2-l5/2, H1-l5/2])
			cube([w5+2*g, l5, l5/2+g]);
		}

		translate([w1+w2+w3+w4+w5, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w6, L2, H1]);

			translate([-g, -L2/2-l6/2, H1-l6/2])
			cube([w6+2*g, l6, l6/2+g]);
		}

		translate([w1+w2+w3+w4+w5+w6, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w7, L2, H1]);

			translate([-g, -L2/2-l7/2, H1-l7/2])
			cube([w7+2*g, l7, l7/2+g]);
		}

		translate([w1+w2+w3+w4+w5+w6+w7, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w8, L2, H1]);

			translate([-g, -L2/2-l8/2, H1-l8/2])
			cube([w8+2*g, l8, l8/2+g]);
		}

		translate([w1+w2+w3+w4+w5+w6+w7+w8, 0, 0])
		difference()
		{
			translate([0, -L2, 0])
			cube([w9, L2, H1]);

			translate([-g, -L2/2-l9/2, H1-l9/2])
			cube([w9+2*g, l9, l9/2+g]);
		}
	}
}

*fc_holder1();

module fc_holder2()
{
	DW = 2;    // толщина стенок

	Fl = 24.5; // фокус линзы
	Dl = 12.7; // диаметр линзы
	Al = 30;   // угол для линзы
	Hl = 2.1;  // толщина линзы на краю

	Lf = 15.0; // сторона фланца
	Df = 2.1;  // толщина фланца

	w1 = 2.0;
	w2 = Hl + 0.1;
	w3 = 1.0;
	w5 = 1.0;
	w4 = Fl - w3 - w2/2 - w5;
	w6 = 0.2;
	w7 = 1.0;
	w8 = Df + 0.1;
	w9 = 1.0;

	l1 = Dl - 1.0;
	l2 = Dl + 0.4;
	l3 = l1;
	l4 = 16.0;
	l5 = 5.0;
	l6 = 10.0;
	l7 = l5;
	l8 = Lf + 0.1;
	l9 = l8 - 4.0;

	// большая части
	W1 = 70;
	L1 = 70;
	H1 = 10;
	D1 = 40;

	// меньшая часть
	W2 = w1 + w2 + w3 + w4 + w5 + w6 + w7 + w8 + w9 - DW;
	L2 = 20.0;
	H2 = H1;

	mirror([0, 1, 0])
	difference()
	{
		union()
		{
			// часть коллиматора
			difference()
			{
				translate([0, -L2, 0])
				cube([W2, L2, H2]);

				translate([-g, -L2+DW, DW])
				cube([W2 + 2*g, L2-2*DW, H2-DW+g]);
			}

			// основная часть
			difference()
			{
				translate([W2, -L1, 0])
				cube([W1, L1, H1]);

				translate([W2+DW, -L1+DW, DW])
				cube([W1-2*DW, L1-2*DW, H1-DW+g]);

				translate([W2-g, -L2+DW, DW])
				cube([DW + 2*g, L2-2*DW, H2-DW+g]);

				translate([W2+W1/2, -L2-D1/2, -g])
				cylinder(d = D1, h = DW+2*g);
			}

			// цилиндрическая стенка
			difference()
			{
				translate([W2+W1/2, -L2-D1/2, 0])
				cylinder(d = D1, h = H1);

				translate([W2+W1/2, -L2-D1/2, -g])
				cylinder(d = D1-2*DW, h = H1+2*g);
			}

			// перегородки
			union()
			{
				difference()
				{
					translate([0, -L2, 0])
					cube([w1, L2, H1]);

					translate([-g, -L2/2, H1])
					rotate([0, 90, 0])
					cylinder(d = l1, h = w1+2*g);

					translate([w1/2, -L2/2, H1])
					rotate([0, 90, 0])
					cylinder(d1 = l1, d2 = l2, h = w1/2+g);
				}

				translate([w1, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w2, L2, H1]);

					translate([-g, -L2/2, H1])
					rotate([0, 90, 0])
					cylinder(d = l2, h = w2+2*g);
				}

				translate([w1+w2, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w3, L2, H1]);

					translate([-g, -L2/2, H1])
					rotate([0, 90, 0])
					cylinder(d = l3, h = w3+2*g);
				}

				translate([w1+w2+w3+w4, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w5, L2, H1]);

					translate([-g, -L2/2-l5/2, H1-l5/2])
					cube([w5+2*g, l5, l5/2+g]);
				}

				translate([w1+w2+w3+w4+w5, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w6, L2, H1]);

					translate([-g, -L2/2-l6/2, H1-l6/2])
					cube([w6+2*g, l6, l6/2+g]);
				}

				translate([w1+w2+w3+w4+w5+w6, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w7, L2, H1]);

					translate([-g, -L2/2-l7/2, H1-l7/2])
					cube([w7+2*g, l7, l7/2+g]);
				}

				translate([w1+w2+w3+w4+w5+w6+w7, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w8, L2, H1]);

					translate([-g, -L2/2-l8/2, H1-l8/2])
					cube([w8+2*g, l8, l8/2+g]);
				}

				translate([w1+w2+w3+w4+w5+w6+w7+w8, 0, 0])
				difference()
				{
					translate([0, -L2, 0])
					cube([w9, L2, H1]);

					translate([-g, -L2/2-l9/2, H1-l9/2])
					cube([w9+2*g, l9, l9/2+g]);
				}
			}
		}

		// направляющие
		translate([0, 0, -1.1])
		union()
		{
			DW1 = DW/2+0.1;
			DW2 = DW/2-0.1;
			
			translate([0-g, -DW-g, H1])
			cube([W1+W2-DW2+g, DW1+g, 1.1+g]);

			translate([-g, -L2+DW2, H1])
			cube([W2+DW+2*g, DW1+g, 1.1+g]);

			translate([W2+DW2, -L1+DW2, H1])
			cube([W1-2*DW2, DW1+g, 1.1+g]);

			translate([W2+DW2, -L1+DW2, H1])
			cube([DW1+g, L1-L2+DW-DW2, 1.1+g]);

			translate([W1+W2-DW-g, -L1+DW2, H1])
			cube([DW1+g, L1-2*DW2, 1.1+g]);

			difference()
			{
				translate([W2+W1/2, -L2-D1/2, H1])
				cylinder(d = D1+g, h = 1.1+g);

				translate([W2+W1/2, -L2-D1/2, H1-g])
				cylinder(d = D1-2*DW1, h = 1.1+3*g);
			}
		}
	}
}

*fc_holder2();

module laser_holder1()
{
	DW = 2;    // толщина стенок
	L = 20.0;
	H = L/2;

	Fl = 24.5; // фокус линзы
	Dl = 12.7; // диаметр линзы
	Al = 30;   // угол для линзы
	Hl = 2.1;  // толщина линзы на краю

	Di0 = 12.0; // внешний диаметр лазеры
	Di1 = 10.0; // диаметр под линзу

	w1 = 2.0;
	w2 = Hl + 0.2;
	w3 = 1.0;
	w5 = 1.0;
	w4 = Fl - w3 - w2/2 - w5;
	w6 = 0.2;
	w7 = w5;
	w8 = w4;
	w9 = w1;
	w10 = w2;
	w11 = w3;
	w12 = 5.0;
	w13 = 1.0;
	w14 = 50.0;

	l1 = Dl - 1.0;
	l2 = Dl + 0.1;
	l3 = l1;
	l4 = L-2*DW;
	l5 = 5.0;
	l6 = 10.0;
	l7 = l5;
	l8 = l4;
	l9 = l1;
	l10 = l2;
	l11 = l3;
	l12 = l4;
	l13 = Di1;
	l14 = Di0+0.4;

	// большая части
	W1 = 70;
	L1 = 70;
	H1 = 10;
	D1 = 40;

	// меньшая часть
	W = w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13+w14;

	// часть коллиматора
	difference()
	{
		translate([0, -L, 0])
		cube([W, L, H]);

		translate([-g, -L+DW, DW])
		cube([W + 2*g, L-2*DW, H-DW+g]);
	}

	// направляющие
	union()
	{
		DW1 = DW/2-0.1;
		DW2 = DW/2+0.1;
		
		translate([DW, -DW, H])    cube([W-2*DW, DW1, 1.0]);
		translate([DW, -L+DW2, H]) cube([W-2*DW, DW1, 1.0]);
	}

	// перегородки
	union()
	{
		difference()
		{
			translate([0, -L, 0])
			cube([w1, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l1, h = w1+2*g);

			translate([w1/2, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d1 = l1, d2 = l2, h = w1/2+g);
		}

		translate([w1, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w2, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l2, h = w2+2*g);
		}

		translate([w1+w2, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w3, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l3, h = w3+2*g);
		}

		translate([w1+w2+w3+w4, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w5, L, H]);

			translate([-g, -L/2-l5/2, H-l5/2])
			cube([w5+2*g, l5, l5/2+g]);
		}

		translate([w1+w2+w3+w4+w5, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w6, L, H]);

			translate([-g, -L/2-l6/2, H-l6/2])
			cube([w6+2*g, l6, l6/2+g]);
		}

		translate([w1+w2+w3+w4+w5+w6, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w7, L, H]);

			translate([-g, -L/2-l7/2, H-l7/2])
			cube([w7+2*g, l7, l7/2+g]);
		}

		translate([w1+w2+w3+w4+w5+w6+w7+w8, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w9, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l9, h = w9+2*g);

			translate([w9/2, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d1 = l9, d2 = l10, h = w1/2+g);
		}
		
		translate([w1+w2+w3+w4+w5+w6+w7+w8+w9, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w10, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l10, h = w10+2*g);
		}

		translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w11, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l11, h = w11+2*g);
		}

		translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w13, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l13, h = w13+2*g);
		}

		translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13, 0, 0])
		difference()
		{
			translate([0, -L, 0])
			cube([w14, L, H]);

			translate([-g, -L/2, H])
			rotate([0, 90, 0])
			cylinder(d = l14, h = w14+2*g);
		}
	}
}

laser_holder1();

module laser_holder2()
{
	DW = 2;    // толщина стенок
	L = 20.0;
	H = L/2;

	Fl = 24.5; // фокус линзы
	Dl = 12.7; // диаметр линзы
	Al = 30;   // угол для линзы
	Hl = 2.1;  // толщина линзы на краю

	Di0 = 12.0; // внешний диаметр лазеры
	Di1 = 10.0; // диаметр под линзу

	w1 = 2.0;
	w2 = Hl + 0.2;
	w3 = 1.0;
	w5 = 1.0;
	w4 = Fl - w3 - w2/2 - w5;
	w6 = 0.2;
	w7 = w5;
	w8 = w4;
	w9 = w1;
	w10 = w2;
	w11 = w3;
	w12 = 5.0;
	w13 = 1.0;
	w14 = 50.0;

	l1 = Dl - 1.0;
	l2 = Dl + 0.1;
	l3 = l1;
	l4 = L-2*DW;
	l5 = 5.0;
	l6 = 10.0;
	l7 = l5;
	l8 = l4;
	l9 = l1;
	l10 = l2;
	l11 = l3;
	l12 = l4;
	l13 = Di1;
	l14 = Di0+0.4;

	// большая части
	W1 = 70;
	L1 = 70;
	H1 = 10;
	D1 = 40;

	// меньшая часть
	W = w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13+w14;

	mirror([0, 1, 0])
	difference()
	{
		union()
		{
			// часть коллиматора
			difference()
			{
				translate([0, -L, 0])
				cube([W, L, H]);

				translate([-g, -L+DW, DW])
				cube([W + 2*g, L-2*DW, H-DW+g]);
			}

			// перегородки
			union()
			{
				difference()
				{
					translate([0, -L, 0])
					cube([w1, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l1, h = w1+2*g);

					translate([w1/2, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d1 = l1, d2 = l2, h = w1/2+g);
				}

				translate([w1, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w2, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l2, h = w2+2*g);
				}

				translate([w1+w2, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w3, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l3, h = w3+2*g);
				}

				translate([w1+w2+w3+w4, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w5, L, H]);

					translate([-g, -L/2-l5/2, H-l5/2])
					cube([w5+2*g, l5, l5/2+g]);
				}

				translate([w1+w2+w3+w4+w5, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w6, L, H]);

					translate([-g, -L/2-l6/2, H-l6/2])
					cube([w6+2*g, l6, l6/2+g]);
				}

				translate([w1+w2+w3+w4+w5+w6, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w7, L, H]);

					translate([-g, -L/2-l7/2, H-l7/2])
					cube([w7+2*g, l7, l7/2+g]);
				}

				translate([w1+w2+w3+w4+w5+w6+w7+w8, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w9, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l9, h = w9+2*g);

					translate([w9/2, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d1 = l9, d2 = l10, h = w1/2+g);
				}
				
				translate([w1+w2+w3+w4+w5+w6+w7+w8+w9, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w10, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l10, h = w10+2*g);
				}

				translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w11, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l11, h = w11+2*g);
				}

				translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w13, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l13, h = w13+2*g);
				}

				translate([w1+w2+w3+w4+w5+w6+w7+w8+w9+w10+w11+w12+w13, 0, 0])
				difference()
				{
					translate([0, -L, 0])
					cube([w14, L, H]);

					translate([-g, -L/2, H])
					rotate([0, 90, 0])
					cylinder(d = l14, h = w14+2*g);
				}
			}
		}

		translate([0, 0, -1.1])
		union()
		{
			DW1 = DW/2+0.1;
			DW2 = DW/2-0.1;
			
			translate([DW-0.1, -DW-g, H])  cube([W-2*DW+0.1, DW1+g, 1.1+g]);
			translate([DW-0.1, -L+DW2, H]) cube([W-2*DW+0.1, DW1+g, 1.1+g]);
		}
	}
}

translate([0, 1, 0])
laser_holder2();

// ==================== VIEW ====================
module view()
{
	translate([0, 0, -B_H/2])
	box();

	translate([0, 0, B_H/2+B_H+30])
	{
		rotate([180, 0, 0])
		translate([0, 0, B_H2/2])
		cover();

		translate([B_W/2-25, (B_L/2-25), 0])
		labyr2();

		fh_holder();

		translate([0, 0, 10])
		rotate([0, 0, 45])
		fiber_sma_holder();

		translate([0, 0, -11.4])
		rotate([180, 0, 0])
		lens_holder1();

		translate([0, 0, -15.4])
		lens_holder2();
	}

	translate([0, 0, -T_H/2]) table();

	translate([0, 0, -C_H/2]) cartridge1();
	translate([0, 0, EH1/2-0.5]) electrode(EW1, EL1, EH1);

	*translate([0, 0, -C_H/2]) cartridge2();
	*translate([0, 0, EH2/2-0.5]) electrode(EW2, EL2, EH2);

	*translate([0, 0, -C_H/2]) cartridge3();
	*translate([0, 0, EH3/2-0.5]) electrode(EW3, EL3, EH3);

	color("silver")
	rotate([0, 0, -90])
	{
		n = 8;
		a0 = 360/n;
		for(a = [a0/2:a0:a0/2+(n-1)*a0])
		rotate([0, 0, a])
		{
			translate([15, 0, 0])
			probe_holder();

			translate([15, 0, 0])
			rotate([0, 10, 0])
			probe();

			translate([42, 0, M3K + 25])
			rotate([180, 0, 0])
			screw(M3D, 25, M3Dk, M3K);
		}
	}
}

*view();

*probe_holder();
*cartridge1();
*cartridge2();

*fh_holder();
*fiber_fc_holder();

