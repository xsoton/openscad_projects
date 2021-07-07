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
translate([0,0,4])
cylinder(d1=1.3, d2=1.65, h=3.5);

hull()
{
	rotate(a=[0,45,0])
	translate([0,0,4+3.5])
	cylinder(d1=1.65, d2=2, h=3.5);

	translate([20,0,5])
	rotate(a=[0,90,0])
	cylinder(d1=3, d2=5, h=5);
}

translate([25,0,5])
rotate(a=[0,90,0])
cylinder(d=5, h=45);

rotate(a=[0,45,0])
p50b1();
