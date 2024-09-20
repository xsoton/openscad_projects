include <screw.scad>

$fn = 100;

g  = 0.010; // технический зазор
G  = 0.051; // разрешение фотополимерного принтера
pg = 0.400; // погрешность FDM принтера


// параметры контакта p50b1
// PD1 =  0.500; // диаметр острия
// PD2 =  0.680; // диаметр оболочки
// PH0 =  0.433; // высота заточки
// PH1 =  3.350; // высота острия
// PH2 = 13.000; // высота оболочки

// параметры контакта PA030-B
PD1 =  0.200; // диаметр острия
PD2 =  0.300; // диаметр оболочки
PH0 =  0.1/tan(15); // высота заточки
PH1 =  1.500; // высота острия
PH2 = 10.000; // высота оболочки

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

C_w3 = 13.780;
C_l3 = 12.800;

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
		text("13.780 x 12.800", size = 1.8, halign = "center", valign = "center");
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

module fiber_holder()
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
		fiber_holder();

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


C1w =  5.1;
C1l = 20.6;
C1h =  2.5;

C2w = 11.0;
C2l = 38.9;
C2h =  1.5;

C3w =  8.0;
C3l = 36.0;
C3h =  3.0;

C4w =  5.1;
C4l = 20.7;
C4h =  1.8;

module connector_top()
{
	difference()
	{
		union()
		{
			translate([0, 0, C1h/2])             cube([C1w, C1l, C1h], center = true);
			translate([0, 0, C1h+C2h/2])         cube([C2w, C2l, C2h], center = true);
			translate([0, 0, C1h+C2h+C3h/2])     cube([C3w, C3l, C3h], center = true);
		}
		translate([0, 0, C1h+C2h+C3h-C4h/2]) cube([C4w, C4l, C4h+g], center = true);
	}
}

C5w = 11.0;
C5l = 38.9;
C5h =  1.5;

C6w =  8.0;
C6l = 36.0;
C6h =  3.0;

C7w =  5.1;
C7l = 20.5;
C7h =  1.4;

module connector_bottom()
{
	translate([0, 0, C5h/2])         cube([C5w, C5l, C5h], center = true);
	translate([0, 0, C5h+C6h/2])     cube([C6w, C6l, C6h], center = true);
	translate([0, 0, C5h+C6h+C7h/2]) cube([C7w, C7l, C7h], center = true);
}



module plate_bottom()
{
	H = 1.5;

	difference()
	{
		translate([0, 0, H/2])
		cube([30+C2w-2*g, C2l+5, H], center = true);

		for(x=[-15,15])
		translate([x, 0, H/2])
		cube([C5w+2*G, C5l+2*G, H+2*g], center = true);

		translate([-EW3/6, 0, H/2+(H/2+g)/2]) cube([1, EL3+10, H/2+g], center = true);
		translate([+EW3/6, 0, H/2+(H/2+g)/2]) cube([1, EL3+10, H/2+g], center = true);

		translate([0, (C2l+5)/2-2, H-0.5])
		linear_extrude(0.5+g)
		text("13.78 x 12.80", size = 1.8, halign = "center", valign = "center");

		translate([0, (C2l+5)/2-5, H-0.5])
		linear_extrude(0.5+g)
		text("MD2", size = 1.8, halign = "center", valign = "center");
	}

	difference()
	{
		translate([0, 0, H+1/2])
		cube([EW3+2, EL3+2, 1], center = true);

		translate([0, 0, H+(1+g)/2])
		cube([EW3+2*G, EL3+2*G, 1+g], center = true);

		translate([0, 0, H+(1+g)/2])
		cube([EW3-2, EL3+2+2*g, 1+g], center = true);

		translate([0, 0, H+(1+g)/2])
		cube([EW3+2+2*g, EL3-2, 1+g], center = true);
	}
}

module plate_top()
{
	H = C1h-G;

	difference()
	{
		union()
		{
			translate([0, 0, H/2])
			cube([30+C2w, C2l, H], center = true);

			translate([0, 0, (10-1.5)/2])
			cube([EW3+2, EL3+2, 10-1.5], center = true);
		}

		union()
		{
			for(x=[-15,15])
			translate([x, 0, H/2])
			cube([C1w+2*G, C1l+2*G, H+2*g], center = true);

			translate([0, 0, (10-1.5)/2])
			cube([EW3-2*3.5, EL3-2*2.0, 10-1.5+2*g], center = true);

			for(x=[-5.2, 5.2])
			{
				for(i=[0:1:3])
				{
					y = 0.7 + i*1.4;
					translate([x, y, -g])
					{
						cylinder(d=0.4, h=10-1.5+2*g);
						cylinder(d=1.1, h=1);
					}
				}

				for(i=[0:-1:-3])
				{
					y = -0.7 + i*1.4;
					translate([x, y, -g])
					{
						cylinder(d=0.4, h=10-1.5+2*g);
						cylinder(d=1.1, h=1);
					}
				}
			}

			for(x=[-4.0, 4.0])
			for(i=[-3:1:3])
			{
				y = i*1.4;
				translate([x, y, -g])
					{
						cylinder(d=0.4, h=10-1.5+2*g);
						cylinder(d=1.1, h=1);
					}
			}

			// translate([0, C2l/2-2, 0.5])
			// rotate([0, 180, 0])
			// linear_extrude(0.5+g)
			// text("MD2", size = 1.8, halign = "center", valign = "center");
		}
	}
}

module view2()
{

	for(x = [-15, 15])
	translate([x,0,])
	{
		color("Gray")
		translate([0, 0, 0])
		connector_bottom();
		
		color("Gray")
		translate([0, 0, C1h+C2h+C3h-C4h+C5h+C6h+C7h])
		rotate([0, 180, 0])
		connector_top();
	}

	translate([0, 0, EH3/2+1.5]) electrode(EW3, EL3, EH3);

	translate([0, 0, C1h+C2h+C3h-C4h+C5h+C6h+C7h-PH1-PH2+1.5])
	{
		for(x=[-5.2, 5.2])
		{
			for(i=[0:1:3])
			{
				y = 0.7 + i*1.4;
				translate([x, y, 0]) probe();
			}

			for(i=[0:-1:-3])
			{
				y = -0.7 + i*1.4;
				translate([x, y, 0]) probe();
			}
		}

		for(x=[-4.0, 4.0])
		for(i=[-3:1:3])
		{
			y = i*1.4;
			translate([x, y, 0]) probe();
		}
	}

	translate([0, 0, 0])
	plate_bottom();

	translate([0, 0, C1h+C2h+C3h-C4h+C5h+C6h+C7h])
	rotate([0, 180, 0])
	plate_top();

}

*view2();

plate_top();
