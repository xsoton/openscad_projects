$fn = 200;
g = 0.01;

/*
bw = 150;
bl = 55;
bh = 105;
bd = 2;

bh_x = bw/2;
bh_y = bh-70;

module box()
{
	difference()
	{
		cube([bw, bl, bh]);
		
		translate([bd, bd, bd])
		cube([bw-2*bd, bl-2*bd, bh]);
		
		translate([bh_x, -g, bh_y])
		rotate([-90, 0, 0])
		cylinder(d=22, h=bl+2*g);
	}
}

box();
*/

d_d = 33+1;
d_h = 25+1;
d_d1 = 7;
d_d2 = 26;
d_d3 = 2.6+0.4;
d_d4 = 4.3+0.4;

module box_chopper()
{
	difference()
	{
		union()
		{
			cylinder(d=d_d+4, h=d_h + 2);
			
			translate([0, -d_d/4, 0])
			cube([60, d_d/2, 15]);
			translate([60-10, -d_d/2-1, 0])
			cube([10, d_d+2, 15]);
			
			for(a=[60:120:240+60])
			rotate([0,0,a])
			translate([d_d/2+3,0,0])
			cylinder(d=8, h=d_h+2);
		}
		
		translate([0, 0, 2])
		cylinder(d=d_d, h=d_h+g);
		
		translate([0, 0, -g])
		cylinder(d=d_d1, h=2+2*g);
		
		for(a=[0:60:300])
		rotate([0,0,a])
		translate([d_d2/2,0,-g])
		union()
		{
			cylinder(d=d_d3, h=2+2*g);
			cylinder(d=d_d4, h=0.35+g);
		}
		
		translate([d_d/2-2, -6, 18])
		cube([20, 12, 10+g]);
		
		for(a=[60:120:240+60])
		rotate([0,0,a])
		translate([d_d/2+3,0,d_h+2-10])
		cylinder(d=2.6, h=10+g);
		
		for(x=[-1:2:1])
		for(y=[2.5:10:12.5])
		translate([60-10-g, x * 10, y])
		rotate([0, 90, 0])
		cylinder(d=2.6, h=10+2*g);
	}
}

module cover_chopper()
{
	difference()
	{
		union()
		{
			cylinder(d=d_d+4, h=2);
			
			for(a=[60:120:240+60])
			rotate([0,0,a])
			translate([d_d/2+3,0,0])
			cylinder(d=8, h=2);
		}
		
		for(a=[60:120:240+60])
		rotate([0,0,a])
		translate([d_d/2+3,0,0])
		{
			translate([0, 0, 2-g])
			cylinder(h=2*g, d=5.5);
			
			translate([0, 0, 2-(5.5-3.2)/2])
			cylinder(h=(5.5-3.2)/2, d1=3.2, d2=5.5);
	
			translate([0, 0, -g])
			cylinder(h=2-(5.5-3.2)/2+2*g, d=3.2);
		}
	}
}

box_chopper();

translate([0, 50, 0])
cover_chopper();