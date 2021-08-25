$fn = 100;
g = 0.01;

s_d1 = 5;
s_h1 = 12;
s_h2 = 17;
s_dx = 9.5;

module spring_case()
{
	gap = 0.2;
	
	rotate([90,0,0])
	cylinder(d=s_d1+gap, h=s_h1+gap, center=true);
	
	translate([s_h2, 0, 10/2])
	cube([1.5, s_h1+gap, 1.5], center = true);
	
	translate([s_h2, 0, -10/2])
	cube([1.5, s_h1+gap, 1.5], center = true);
}

p1_w1 = 10;
p1_l1 = s_dx;
p1_h1 = 100-10;

p2_w1 = 10;
p2_w2 = 2;
p2_l1 = s_dx;
p2_h1 = 50-10;
p2_h2 = 50;

module plank()
{
	difference()
	{
		translate([0, -p1_l1/2, 0])
		cube([p1_w1, p1_l1, p1_h1]);
		
		translate([6, 0, p1_h1-10])
		cylinder(d=3, h=10+g);
	}
	
	difference()
	{
		hull()
		{
			translate([-p2_w1, -p2_l1/2, p2_h2])
			cube([p2_w1, p2_l1, p2_h1]);

			translate([-p2_w1, -p2_l1/2, 5])
			cube([p2_w2, p2_l1, p2_h2-5]);
		}
		
		translate([-6, 0, p2_h1+p2_h2-10])
		cylinder(d=3, h=10+g);
	}
}

e_w = 7.66;
e_h = 23.1;
e_l = 0.5;

module ebox()
{
	difference()
	{
		cube([p1_w1, p1_l1, 1]);
		
		translate([p1_w1-4, p1_l1/2, -g])
		cylinder(d=3.2, h=1+2*g);
	}
	
	difference()
	{
		translate([0, 0, 1])
		cube([3, p1_l1, 9]);
		
		translate([0.4, (p1_l1-e_w-0.2)/2, 1])
		cube([e_l+0.2, e_w+0.2, 9+g]);
		
		translate([-g, (p1_l1-e_w+2)/2, 1])
		cube([0.4+2*g, e_w-2, 9+g]);
	}
}

color("red")
translate([0, -p1_l1/2, p1_h1])
ebox();

c_w = 2.54;
c_l = 5.0;
c_h = 8.68;

module connector()
{
	translate([-2.54, 0, 0])
	rotate([0, 0, -90])
	translate([0, 0.635, 3.5433])
	rotate([0, 180, 0])
	import("70AAJ2MO.stl");
}

translate([-0.4-0.1, 0, p2_h1+p2_h2+1])
*connector();

module cbox()
{
	difference()
	{
		cube([p2_w1, p2_l1, 1]);
		
		translate([4, p2_l1/2, -g])
		cylinder(d=3.2, h=1+2*g);
	}
	
	difference()
	{
		translate([p2_w1-4, 0, 1])
		cube([4, p1_l1, 9]);
		
		translate([p2_w1-c_w-0.2-0.4, (p2_l1-c_l-0.2)/2, 1])
		cube([c_w+0.2, c_l+0.2, 9+g]);
		
		translate([p2_w1-4-g, (p2_l1-c_l+1)/2, 1])
		cube([4+2*g, c_l-1, 9+g]);
	}
}

color("blue")
translate([-p2_w1, -p1_l1/2, p1_h1])
cbox();

difference()
{
	plank();
	
	translate([0, 0, 50])
	rotate([0, -90, 0])
	#spring_case();
}

