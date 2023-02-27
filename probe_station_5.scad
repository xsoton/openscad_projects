$fn = 100;
g = 0.01;
G = 0.051;

// винт M3
M3D  =  3.00;
M3Dk =  5.60;
M3K  =  1.65;
M3L  = 50.00-M3Dk;
// гайка M3
M3Nd =  5.50/cos(30);
M3Nl =  3.00;

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

// электрод
EW = 10;
EL = 10;
EH = 0.45;

module electrode()
{
	color("red")
	translate([0, 0, EH/2])
	cube([EW, EL, EH], center = true);
}

PH_L = 50;
PH_H = 4;
PH_W = 7;

module probe_holder()
{
	A = 30;

	L = PH_L;
	H = PH_H;
	W = PH_W;

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
				translate([0, 0, H/2])
				rotate([-90, 0, 0])
				cylinder(d = H, h = W);

				translate([0, 0, S-H/2])
				rotate([-90, 0, 0])
				cylinder(d = H, h = W);
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

			rotate([0, A, 0])
			translate([0, 0, H1+2*H2])
			cylinder(d1 = PD2 + 4*G, d2 = 2.5, h = 1.35);
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
	W1 = 25;
	L1 = 25;
	H1 = 1;

	S1 = 12.5;

	$fn = 20;

	difference()
	{
		cube([W0, L0, H0], center = true);

		translate([0, 0, (H0-H1+g)/2])
		union()
		{
			cube([W1  , L1  , H1+g], center = true);
			cube([W1+4,    2, H1+g], center = true);
			cube([   2, L1+4, H1+g], center = true);
		}

		cylinder(d = 5, h = H0 + g, center = true);

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

		for(i = [-3:1:3])
		for(j = [-3:6:3])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, 0])
			cylinder(d = 4.2, h = H0 + g, center = true);
		}

		for(i = [-3:6:3])
		for(j = [-2:1:2])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, 0])
			cylinder(d = 4.2, h = H0 + g, center = true);
		}
	}
}

B_W = 150;
B_L = 150;
B_H = 35.0;

module box()
{
	W = B_W;
	L = B_L;
	H = B_H;

	d = 3;

	D1 = 14+0.4;
	H1 = 2;
	D2 = 11+0.4;
	H2 = 9;
	H21 = 1;

	difference()
	{
		cube([W, L, H], center = true);

		translate([0, 0, (d+g)/2])
		cube([W-2*d, L-2*d, H-d+g], center = true);

		translate([-W/2+1.5, +10, +5]) rotate([0,+90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([-W/2+1.5, +10, +5]) rotate([0,-90,0]) screw_body(M3D +0.4,    3+2*g);
		translate([-W/2+1.5, -10, +5]) rotate([0,+90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([-W/2+1.5, -10, +5]) rotate([0,-90,0]) screw_body(M3D +0.4,    3+2*g);
		translate([-W/2+1.5, +10, -5]) rotate([0,+90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([-W/2+1.5, +10, -5]) rotate([0,-90,0]) screw_body(M3D +0.4,    3+2*g);
		translate([-W/2+1.5, -10, -5]) rotate([0,+90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([-W/2+1.5, -10, -5]) rotate([0,-90,0]) screw_body(M3D +0.4,    3+2*g);

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

		// translate([15,      -g, 0]) rotate([-90, 0, 0]) cylinder(d = D01, h =   5 + 2*g);
		// translate([35,      -g, 0]) rotate([-90, 0, 0]) cylinder(d = D01, h =   5 + 2*g);
		// translate([55,      -g, 0]) rotate([-90, 0, 0]) cylinder(d = D11, h =   5 + 2*g);
		// translate([55,      -g, 0]) rotate([-90, 0, 0]) cylinder(d = D12, h = H12 +   g);
		// translate([80,      -g, 0]) rotate([-90, 0, 0]) cylinder(d = D21, h =   5 + 2*g);
		// translate([80, 5 - H22, 0]) rotate([-90, 0, 0]) cylinder(d = D22, h = H22 +   g);
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
	H = B_H;

	d = 3.1;

	difference()
	{
		cube([W, L, H], center = true);

		translate([0, 0, (d+g)/2])
		cube([W-2*d, L-2*d, H-d+g], center = true);
	}

	translate([0, 0, d/2])
	difference()
	{
		cube([W-2*d  , L-2*d  , H+d  ], center = true);
		cube([W-2*d-2, L-2*d-2, H+d+g], center = true);
	}
}

*translate([5, 140-5, 30])
rotate([0, 0, -90])
{
	//color("red")
	translate([50, 65+5, 5])
	rotate([0, 0, -90])
	{
		probe_holder();

		rotate([0, 30, 0])
		probe();
	}

	//color("red")
	translate([40, 65+5, 5])
	rotate([0, 0, -90])
	{
		probe_holder();

		rotate([0, 30, 0])
		probe();
	}

	table();

	color("Silver")
	{
		translate([40, 40, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		translate([50, 40, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		translate([50, 50, -M3K - 20])                     screw(M3D, 25, M3Dk, M3K);
	}
}

translate([0, 0, -B_H/2])
box();

*rotate([0, 180, 0])
translate([0, 0, -B_H/2-B_H])
cover();


W = 25;
L = 25;

translate([0, 0, -T_H/2])
table();

rotate([0, 0, -90])
{
	translate([W/2, L/2, 0]) rotate([0, 0, 45])
	{
		probe_holder();
		rotate([0, 30, 0]) probe();
	}

	translate([W/2, L/2, 0]) rotate([0, 0, 0])
	{
		probe_holder();
		rotate([0, 30, 0]) probe();
	}

	translate([W/2, L/2, 0]) rotate([0, 0, 90])
	{
		probe_holder();
		rotate([0, 30, 0]) probe();
	}


	translate([W/2, L/2, 0]) rotate([0, 0, -45])
	{
		probe_holder();
		rotate([0, 30, 0]) probe();
	}

	color("Silver")
	{
		translate([37.5, -12.5, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		translate([37.5, +12.5, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		translate([37.5, +37.5, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		translate([12.5, +37.5, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
	}
}








