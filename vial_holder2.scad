$fn = 100;
dh = 0.01;

d1 = 23;
d2 = 25;
h1 = 15;
dh1 = 2;
nx = 4;
ny = 4;

difference()
{
	cube([(nx+1)*d2-d1,(ny+1)*d2-d1,h1+dh1]);

	for(i=[0:1:nx-1])
	{
		for(j=[0:1:ny-1])
		{
			translate([(i+1)*d2-d1/2, (j+1)*d2-d1/2, dh1])
			cylinder(d=d1, h=h1+dh);
		}
	}
}