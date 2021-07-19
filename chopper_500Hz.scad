$fn = 100;
g = 0.01;

/*
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
*/

module table()
{
	w = 90;
	l = 53;
	h = 4;

	w1 = 5;
	l1 = 5;
	h1 = 1;

	w2 = 3;
	l2 = l;
	h2 = 1;

	w3 = 75;
	l3 = 45;
	h3 = h;
	d3 = 7.5;

	w4 = 45;
	l4 = 45;
	h4 = 2;
	d41 = 5.2;
	d42 = 3;

	difference()
	{
		cube([w, l, h]);

		translate([w/2, l/2, -g])
		{
			hull()
			{
				translate([-w3/2, (-l3+d3)/2, 0]) cylinder(d=d3, h=h3+2*g);
				translate([-w3/2, (+l3-d3)/2, 0]) cylinder(d=d3, h=h3+2*g);
			}
			hull()
			{
				translate([+w3/2, (-l3+d3)/2, 0]) cylinder(d=d3, h=h3+2*g);
				translate([+w3/2, (+l3-d3)/2, 0]) cylinder(d=d3, h=h3+2*g);
			}
		}

		for(x=[(w-w4)/2:w4:(w+w4)/2])
		for(y=[(l-l4)/2:l4:(l+l4)/2])
		{
			translate([x, y, h-h4]) cylinder(d=d41, h=h4+g);
			translate([x, y, -g])   cylinder(d=d42, h=h-h4+2*g);
		}
	}

	translate([w-w1, l-l1, h]) cube([w1, l1, h1]);
	translate([w-w1,    0, h]) cube([w1, l1, h1]);
	translate([0   ,    0, h]) cube([w2, l2, h2]);
}

module box()
{
	w = 50;
	l = 50;
	h = 10;
	dz = 2;
	dx = 1.5;
	dy = 1.5;

	d1 = 5;
	d2 = 2.4;

	w1 = 45;
	l1 = 45;

	d3 = 2.4;
	w3 = 24.5;
	w4 = 19;
	w5 = 11.9;
	l5 = 4;

	difference()
	{
		union()
		{
			difference()
			{
				cube([w, l, h]);

				translate([dx, dy, dz])
				cube([w-2*dx, l-2*dy, h-dz+g]);
			}

			for(x=[(w-w1)/2:w1:(w+w1)/2])
			for(y=[(l-l1)/2:l1:(l+l1)/2])
			translate([x, y, dz])
			cylinder(d=d1, h=h-dz);
		}

		for(x=[(w-w1)/2:w1:(w+w1)/2])
		for(y=[(l-l1)/2:l1:(l+l1)/2])
		translate([x, y, dz])
		cylinder(d=d2, h=h-dz+g);

		translate([(w3-w4)/2, l/2, -g])
		cylinder(d=d3, h=dz+g+2);
		translate([(w3+w4)/2, l/2, -g])
		cylinder(d=d3, h=dz+g+2);

		translate([(w3-w5)/2, (l-l5)/2, -g])
		cube([w5, l5, dz+2*g]);
	}
}

module box_chopper()
{
	w = 57.5;
	l = 34;
	h = 26;

	w1 = 6;
	l1 = 50;

	dx = 2;
	dz = 2;

	d1 = 7;
	d2 = 26;
	d3 = 2.6+0.4;
	d4 = 4.3+0.4;

	d5 = 2.4;
	h5 = h;

	d6 = 6;
	h6 = h+dz;

	d7 = 2.4;
	h7 = w1;
	dl7 = 5;

	difference()
	{
		union()
		{
			translate([0, -l/2-dx, 0])
			cube([w, l+2*dx, h+dz]);

			cylinder(d=l+2*dx, h=h+dz);

			translate([-(l+d6)/2, 0, 0])
			cylinder(d=d6, h=h6);
			for(x = [1:2:3])
			for(y = [-1:2:1])
			translate([x*w/4, y*(l+d6)/2, 0])
			cylinder(d=d6, h=h6);

			translate([w-w1, -l1/2, 0])
			cube([w1, l1, h+dz]);
		}

		union()
		{
			translate([0, -l/2, dz])
			cube([w+g, l, h+g]);

			translate([0, 0, dz])
			cylinder(d=l, h=h+g);
		}

		union()
		{
			for(y = [-1:2:1])
			for(z = [1:2:3])
			translate([w-h7-g, y*(l/2+dl7), z*(h+dz)/4])
			rotate([0, 90 ,0])
			cylinder(d=d7, h=h7+2*g);
		}

		union()
		{
			translate([0, 0, -g])
			cylinder(d=d1, h=dz+2*g);

			for(a=[0:60:300])
			rotate([0,0,a])
			translate([d2/2,0,-g])
			union()
			{
				cylinder(d=d3, h=dz+2*g);
				cylinder(d=d4, h=0.35+g);
			}
		}

		union()
		{
			translate([-(l+d6)/2, 0, h+dz-h5])
			cylinder(d=d5, h=h5+g);

			for(x = [1:2:3])
			for(y = [-1:2:1])
			translate([x*w/4, y*(l+d6)/2, h+dz-h5])
			cylinder(d=d5, h=h5+g);
		}
	}
}

module box_chopper_cover()
{
	w = 57.5;
	l = 34;
	h = 0;

	w1 = 6;
	l1 = 50;

	dx = 2;
	dz = 2;

	d1 = 3.2;
	d2 = 5.5;
	h2 = (d2-d1)/2;
	h1 = dz-h2;

	d6 = 6;
	h6 = h+dz;

	d7 = 10.9+0.4;

	difference()
	{
		union()
		{
			translate([0, -l/2-dx, 0])
			cube([w, l+2*dx, h+dz]);

			cylinder(d=l+2*dx, h=h+dz);

			translate([-(l+d6)/2, 0, 0])
			cylinder(d=d6, h=h6);
			for(x = [1:2:3])
			for(y = [-1:2:1])
			translate([x*w/4, y*(l+d6)/2, 0])
			cylinder(d=d6, h=h6);

			translate([w-w1, -l1/2, 0])
			cube([w1, l1, h+dz]);
		}

		union()
		{
			translate([-(l+d6)/2, 0, 0])
			union()
			{
				translate([0, 0, -g]) cylinder(h=h1+2*g, d=d1);
				translate([0, 0, h1]) cylinder(h=h2+g, d1=d1, d2=d2);
			}

			for(x = [1:2:3])
			for(y = [-1:2:1])
			translate([x*w/4, y*(l+d6)/2, 0])
			union()
			{
				translate([0, 0, -g]) cylinder(h=h1+2*g, d=d1);
				translate([0, 0, h1]) cylinder(h=h2+g, d1=d1, d2=d2);
			}
		}

		translate([w-w1-d7/2, 0, -g])
		cylinder(h=h+dz+2*g, d=d7);
	}
}

*table();

translate([0, 25, 10])
rotate([180, 0, 0])
box();

translate([50-26-2, 0, 57.5+0+10])
rotate([0, 90, 0])
box_chopper();

*translate([0, 0, 40])
box_chopper_cover();

//translate([0, 50, 0])
//cover_chopper();