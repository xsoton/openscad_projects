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
	translate([0, 0, K])
	screw_body(D, L);
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
PH_H = 7;
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

					translate([0, -W/2, (H1+2*H2)*cos(A)+(D3/2)*sin(A)-H])
					cube([L, W, H]);
				}

				translate([L1-g, -W/2, (H1+2*H2)*cos(A)+(D3/2)*sin(A)-H])
				cube([g, W, H]);
			}

			translate([L1, -W/2, (H1+2*H2)*cos(A)+(D3/2)*sin(A)-H])
			cube([L-L1, W, H]);

			translate([L-3, -W/2, 0])
			cube([3, W, H]);
		}

		union()
		{
			rotate([0, A, 0])
			cylinder(d = PD2 + 2*G, h = PH1 + PH2);

			hull()
			{
				translate([L1, 0, (H1+2*H2)*cos(A)+(D3/2)*sin(A)-H-g])
				cylinder(d = 3.5, h = H + 2*g);

				translate([L-5, 0, (H1+2*H2)*cos(A)+(D3/2)*sin(A)-H-g])
				cylinder(d = 3.5, h = H + 2*g);
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

module table()
{
	W0 = 90;
	L0 = 90;
	H0 = 5;

	W1 = 30;
	L1 = 30;
	H1 = 1;

	S1 = 10;
	S2 = 5;

	$fn = 20;

	difference()
	{
		cube([W0, L0, H0]);

		translate([(W0-W1)/2, L0-L1, H0-H1])
		cube([W1, L1+g, H1+g]);

		for(i = [1:1:8])
		for(j = [1:1:5])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, -g])
			cylinder(d = 4.2, h = H0 + 2*g);
		}

		for(i = [1:1:2])
		for(j = [1:1:3])
		{
			x = i * S1;
			y = j * S1 + 5 * S1;
			translate([x, y, -g])
			cylinder(d = 4.2, h = H0 + 2*g);
		}

		for(i = [1:1:2])
		for(j = [1:1:3])
		{
			x = i * S1 + 6 * S1;
			y = j * S1 + 5 * S1;
			translate([x, y, -g])
			cylinder(d = 4.0, h = H0 + 2*g);
		}

		for(i = [1:1:5])
		for(j = [1:1:5])
		{
			x = i * S2 + 3 * S1;
			y = j * S2 + 6 * S1;
			translate([x, y, (H0-H1)/2])
			cube([4.2, 4.2, (H0-H1) + 2*g], center = true);
		}
	}
}

*probe_holder();

*rotate([0, 30, 0])
probe();

table();




























