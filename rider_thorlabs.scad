$fn = 200;
g = 0.001;
pg = 0.4; // погрешность принтера

// рейтер СССР
ru_w1 = 50; // ширина ретера
ru_l1 = 70; // ширина скамьи
ru_h1 = 15; // высота ножек
ru_d1 = 6.0+5.0;// толщина верхней стенки
ru_d2 = 6.0; // толщина боковых стенок

sx = 25.4;
sy = 0.75*25.4;

// винты для крепления
sc1_d1 = 5.5;
sc1_d2 = 3.2;
sc1_h2 = 2.0;
sc1_h1 = ru_d1-sc1_h2;

sc_d1 =  2.2; // внутренний диаметр
sc_d2 =  3.0; // внешний диаметр
sc_d3 =  5.2; // диаметр шляпки
sc_h1 =  2.0; // высота под патай
sc_h2 =  1.8; // высота шляпки
sc_h3 = 10.0; // длина винта

// прищепка - основа
p1_w1 = 10;
p1_l1 = 9.5;
p1_h1 = 90;

module sc1()
{
	translate([0, 0, -g])
	cylinder(d = sc1_d1+pg, h = sc1_h1+g);
	translate([0, 0, sc1_h1-g])
	cylinder(d = sc1_d2+pg, h = sc1_h2+2*g);
}

module screw_body()
{
	translate([0, 0, -sc_h3])
	cylinder(d=sc_d1+pg, h=sc_h3+g);
}

module screw_hat()
{
	hull()
	{
		translate([0, 0, -g])
		cylinder(d=sc_d2+pg, h=g);
		translate([0, 0, sc_h2])
		cylinder(d=sc_d3+pg, h=g);
	}
}

module screw_head()
{
	translate([0, 0, -g])
	cylinder(d=sc_d2+pg, h=sc_h1-sc_h2+2*g);
	
	translate([0, 0, sc_h1-sc_h2])
	screw_hat();
}

module rider_ussr()
{
	difference()
	{
		cube([ru_w1, ru_l1+2*ru_d2, ru_d1]);
		
		translate([ru_w1/2 - sx/2, ru_d2 + ru_l1/2 - sy/2, ru_d1])
		rotate([180, 0, 0])
		sc1();
		
		translate([ru_w1/2 - sx/2, ru_d2 + ru_l1/2 + sy/2, ru_d1])
		rotate([180, 0, 0])
		sc1();
		
		translate([ru_w1/2 + sx/2, ru_d2 + ru_l1/2 - sy/2, ru_d1])
		rotate([180, 0, 0])
		sc1();
		
		translate([ru_w1/2 + sx/2, ru_d2 + ru_l1/2 + sy/2, ru_d1])
		rotate([180, 0, 0])
		sc1();
	}
	
	translate([0, 0, ru_d1])
	difference()
	{
		cube([ru_w1, ru_d2, ru_h1]);
		
		translate([ru_w1/2, -g, ru_h1/2])
		rotate([-90, 0, 0])
		cylinder(d = 3.0 + pg, h = ru_d2 + 2*g);
		
		translate([ru_w1/2, ru_d2-4.0, ru_h1/2])
		rotate([-90, 0, 0])
		cylinder(d = 3.7 + pg, h = 4.0 + g);
	}
	
	translate([0, ru_d2+ru_l1, ru_d1])
	hull()
	{
		cube([ru_w1, ru_d2, g]);
		
		translate([0, -ru_h1/tan(60+1/4), ru_h1])
		cube([ru_w1, ru_d2, g]);
	}
}

module view()
{
	rider_ussr();
}

module print_fdm()
{
	rider_ussr();
}

view();
*print_fdm();