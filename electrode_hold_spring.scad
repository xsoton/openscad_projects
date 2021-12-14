$fn = 200;
g = 0.001;
pg = 0.4; // погрешность принтера

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
p1_h1 = 90+30;

// прицепка - дополнительная часть
p2_w1 = 10;
p2_w2 = 2;
p2_l1 = s_dx;
p2_h1 = 40;
p2_h2 = 50+30;

// электрод
e_w = 7.66;
e_h = 23.1;
e_l = 0.5;

// электрод 2
e2_w = 7.62;
e2_h = 16;
e2_l = 0.5;

// контакт
c_w = 2.54;
c_l = 5.0;
c_h = 8.68;
c_g = 0.05;

// направляющая
w_w1 = 28; // ширина
w_d1 = 2; // толщина стенок
w_l1 = p1_l1+pg-0.1+2*w_d1; // длина
w_h1 = 10; // высота

// рейтер СССР
ru_w1 = 40; // ширина ретера
ru_l1 = 70; // ширина скамьи
ru_h1 = 20; // высота ножек
ru_d1 = 6.0; // толщина верхней стенки
ru_d2 = 12.0; // толщина боковых стенок

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

module spring_case()
{
	rotate([90,0,0])
	cylinder(d=s_d1+pg, h=s_h1+pg, center=true);
	
	translate([s_h2, 0, 10/2])
	rotate([90,0,0])
	cylinder(d=2.0, h=s_h1+pg, center=true);
	
	translate([s_h2, 0, -10/2])
	rotate([90,0,0])
	cylinder(d=2.0, h=s_h1+pg, center=true);
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
	
	translate([3, 0, 2])
	cube([p1_w1-3, 1, 10-2]);
	
	translate([3, p1_l1-1, 2])
	cube([p1_w1-3, 1, 10-2]);
}

module ebox2()
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
		
		translate([0.4, (p1_l1-e2_w-0.2)/2, 10-3.5-g])
		cube([e2_l+0.2, e2_w+0.2, 3.5+2*g]);
		
		translate([-g, (p1_l1-e2_w+2)/2, 10-3.5-g])
		cube([0.4+2*g, e2_w-2, 3.5+2*g]);
	}
	
	translate([3, 0, 2])
	cube([p1_w1-3, 1, 10-2]);
	
	translate([3, p1_l1-1, 2])
	cube([p1_w1-3, 1, 10-2]);
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
		
		translate([p2_w1-c_w-2*c_g-0.4, (p2_l1-c_l-2*c_g)/2, sc_h1-g])
		cube([c_w+2*c_g, c_l+2*c_g, 10-sc_h1+2*g]);
		
		translate([p2_w1-4-g, (p2_l1-c_l+1)/2, sc_h1-g])
		cube([4+2*g, c_l-1, 10-sc_h1+2*g]);
	}
	
	translate([0, -0.1, 0])
	cube([p1_w1, 0.1, 10]);
	translate([0, -1, 0])
	cube([2*p1_w1, 0.9, 10]);
	
	translate([0, p2_l1, 0])
	cube([p1_w1, 0.1, 10]);
	translate([0, p2_l1+0.1, 0])
	cube([2*p1_w1, 0.9, 10]);
}

module way()
{
	difference()
	{
		cube([w_w1, w_l1, w_h1]);
		
		translate([w_d1, w_d1, -g])
		cube([w_w1-2*w_d1, w_l1-2*w_d1, w_h1+2*g]);
	}
}

module rider_ussr()
{
	difference()
	{
		cube([ru_w1, ru_l1+2*ru_d2, ru_d1]);
		
		translate([ru_w1/2 - p1_w1*1/2, ru_d2 + ru_l1/2, -g])
		cylinder(d=sc_d2+pg, h=ru_d1+2*g);
				
		hull()
		{
			translate([ru_w1/2 - p1_w1*1/2, ru_d2 + ru_l1/2, 1])
			screw_hat();
			
			translate([ru_w1/2 - p1_w1*1/2, ru_d2 + ru_l1/2, ru_d1-sc_h2])
			screw_hat();
		}
		
		translate([ru_w1/2 + p1_w1*1/2, ru_d2 + ru_l1/2, -g])
		cylinder(d=sc_d2+pg, h=ru_d1+2*g);
			
		hull()
		{
			translate([ru_w1/2 + p1_w1*1/2, ru_d2 + ru_l1/2, 1])
			screw_hat();
			
			translate([ru_w1/2 + p1_w1*1/2, ru_d2 + ru_l1/2, ru_d1-sc_h2])
			screw_hat();
		}
	}
	
	translate([0, 0, ru_d1])
	difference()
	{
		cube([ru_w1, ru_d2, ru_h1]);
		
		translate([ru_w1/2, -g, ru_h1/2])
		rotate([-90, 0, 0])
		cylinder(d = 6.0 + pg, h = ru_d2 + 2*g);
		
		translate([ru_w1/2, ru_d2-5.0, ru_h1/2])
		rotate([-90, 0, 0])
		cylinder(d = 11.2 + pg, h = 5.0 + g, $fn = 6);
		
		translate([ru_w1/2, -g, ru_h1/2])
		rotate([-90, 0, 0])
		cylinder(d = 11.2 + pg, h = 5.0 + g, $fn = 6);
	}
	
	translate([0, ru_d2+ru_l1, ru_d1])
	hull()
	{
		cube([ru_w1, ru_d2, g]);
		
		translate([0, -ru_h1/tan(60+1/4), ru_h1])
		cube([ru_w1, ru_d2, g]);
	}
}

module cap1()
{
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

module cap2()
{
	difference()
	{
		intersection()
		{
			sphere(d = 15);
			cylinder(d = 7.5, h = ru_h1);
		}
		
		translate([-ru_h1, -ru_h1, -ru_h1])
		cube([2*ru_h1, 2*ru_h1, ru_h1]);
		
		translate([0, 0, -g])
		cylinder(d = 5.5, h = 5 + g);
	}
}

module view()
{
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
	translate([-w_w1+p1_w1+w_d1, -w_l1/2, p1_h1-20])
	way();
	
	translate([ru_w1/2+p1_w1, -ru_l1/2-ru_d2, 0])
	rotate([180, 0, 180])
	rider_ussr();
}

module print_sla()
{
	color("red")
	translate([5, -p1_l1/2, 0])
	ebox();
	
	color("blue")
	translate([-p2_w1-10, -p1_l1/2, 0])
	cbox();
}

module print_sla2()
{
	color("red")
	ebox2();
}

module print_fdm()
{
	translate([0, 0, p1_l1/2])
	rotate([-90, 0, 0])
	union()
	{
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
	translate([25, 13, 0])
	rotate([0, 0, 90])
	way();
	
	translate([-ru_w1-12, 0, 0])
	rider_ussr();
	
	translate([22, 55, 0])
	cap1();
	
	translate([17, 72, 0])
	cap2();
}

*color("red")
ebox();

*color("blue")
translate([-10, 0, 0])
cbox();

*view();
*print_sla();
print_sla2();
*print_fdm();

*rider_ussr();
*way();