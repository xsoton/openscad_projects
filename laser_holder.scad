$fn = 100;
g = 0.01;
pg = 0.4; // погрешность принтера

// винт M3
M3D  =  3.00;
M3Dk =  5.60;
M3K  =  1.65;
M3L  = 50.00-M3K;
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

module rider_ussr()
{
	// рейтер СССР
	ru_w1 = 35; // ширина ретера
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

module holder()
{
	W1 = 30.00;
	W2 = 17.90;
	H1 =  3.00;
	H2 = 17.90;
	D1 = 12.60;
	D2 =  3.45;
	L1 = 35.00;
	Y1 =  9.20;

	difference()
	{
		union()
		{
			translate([-W1/2, -L1/2, 0])
			cube([W1, L1, H1]);

			translate([-W2/2, -L1/2, 0])
			cube([W2, L1, H2]);
		}

		translate([0, 0, Y1])
		rotate([-90, 0, 0])
		cylinder(d = D1, h = L1+g, center = true);

		X0 = W2/2+(W1-W2)/4;
		Y0 = 14.5/2;
		for(x = [-X0:2*X0:X0])
		for(y = [-Y0:2*Y0:Y0])
		translate([x, y, -g])
		cylinder(d = D2, h = H1+2*g);
	}
}

module leg()
{
	W = 35;
	L = 35;
	H = 5;

	difference()
	{
		union()
		{
			*translate([0, 0, H/2])
			cube([W, L, H], center = true);

			hull()
			{
				translate([0, 0, H/2])
				cube([W, L, H], center = true);

				cylinder(d = g, h = 22);
			}

			hull()
			{
				translate([0, 0, 66-H/2])
				cube([W, L, H], center = true);

				translate([0, 0, 66-22])
				cylinder(d = g, h = 22);
			}

			intersection()
			{
				translate([0, 0, 33])
				cube([W, L, 66], center = true);

				an = 2;
				for(a = [45:180/an:45+180*(1-1/an)])
				{
					rotate([0, 0, a])
					translate([0, 0, 33])
					cube([35*sqrt(2), 2, 66], center = true);
				}
			}

			*cylinder(d = 12.5, h = 66);
		}

		for(x = [-5:10:5])
		for(y = [-10:20:10])
		translate([x, y, -g])
		cylinder(d = 4.2, 6+g);

		W1 = 30.00;
		W2 = 17.90;
		Y0 = W2/2+(W1-W2)/4;
		X0 = 14.5/2;
		for(x = [-X0:2*X0:X0])
		for(y = [-Y0:2*Y0:Y0])
		translate([x, y, 66-6])
		cylinder(d = 4.2, h = 6+g);

	}
}

// =============================================
module view()
{
	translate([0, 0, 0])
	rotate([0, 180, 0])
	rider_ussr();

	translate([0, -55, -15-10])
	rotate([90, 0, 0])
	cap1();

	translate([0, 0, 66])
	rotate([0, 0, 90])
	holder();

	leg();
}

// =============================================

view();

*rider_ussr();
*cap1();
*holder();
*leg();
