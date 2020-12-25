$fn=200;

module laser_box()
{
	cylinder(h=30, d=14);
}

module laser()
{
	difference()
	{
		cylinder(h=30, d=14);
		translate([0, 0, 2])
		cylinder(h=30.1, d=12);
		translate([0, 0, -0.1])
		cylinder(h=2.2, d=10);
	}
}

difference()
{
	union()
	{
		cylinder(h=18, d=40);
		
		// foot
		translate([-10, -70, 0])
		cube([20, 70, 10]);
		translate([-20, -70, 0])
		cube([40, 10, 10]);
	}

	// inner
	translate([0, 0, 2])
	cylinder(h=16.1, d=34);
	
	translate([0, 0, -0.1])
	cylinder(h=2.2, d=7);
	
	for(az=[0:60:360])
	rotate([0, 0, az])
	translate([0, 13, -0.1])
	cylinder(h=2.2, d=3);
	
	// laser box
	translate([0, -45, -0.1])
	laser_box();
}

// laser
translate([0, -45, 0])
laser();