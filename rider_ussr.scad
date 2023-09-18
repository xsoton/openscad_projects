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
	ru_de =  5; // сдвиг прямой боковой стенки

	// основа
	translate([0, 0, ru_d1/2])
	difference()
	{
		translate([-ru_w1/2, -ru_l1/2-ru_d2-ru_de, -ru_d1/2])
		cube([ru_w1, ru_l1+2*ru_d2+ru_de, ru_d1]);

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
	translate([0, -(ru_l1+ru_d2)/2-ru_de, ru_d1+ru_h1/2])
	difference()
	{
		cube([ru_w1, ru_d2, ru_h1], center = true);

		rotate([-90, 0, 0])
		cylinder(d = 6.0 + pg, h = ru_d2+g, center = true);

		translate([0, (ru_d2-5.0+g)/2, 0])
		rotate([-90, 90, 0])
		cylinder(d = 11.2 + pg, h = 5.0+g, center = true, $fn = 6);

		translate([0, -(ru_d2-5.0+g)/2, 0])
		rotate([-90, 90, 0])
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
		cylinder(d = 11.2 + pg, h = 5 + g, $fn = 6);
	}
}

// moving part
module mp()
{
	mp_w1 = 35; // ширина подвижной части
	mp_l1 = 70; // ширина скамьи
	mp_h1 = 20; // высота ножек
	mp_d0 = 10; // толщина верхней стенки
	mp_d1 =  5; // толщина глухой стенки
	mp_d2 =  5; // толщина боковых стенок
	mp_d3 = 15; // толщина стенки под гайки

}

module plate()
{
	// рейтер СССР
	ru_w1 = 45; // ширина ретера
	ru_l1 = 70; // ширина скамьи
	ru_h1 = 0; // высота ножек
	ru_d1 = 5; // толщина верхней стенки
	ru_d2 = 15; // толщина боковых стенок
	ru_de =  5; // сдвиг прямой боковой стенки

	// основа
	//translate([0, 0, ru_d1/2])
	difference()
	{
		translate([0, -ru_de/2, 0])
		cube([ru_w1, ru_l1+2*ru_d2+ru_de, ru_d1], center = true);

		for(x = [-5:10:5])
		for(y = [-10:20:10])
		translate([x, y, 0])
		{
			translate([0, 0, -ru_d1/2-g])
			screw_body(M3D+pg, ru_d1+2*g);

			translate([0, 0, ru_d1/2-M3Nl])
			screw_nut(M3Nd + pg, M3Nl+g);
		}
	}
}

// =============================================
module view()
{
	rotate([0, 180, 0])
	rider_ussr();

	translate([0, -70/2-5-15-10, -15-20/2])
	rotate([90, 0, 0])
	cap1();

	plate();
}

// =============================================

view();

*rider_ussr();
*plate();


