$fn = 200;
g = 0.001;

// винты для губок
sc_d1 =  2.2; // внутренний диаметр
sc_d2 =  3.0; // внешний диаметр
sc_d3 =  5.2; // диаметр шляпки
sc_h1 =  2.0; // высота под патай
sc_h2 =  1.8; // высота шляпки
sc_h3 = 10.0; // длина винта

// пружина
s_d1 =  5.0; // внешний диаметр
s_h1 = 12.0; // длина
s_h2 = 18.0; // вынос
s_dx =  9.5; // максимальная ширина прищепки

// прищепка - основа
p1_w1 = 10;
p1_l1 = s_dx;
p1_h1 = 90;

// прицепка - дополнительная часть
p2_w1 = 10;
p2_w2 = 2;
p2_l1 = s_dx;
p2_h1 = 40;
p2_h2 = 50;

// электрод
e_w = 7.66;
e_h = 23.1;
e_l = 0.5;

// контакт
c_w = 2.54;
c_l = 5.0;
c_h = 8.68;

module screw_head()
{
	translate([0, 0, -g])
	cylinder(d=sc_d2, h=sc_h1-sc_h2+2*g);
	hull()
	{
		translate([0, 0, sc_h1-sc_h2])
		cylinder(d=sc_d2, h=g);
		translate([0, 0, sc_h1])
		cylinder(d=sc_d3, h=g);
	}
}

module screw_body()
{
	translate([0, 0, -sc_h3])
	cylinder(d=sc_d1+0.2, h=sc_h3+g);
}

module spring_case()
{
	gap = 0.4;
	
	rotate([90,0,0])
	cylinder(d=s_d1+gap, h=s_h1+gap, center=true);
	
	translate([s_h2, 0, 10/2])
	rotate([90,0,0])
	cylinder(d=2.0, h=s_h1+gap, center=true);
	
	translate([s_h2, 0, -10/2])
	rotate([90,0,0])
	cylinder(d=2.0, h=s_h1+gap, center=true);
}

module plank_fixed()
{
	difference()
	{
		union()
		{
			translate([0, -p1_l1/2, 0])
			cube([p1_w1, p1_l1, p1_h1]);
			
			translate([p1_w1, -p1_l1/2, 0])
			cube([p1_w1, p1_l1, sc_h3+2]);
		}
		
		translate([-g, -p1_l1/2-g, -g])
		cube([0.5+g, p1_l1+2*g, p1_h1+2*g]);
		
		translate([6, 0, p1_h1])
		screw_body();
		
		translate([p1_w1/2, 0, 0])
		rotate([180, 0, 0])
		screw_body();
		
		translate([p1_w1*3/2, 0, 0])
		rotate([180, 0, 0])
		screw_body();
	}
}

module plank_free()
{
	difference()
	{
		hull()
		{
			translate([-p2_w1, -p2_l1/2, p2_h2])
			cube([p2_w1, p2_l1, p2_h1]);

			translate([-p2_w1, -p2_l1/2, 5])
			cube([p2_w2, p2_l1, p2_h2-5]);
		}
		
		translate([-0.5, -p2_l1/2-g, p2_h2-g])
		cube([0.5+g, p2_l1+2*g, p2_h1+2*g]);
		
		translate([-6, 0, p2_h1+p2_h2])
		screw_body();
	}
}

module ebox()
{
	difference()
	{
		cube([p1_w1, p1_l1, sc_h1]);
		
		translate([p1_w1-4, p1_l1/2, 0])
		screw_head();
	}
	
	difference()
	{
		translate([0, 0, sc_h1])
		cube([3, p1_l1, 10-sc_h1]);
		
		translate([0.4, (p1_l1-e_w-0.2)/2, sc_h1-g])
		cube([e_l+0.2, e_w+0.2, 10-sc_h1+2*g]);
		
		translate([-g, (p1_l1-e_w+2)/2, sc_h1-g])
		cube([0.4+2*g, e_w-2, 10-sc_h1+2*g]);
	}
}

module connector()
{
	translate([-2.54, 0, 0])
	rotate([0, 0, -90])
	translate([0, 0.635, 3.5433])
	rotate([0, 180, 0])
	import("70AAJ2MO.stl");
}

module cbox()
{
	difference()
	{
		cube([p2_w1, p2_l1, sc_h1]);
		
		translate([4, p2_l1/2, 0])
		screw_head();
	}
	
	difference()
	{
		translate([p2_w1-4, 0, sc_h1])
		cube([4, p1_l1, 10-sc_h1]);
		
		translate([p2_w1-c_w-0.2-0.4, (p2_l1-c_l-0.2)/2, sc_h1-g])
		cube([c_w+0.2, c_l+0.2, 10-sc_h1+2*g]);
		
		translate([p2_w1-4-g, (p2_l1-c_l+1)/2, sc_h1-g])
		cube([4+2*g, c_l-1, 10-sc_h1+2*g]);
	}
}

module way()
{
	difference()
	{
		translate([-28+p1_w1, -(p1_l1+4)/2, 0])
		cube([28+2, p1_l1+4, 10]);
		
		translate([0.5-0.2, -(p1_l1+4)/2 + 2-0.2, -g])
		cube([p1_w1-0.5+0.4, p1_l1+0.4, 10+2*g]);
		
		translate([-28+p1_w1+2, -(p2_l1+4)/2 + 2-0.2, -g])
		cube([28-p1_w1-2-0.3+g, p1_l1+0.4, 10+2*g]);
	}
}

module rider()
{
	
}

//translate([0, 0, p1_l1/2])
//rotate([-90, 0, 0])
union()
{
	color("red")
	translate([0, -p1_l1/2, p1_h1])
	ebox();

	color("yellow")
	translate([-0.4-0.1, 0, p2_h1+p2_h2+sc_h1])
	connector();

	color("blue")
	translate([-p2_w1, -p1_l1/2, p1_h1])
	cbox();

	difference()
	{
		union()
		{
			color("salmon")
			plank_fixed();
			
			color("aqua")
			plank_free();
		}
		
		translate([0, 0, p2_h2])
		rotate([0, -90, 0])
		spring_case();
	}
}

color("green")
translate([0, 0, p1_h1-20])
//translate([20, 35, 0])
//rotate([0, 0, 90])
way();