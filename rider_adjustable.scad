$fn = 100;
g = 0.01;
pg = 0.4;

g_d = 11.4;
g_h1 = 4.9;
g_h2 = 18.1;

b_d1 = 5.8;

// рейтер СССР
ru_w1 = 60; // ширина ретера
ru_l1 = 70; // ширина скамьи
ru_h1 = 15; // высота ножек
ru_d1 = 10.0; // толщина верхней стенки
ru_d2 = 12.0; // толщина боковых стенок

ru_d3 = 20.0;

module gap(g = 0.4)
{
	minkowski()
	{
		children();
		sphere(d = g);
	}
}

module gaika(d = g_d, h = g_h1)
{
	cylinder(d=d, h=h, $fn=6);
}

module rider_base()
{
	cube([ru_w1, ru_l1+2*ru_d2, ru_d1]);
	
	translate([0, 0, ru_d1])
	difference()
	{
		cube([ru_w1, ru_d2, ru_h1]);
		
		translate([ru_w1/2, 0, ru_h1/2])
		rotate([-90, 0, 0])
		gap() cylinder(d = b_d1, h = ru_d2);
		
		translate([ru_w1/2, ru_d2/2-g_h1/2, ru_h1/2])
		hull()
		{
			rotate([-90, 30, 0])
			gap() gaika();
			
			translate([0, 0, ru_h1/2])
			rotate([-90, 30, 0])
			gap() gaika();
		}
	}
	
	translate([0, ru_d2+ru_l1, ru_d1])
	hull()
	{
		cube([ru_w1, ru_d2, g]);
		
		translate([0, -ru_h1/tan(60+1/4), ru_h1])
		cube([ru_w1, ru_d2, g]);
	}
}

module rider_adj_base()
{
	difference()
	{
		cube([ru_w1, ru_l1+2*ru_d2, 2*ru_d2]);
		
		translate([ru_d2, ru_d2, -g])
		cube([ru_w1-2*ru_d2, ru_l1+ru_d2+g, 2*ru_d2+2*g]);
		
		translate([ru_d2/2, ru_d2, -g])
		cube([ru_w1-ru_d2, ru_l1+ru_d2+g, ru_d2/2+pg+g]);
		
		translate([ru_w1/2, 0, ru_d2/2+g_d/2])
		rotate([-90, 0, 0])
		gap() cylinder(d=2*b_d1, h=ru_d2);
		
		translate([ru_w1/2, ru_d2-2, ru_d2/2+g_d/2])
		rotate([-90, 0, 0])
		gap() cylinder(d=3*b_d1, h=2+g);
	}
	
	*translate([ru_w1/2, 2*ru_d2, ru_d2/2+g_d/2])
	rotate([-90, 30, 0])
	gaika(h=g_h2);
}

module rider_gaika1()
{
	difference()
	{
		union()
		{
			cylinder(d=2*b_d1, h=ru_d2);
			
			translate([0, 0, ru_d2-2])
			cylinder(d=3*b_d1, h=2+g);
		}
		
		gap() cylinder(d=5, h=ru_d2);
	}
}

module rider_gaika2()
{
	difference()
	{
		cylinder(d=2*g_d, h=6);
		gap() cylinder(d=b_d1, h=6);
		gap() gaika();
		
		for(a=[0:60:300])
		rotate([0, 0, a])
		translate([g_d, 0, -g])
		cylinder(d=b_d1, h=6+2*g);
	}
}

translate([ru_w1/2, -6, ru_d2/2+g_d/2])
rotate([-90, 0, 0])
rider_gaika2();

rider_adj_base();

translate([ru_w1, 0, 0])
rotate([180, 0, 180])
rider_base();
