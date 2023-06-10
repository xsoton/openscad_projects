$fn = 100;
g = 0.01;
G = 0.051;
pg = 0.4; // погрешность принтера

// винт M3
M3D  =  3.00;
M3Dk =  5.60;
M3K  =  1.65;
M3L  = 50.00-M3K;
// гайка M3
M3Nd =  5.50/cos(30);
M3Nl =  3.00;

// гайка M2
M2Nd =  4.00/cos(30);
M2Nl =  1.60;

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

// module probe_holder()
// {
// 	A = 30;

// 	L = PH_L;
// 	H = PH_H;
// 	W = PH_W;

// 	L1 = L/2;

// 	W1 = 10.00;

// 	H1 =  4.00;
// 	H2 =  3.50;

// 	D1 =  1.30;
// 	D2 =  1.65;
// 	D3 =  2.00;

// 	S = (H1+2*H2)*cos(A)+(D3/2)*sin(A);

// 	difference()
// 	{
// 		union()
// 		{
// 			rotate([0, A, 0])
// 			translate([0, 0, H1])
// 			cylinder(d1 = D1, d2 = D2, h = H2);

// 			hull()
// 			{
// 				rotate([0, A, 0])
// 				translate([0, 0, H1 + H2])
// 				cylinder(d1 = D2, d2 = D3, h = H2);

// 				intersection()
// 				{
// 					rotate([0, A, 0])
// 					translate([0, 0, H1 + 2*H2])
// 					cylinder(d = D3, h = H2);

// 					translate([0, -W/2, S-H])
// 					cube([L, W, H]);
// 				}

// 				translate([L1, -W/2, S-H])
// 				cube([L-L1, W, H]);
// 			}

// 			translate([L1, -W/2, S-H])
// 			cube([L-L1, W, H]);

// 			translate([L-H/2, -W/2, 0])
// 			hull()
// 			{
// 				translate([0, 0, H/2])
// 				rotate([-90, 0, 0])
// 				cylinder(d = H, h = W);

// 				translate([0, 0, S-H/2])
// 				rotate([-90, 0, 0])
// 				cylinder(d = H, h = W);
// 			}
// 		}

// 		union()
// 		{
// 			rotate([0, A, 0])
// 			cylinder(d = PD2 + 4*G, h = PH1 + PH2);

// 			hull()
// 			{
// 				translate([L1-1, 0, -g])
// 				cylinder(d = 3.5, h = S + 2*g);

// 				translate([L-5, 0, -g])
// 				cylinder(d = 3.5, h = S + 2*g);
// 			}

// 			rotate([0, A, 0])
// 			translate([0, 0, H1+2*H2])
// 			cylinder(d1 = PD2 + 4*G, d2 = 2.5, h = 1.35);
// 		}
// 	}
// }

// module probe_holder2()
// {
// 	A = 30;

// 	L = PH_L;
// 	H = PH_H;
// 	W = PH_W;

// 	L1 = L/2;

// 	W1 = 10.00;

// 	H1 =  4.00;
// 	H2 =  3.50;

// 	D1 =  1.30;
// 	D2 =  1.65;
// 	D3 =  2.00;

// 	S = (H1+2*H2)*cos(A)+(D3/2)*sin(A);

// 	difference()
// 	{
// 		union()
// 		{
// 			rotate([0, A, 0])
// 			translate([0, 0, H1])
// 			cylinder(d1 = D1, d2 = D2, h = H2);

// 			hull()
// 			{
// 				rotate([0, A, 0])
// 				translate([0, 0, H1 + H2])
// 				cylinder(d1 = D2, d2 = D3, h = H2);

// 				intersection()
// 				{
// 					rotate([0, A, 0])
// 					translate([0, 0, H1 + 2*H2])
// 					cylinder(d = D3, h = H2);

// 					translate([0, -W/2, S-H])
// 					cube([L, W, H]);
// 				}

// 				translate([L1, -W/2, S-H])
// 				cube([L-L1, W, H]);
// 			}

// 			translate([L1, -W/2, S-H])
// 			cube([L-L1, W, H]);

// 			translate([L-H/2, -W/2, 0])
// 			hull()
// 			{
// 				translate([0, 0, H/2])
// 				rotate([-90, 0, 0])
// 				cylinder(d = H, h = W);

// 				translate([0, 0, S-H/2])
// 				rotate([-90, 0, 0])
// 				cylinder(d = H, h = W);
// 			}
// 		}

