$fn=100;
d=0.01;

// cuvette box size

bx0 = 13;
by0 = 13;
bz0 = 25;

bx = bx0-0.5;
by = by0-0.5;
bz = bz0;

// electrode

ex0 = 7;
ey0 = 1;
ez0 = 23;
ez1 = 10;
ez2 = 19;

ex = ex0 + 0.1;
ey = ey0 + 0.1;
ez = ez0;

module electrode()
{
	difference()
	{
		cube([ex, ey, ez]);
		translate([ex/4, -d, ez1])
		cube([ex/2, ey+2*d, ez2-ez1]);
	}
}

module box()
{
	difference()
	{
		cube([bx, by, bz]);
		translate([2, -d, 4])
			cube([bx-4, by+2*d, bz-4+d]);
		translate([-d, 2-d, 4])
			cube([bx+2*d, by-4, bz-4-3]);
	}
}

difference()
{
	box();

	translate([bx/2+ey/2, by/2-ex/2, -d])
	rotate([0, 0, 90])
	electrode();
}
