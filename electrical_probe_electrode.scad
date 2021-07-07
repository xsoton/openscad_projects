$fn = 100;
dh = 0.01;

module p50b1()
{
	d1 = 0.5;
	d2 = 0.68;
	h0 = 0.433;
	h1 = 3.35;
	h2 = 13;
	
	cylinder(d1=0, d2=d1, h=h0);
	translate([0,0,h0])
	cylinder(d=d1, h=h1-h0);
	translate([0,0,h1])
	cylinder(d=d2, h=h2);
}

rotate(a=[0,45,0])
p50b1();