// 		union()
// 		{
// 			rotate([0, A, 0])
// 			cylinder(d = PD2 + 4*G, h = PH1 + PH2);

// 			hull()
// 			{
// 				translate([L1-1, 0, -g])
// 				cylinder(d = 3.5, h = S + 2*g);

// 				translate([L-5, 0, -g])
// 				cylinder(d = 3.5, h = S + 2*g);
// 			}

// 			*rotate([0, A, 0])
// 			translate([0, 0, H1+2*H2])
// 			cylinder(d1 = PD2 + 4*G, d2 = 2.5, h = 1.35);

// 			translate([0, 0, 5.3])
// 			rotate([0, 45+10, 0])
// 			translate([-11, -5, 0])
// 			cube([11, 11, 11]);
// 		}
// 	}
// }

module probe_holder3()
{
	A = 10;

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

			*rotate([0, A, 0])
			translate([0, 0, H1+2*H2])
			cylinder(d1 = PD2 + 4*G, d2 = 2.5, h = 1.35);

			translate([0, 0, 8.8])
			rotate([0, 45+10, 0])
			translate([-11, -5, 0])
			cube([11, 11, 11]);
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

		for(i = [-1:1:1])
		for(j = [-3:6:3])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, 0])
			cylinder(d = 4.2, h = H0 + g, center = true);
		}

		for(i = [-3:6:3])
		for(j = [-1:1:1])
		{
			x = i * S1;
			y = j * S1;
			translate([x, y, 0])
			cylinder(d = 4.2, h = H0 + g, center = true);
		}

		for(i = [-2.5:5:2.5])
		for(j = [-2.5:5:2.5])
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

		translate([-W/2+1.5  , +10, +5]) rotate([0,+90,0]) screw_nut (M3Nd+pg, M3Nl+  g);
		translate([-W/2+1.5+g, +10, +5]) rotate([0,-90,0]) screw_body(M3D +pg,    3+2*g);
		translate([-W/2+1.5  , -10, +5]) rotate([0,+90,0]) screw_nut (M3Nd+pg, M3Nl+  g);
		translate([-W/2+1.5+g, -10, +5]) rotate([0,-90,0]) screw_body(M3D +pg,    3+2*g);
		translate([-W/2+1.5  , +10, -5]) rotate([0,+90,0]) screw_nut (M3Nd+pg, M3Nl+  g);
		translate([-W/2+1.5+g, +10, -5]) rotate([0,-90,0]) screw_body(M3D +pg,    3+2*g);
		translate([-W/2+1.5  , -10, -5]) rotate([0,+90,0]) screw_nut (M3Nd+pg, M3Nl+  g);
		translate([-W/2+1.5+g, -10, -5]) rotate([0,-90,0]) screw_body(M3D +pg,    3+2*g);

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

module cover2()
{
	W = B_W;
	L = B_L;
	H = B_H+10;

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
			}

			translate([0, 0, d/2])
			difference()
			{
				cube([W-2*d  , L-2*d  , H+d  ], center = true);
				cube([W-2*d-2, L-2*d-2, H+d+g], center = true);
			}
		}

		translate([0, 0, -H/2-g])
		cylinder(d = 17.5, h = d+2*g);

		for(a = [0:120:360])
		rotate([0, 0, a])
		translate([25/2, 0, -H/2-g])
		cylinder(d = 3.1, h = d+2*g);

		for(a = [60:120:360])
		rotate([0, 0, a])
		translate([25/2, 0, -H/2-g])
		cylinder(d = 5+pg, h = d+2*g);

		for(a = [0:120:360])
		rotate([0, 0, a])
		translate([25/2, 0, -H/2-g])
		{
			translate([0, 0, 1.5])
			rotate([0, 0, 30])
			screw_nut (M3Nd+pg, d-g);
		}
	}
}

module rider_ussr()
{
	// рейтер СССР
	ru_w1 = B_H; // ширина ретера
	ru_l1 = 70; // ширина скамьи
	ru_h1 = 20; // высота ножек
	ru_d1 = 15; // толщина верхней стенки
	ru_d2 = 15; // толщина боковых стенок

	// основа
	translate([0, 0, ru_d1/2])
	difference()
	{
		cube([ru_w1, ru_l1+2*ru_d2, ru_d1], center = true);

		for(x = [-5:10:5])
		for(y = [-10:20:10])
		translate([x, y, -ru_d1/2 + 5])
		rotate([180, 0, 0])
		union()
		{
			screw(M3D+pg, ru_d1+g, M3Dk+pg, M3K);
			translate([0, 0, -ru_d1+g])
			cylinder(d = M3Dk+pg, h = ru_d1+g);
		}
	}

