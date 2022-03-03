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
W0 = 50.00;
W1 = 10.00;
W2 = 20.00;

L0 = 50.00;
L1 = 30.00;

H0 =  7.00;
H2 =  5.00;
H1 = (H0-H2)/2;
H3 = H1;

G  =  0.05;

module base()
{
	difference()
	{
		union()
		{
			translate([-W0/2, -L0/2, 0])
			cube([W0, L0, H0]);
		}

		union()
		{
			translate([-W1/2, -L1/2, -g])
			cube([W1, L1, H1+2*g]);

			hull()
			{
				translate([-W1/2, -L1/2, H1])
				cube([W1, L1, g]);

				translate([-W2/2, -L1/2, H1+H2])
				cube([W2, L1, H3+g]);
			}
		}
	}
}

!base();
