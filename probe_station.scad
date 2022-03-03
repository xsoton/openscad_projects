$fn = 100;
g = 0.001;

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

// транслятор
W0 = 50.00; // ширина столика
L0 = 50.00; // длина  столика
H0 = 10.00; // высота столика

W1 =  8.00; // ширина язычка
L1 =  L0/5; // длина  язычка
H1 =  8.00; // высота язычка
W2 =  g; // ширина верхушки язычка

G  =  0.05; // зазор

module translation_table()
{
	difference()
	{
		// столик
		cube([W0, L0, H0]);

		// салазки
		hull()
		{
			l = 3*L0/5;
			h = H1-(W1-W2)*tan(30)/2;
			translate([W0/2-W1/2, L0/2-l/2, H0-h ]) cube([W1, l, h+g]);
			translate([W0/2-W2/2, L0/2-l/2, H0-H1]) cube([W2, l,   g]);
		}

		// вырез под основной винт
		translate([W0/2, 0, H0-H1/2])
		union()
		{
			hull()
			{
				rotate([-90, 0, 0])
				screw_hat(M3D, M3Dk, M3K);

				translate([0, -g, 0])
				rotate([-90, 0, 0])
				cylinder(d = M3Dk, h = g);
			}

			translate([0, -g, 0])
			rotate([-90, 0, 0])
			screw_body(M3D, L0+2*g);

			translate([0, L1/2, 0])
			rotate([-90, 0, 0])
			cylinder(d = 5, h = L1/2+g);
		}

		// вырезы под крепления
		for (nx = [-1:2:1], ny = [-1:2:1])
		{
			translate([W0*(1+0.6*nx)/2, L0*(1+0.6*ny)/2, 0])
			{
				translate([0, 0, -g])
				screw_body(M3D, H0+2*g);

				translate([0, 0, H0/2+M3K+g])
				rotate([180, 0, 0])
				screw_hat(M3D, M3Dk, M3K);

				translate([0, 0, H0/2+M3K])
				cylinder(d = M3Dk, h = H0/2-M3K+g);

				translate([0, 0, -g])
				rotate([0, 0, 30])
				screw_nut(M3Nd, M3Nl+g);
			}
		}
	}
}

module translation_nut()
{
	difference()
	{
		// язычек
		hull()
		{
			w1 = W1-2*G;
			h1 = H1-G;
			h  = h1-(w1-W2)*tan(30)/2;
			translate([W0/2-L1/2, L0/2-w1/2, -h ]) cube([L1, w1, h]);
			translate([W0/2-L1/2, L0/2-W2/2, -h1]) cube([L1, W2, g]);
		}

		// вырез под гайку
		translate([W0/2, L0/2, -H1/2])
		union()
		{
			rotate([0, 90, 0])
			translate([0, 0, -L1/2-g])
			screw_body(M3D, L1+2*g);

			rotate([0, -90, 0])
			translate([0, 0, 0.5])
			cylinder(d = 5, h = (L1-1)/2+g);

			rotate([0, 90, 0])
			translate([0, 0, 0.5])
			screw_nut(M3Nd, (L1-1)/2+g);
		}
	}
}

module translation()
{
	translation_table();
	translation_nut();
}

module table()
{
	translate([+1*W0/2, -L0/2, -H0]) translation_table();
	translate([-1*W0/2, -L0/2, -H0]) cube([W0, L0, H0]);
	translate([-3*W0/2, -L0/2, -H0]) translation_table();
}

// module probe_holder()
// {
// 	A = 30;

// 	rotate([0, A, 0])
// 	translate([0, 0, 4])
// 	cylinder(d1 = 1.3, d2 = 1.65, h = 3.5);

// 	hull()
// 	{
// 		rotate([0, A, 0])
// 		translate([0, 0, 4+3.5])
// 		cylinder(d1 = 1.65, d2 = 2, h = 3.5);

// 		translate([25-g, 0, 2.5])
// 		rotate(a=[0, 90, 0])
// 		cylinder(d1 = 0, d2 = 5, h = g);
// 	}

// 	translate([25, -W1/2, 0])
// 	cube([50, W1, W1]);

// 	rotate([0, A, 0])
// 	probe();
// }

module probe_holder_table()
{
	H0 = 5;
	difference()
	{
		union()
		{
			// столик
			cube([W0, L0, H0]);

			translate([(W0-L1)/2, (L0-W1)/2, H0])
			cube([L1, W1/5, H1]);

			translate([(W0-L1)/2, (L0+W1-W1/5)/2, H0])
			cube([L1, W1/5, H1]);
		}

		// вырезы под крепления
		for (nx = [-1:2:1], ny = [-1:2:1])
		{
			translate([W0*(1+0.6*nx)/2, L0*(1+0.6*ny)/2, 0])
			{
				translate([0, 0, -g])
				screw_body(M3D, H0+2*g);

				translate([0, 0, H0/2+M3K+g])
				rotate([180, 0, 0])
				screw_hat(M3D, M3Dk, M3K);

				translate([0, 0, H0/2+M3K])
				cylinder(d = M3Dk, h = H0/2-M3K+g);

				*translate([0, 0, -g])
				rotate([0, 0, 30])
				screw_nut(M3Nd, M3Nl+g);
			}
		}
	}
}

union()
{
	table();

	translate([+2*W0/2, 0, 1])                 rotate([0, 0, 90]) translate([-W0/2, -L0/2, 0]) translation();
	translate([-2*W0/2, 0, 1]) mirror([1,0,0]) rotate([0, 0, 90]) translate([-W0/2, -L0/2, 0]) translation();

	translate([0, 0, 1+H0+1+H0/2])
	union()
	{
		electrode();

		*translate([EW/2-1, 0, EH])
		rotate([0, 45, 0])
		probe();

		*translate([-EW/2+1, 0, EH])
		rotate([0, -45, 0])
		probe();
	}
}

translate([+3*W0/2, -L0/2, 1+H0+1])
mirror([1, 0, 0])
probe_holder_table();