	// боковая часть под винт
	translate([0, -(ru_l1+ru_d2)/2, ru_d1+ru_h1/2])
	difference()
	{
		cube([ru_w1, ru_d2, ru_h1], center = true);

		rotate([-90, 0, 0])
		cylinder(d = 6.0 + pg, h = ru_d2+g, center = true);

		translate([0, (ru_d2-5.0+g)/2, 0])
		rotate([-90, 0, 0])
		cylinder(d = 11.2 + pg, h = 5.0+g, center = true, $fn = 6);

		translate([0, -(ru_d2-5.0+g)/2, 0])
		rotate([-90, 0, 0])
		cylinder(d = 11.2 + pg, h = 5.0+g, center = true, $fn = 6);
	}

	// боковая косая часть
	translate([0, (ru_l1+ru_d2)/2, ru_d1+ru_h1/2])
	hull()
	{
		translate([0, 0, -ru_h1/2])
		cube([ru_w1, ru_d2, g], center = true);

		translate([0, -ru_h1/tan(60+1/4), ru_h1/2])
		cube([ru_w1, ru_d2, g], center = true);
	}
}

module cap1()
{
	ru_h1 = 20;

	difference()
	{
		cylinder(d = ru_h1, h = 10);

		for(a = [0:30:360-30])
		rotate([0, 0, a])
		translate([ru_h1/2, 0, -g])
		cylinder(d = ru_h1/10, h = 10+2*g);

		translate([0, 0, -g])
		cylinder(d = 6.0 + pg, h = 10 - 5 + 2*g);

		translate([0, 0, 10-5])
		cylinder(d = 11.2, h = 5 + g, $fn = 6);
	}
}

// =============================================

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

*fiber_holder();

module lens_holder()
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

*lens_holder();

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
			cylinder(d = D0      , h = h1);
			cylinder(d = d0 + 5.0, h = h2);
		}

		for(a = [0:120:360])
		rotate([0, 0, a])
		translate([D1/2, 0, -g])
		cylinder(d = d3, h = h1+2*g);

		for(a = [60:120:360])
		rotate([0, 0, a])
		translate([D1/2, 0, -g])
		{
			translate([0, 0, h1/2])
			rotate([0, 0, 30])
			screw_nut (M3Nd+2*0.2, h2-2+g);
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

*fh_holder();

// =============================================

// =============================================
module view()
{
	translate([0, 0, -B_H/2])
	box();

	translate([0, 0, B_H/2+B_H])
	{
		rotate([180, 0, 0])
		translate([0, 0, B_H/2+5])
		#cover2();

		fh_holder();

		translate([0, 0, 10])
		rotate([0, 0, 45])
		fiber_holder();


		translate([0, 0, -11.4])
		rotate([180, 0, 0])
		lens_holder();

		translate([0, 0, -15.4])
		lens_holder();
	}


	W = 25;
	L = 25;

	translate([0, 0, -T_H/2])
	table();

	rotate([0, 0, -90])
	{
		translate([W/2, L/2, 0]) rotate([0, 0, 45])
		{
			probe_holder3();
			rotate([0, 10, 0]) probe();
		}

		translate([W/2, L/2, 0]) rotate([0, 0, 0])
		{
			probe_holder3();
			rotate([0, 10, 0]) probe();
		}

		translate([W/2, L/2, 0]) rotate([0, 0, 90])
		{
			probe_holder3();
			rotate([0, 10, 0]) probe();
		}


		translate([W/2, L/2, 0]) rotate([0, 0, -45])
		{
			probe_holder3();
			rotate([0, 10, 0]) probe();
		}

		color("Silver")
		{
			translate([37.50, -12.50, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
			translate([37.50, +12.50, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
			translate([31.25, +31.25, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
			translate([12.50, +37.50, +M3K + 25]) rotate([180, 0, 0]) screw(M3D, 25, M3Dk, M3K);
		}
	}

	translate([-B_W/2, 0, -B_H/2])
	rotate([0, -90, 0])
	rider_ussr();

	translate([-B_W/2-15-10, -35-30, -B_H/2])
	rotate([90, 0, 0])
	cap1();
}

// =============================================

view();

*box();
*cover();
*cover2();
*table();
*rider_ussr();
*cap1();
*probe_holder();
*probe_holder2();
*probe_holder3();

