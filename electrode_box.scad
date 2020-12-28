$fn = 200;

module cube_gap(x1 = 0.1, x2 = 0.1, y1 = 0.1, y2 = 0.1, z1 = 0.1, z2 = 0.1)
{
	minkowski()
	{
		union(){children();}
		translate([-x1, -y1, -z1])
		cube([x1+x2, y1+y2, z1+z2]);
	}
}

module connector()
{
	translate([0, 0.635, 3.5433])
	rotate([0, 180, 0])
	import("70AAJ2MO.stl");
}

module _connector_box()
{
	// main box size
	w  = 2*2.50189;
	l  = 2.54;
	h  = 8.4836;

	// back electrode
	bw = 0.76;
	bl = 0.18;
	bh = h;

	// front electrode
	fw = 1.27;
	fl = 1.27;
	// fh = h;
	fh = 7.0866;

	cube_gap(z2 = 1.1)
	{
		// box
		translate([-w/2, 0, 0])
		cube([w, l, h]);
	}

	cube_gap(y1 = 1.1, z1 = 2.1, z2 = 1.1)
	{
		// 2 back electrodes
		translate([-bw/2-1.27, -bl, 0])
		cube([bw, bl, bh]);
		translate([-bw/2+1.27, -bl, 0])
		cube([bw, bl, bh]);
	}

	cube_gap()
	{
		// 2 front electrodes
		translate([-fw/2+1.27, l, 0])
		cube([fw, fl, fh]);
		translate([-fw/2-1.27, l, 0])
		cube([fw, fl, fh]);
	}
}

module electrode()
{
	w = 7.66;
	h = 23.1;
	l = 1;

	translate([-w/2, 0, 0])
	cube([w, l, h]);
}

module _electrode_box()
{
	cube_gap()
	electrode();
}

module _box()
{
	w = 10;
	l = 7;
	h = 10;
	pd = 0.75;

	difference()
	{
		translate([-w/2, -2, -1])
		cube([w, l, h]);
		translate([0, 3, 0])
		_electrode_box();
		_connector_box();
		translate([0, 1.4, -1.1])
		cylinder(d=2, h=1.2);
	}

	translate([0, 2.54+0.1, 7.0866 + pd/2 + 0.3])
	difference()
	{
		sphere(d=pd);
		translate([-pd/2,0,-pd/2])
		cube([pd, pd, pd]);
	}
}

module electrode_box()
{
	translate([0, 2, 1])
	{
		_box();
		connector();
		translate([0, 3, 0])
		electrode();
	}
}


electrode_box();
