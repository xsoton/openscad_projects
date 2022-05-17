$fn = 100;
g = 0.001;
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

				*translate([L1-g, -W/2, S-H])
				cube([g, W, H]);

				translate([L1, -W/2, S-H])
				cube([L-L1, W, H]);
			}

			translate([L1, -W/2, S-H])
			cube([L-L1, W, H]);

			*translate([L-3, -W/2, 0])
			cube([3, W, S]);

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
			cylinder(d = PD2 + 2*G, h = PH1 + PH2);

			hull()
			{
				translate([L1, 0, -g])
				cylinder(d = 3.5, h = S + 2*g);

				translate([L-5, 0, -g])
				cylinder(d = 3.5, h = S + 2*g);
			}

			rotate([0, A, 0])
			translate([0, 0, H1+2*H2])
			cylinder(d1 = PD2 + 2*G, d2 = 1.5, h = 1.1);

			*hull()
			{
				sphere(d = 1.5);
				translate([0, 0, H2])
				sphere(d = 1.5);
			}
		}
	}
}

T_W = 90;
T_L = 90;
T_H = 5;

module table()
{
	W0 = T_W;
	L0 = T_L;
	H0 = T_H;

	W1 = 20;
	L1 = 25;
	H1 = 2;

	S1 = 10;
	S2 = 5;

	$fn = 20;

	difference()
	{
		cube([W0, L0, H0]);

		translate([(W0-W1)/2, L0-L1, H0-H1])
		cube([W1, L1+g, H1+g]);

		for(i = [2:1:7])
		for(j = [3:1:6])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, -g])
			cylinder(d = 4.2, h = H0 + 2*g);
		}

		for(i = [2:1:3])
		for(j = [7:1:8])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, -g])
			cylinder(d = 4.2, h = H0 + 2*g);
		}

		for(i = [6:1:7])
		for(j = [7:1:8])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, -g])
			cylinder(d = 4.2, h = H0 + 2*g);
		}

		for(i = [2:1:4])
		for(j = [2:1:5])
		{
			x = i * S2 + 3 * S1;
			y = j * S2 + 6 * S1;
			translate([x, y, (H0-H1)/2])
			cube([4.2, 4.2, (H0-H1) + 2*g], center = true);
		}

		for(i = [0:1:1])
		for(j = [0:1:1])
		{
			x = i * (W0-10) + 5;
			y = j * (L0-10) + 5;

			translate([x, y, -g])
			screw(M3D+0.5, H0 + 2*g, M3Dk+0.5, M3K);

			translate([x, y, H0+g])
			rotate([180, 0, 0])
			screw(M3D+0.5, H0 + 2*g, M3Dk+0.5, M3K);
		}
	}
}

module box()
{
	W = 100;
	L = 130;
	H = 35.0;

	Wi = T_W + 1.0;
	Li = T_L + 1.0;
	Hi = T_H + 30.0;

	D01 = 10.70 + 0.50;

	D11 =  9.20 + 0.50;
	D12 = 12.40 + 0.50;
	H12 =  1.55;

	D21 =  6.00 + 0.50;
	D22 = 12.00 + 2.00;
	H22 =  3.65;


	difference()
	{
		cube([W, L, H]);

		translate([3, 3, -g])
		cube([W - 6, L - 6, H + 2*g]);


		translate([W/2-10, 1.5, H/2]) rotate([-90,90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([W/2-10,  -g, H/2]) rotate([-90, 0,0]) screw_body(M3D +0.4,    3+2*g);
		translate([W/2+10, 1.5, H/2]) rotate([-90,90,0]) screw_nut (M3Nd+0.4, M3Nl+  g);
		translate([W/2+10,  -g, H/2]) rotate([-90, 0,0]) screw_body(M3D +0.4,    3+2*g);
	}

	difference()
	{
		cube([W, L, 5]);

		translate([15, 15,      -g]) cylinder(d = D01, h =   5 + 2*g);
		translate([35, 15,      -g]) cylinder(d = D01, h =   5 + 2*g);
		translate([55, 15,      -g]) cylinder(d = D11, h =   5 + 2*g);
		translate([55, 15,      -g]) cylinder(d = D12, h = H12 +   g);
		translate([80, 15,      -g]) cylinder(d = D21, h =   5 + 2*g);
		translate([80, 15, 5 - H22]) cylinder(d = D22, h = H22 +   g);
	}

	difference()
	{
		union()
		{
			translate([   0, L-95, 0]) cube([15, 10, H-5]);
			translate([   0, L-15, 0]) cube([15, 15, H-5]);
			translate([W-15, L-95, 0]) cube([15, 10, H-5]);
			translate([W-15, L-15, 0]) cube([15, 15, H-5]);
		}

		union()
		{
			translate([ +10, L-10, H-10-5]) cylinder(d = 4.2, h = 10 + g);
			translate([W-10, L-10, H-10-5]) cylinder(d = 4.2, h = 10 + g);
			translate([ +10, L-90, H-10-5]) cylinder(d = 4.2, h = 10 + g);
			translate([W-10, L-90, H-10-5]) cylinder(d = 4.2, h = 10 + g);
		}
	}

	translate([   0, L-95-3.2, 0]) cube([13, 1.2, H-5]);
	translate([W-13, L-95-3.2, 0]) cube([13, 1.2, H-5]);

	translate([    0, L-95-2, 0]) cube([5+3, 2, H-5]);
	translate([W-5-3, L-95-2, 0]) cube([5+3, 2, H-5]);
}

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

translate([-5, -35, -30])
!box();


























