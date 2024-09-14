M3D  =  3.00;
M3Dk =  5.60;
M3K  =  1.65;

function ML(L=50.0, K=0.0) = L-K;

M4D  =  4.00;

M6Nd = 10.00/cos(30); M6Nl = 5.00;
M5Nd =  8.00/cos(30); M5Nl = 4.00;
M4Nd =  7.00/cos(30); M4Nl = 3.20;
M3Nd =  5.50/cos(30); M3Nl = 2.40;
M2Nd =  4.00/cos(30); M2Nl = 1.60;


/*
 * Винт
 * D  - диаметр резьбы
 * L  - длина резьбы
 * Dk - диаметр шляпки
 * K  - высота шляпки
 */
module screw(D, L, Dk, K)
{
	screw_hat(D, Dk, K);
	translate([0, 0, K-0.001])
	screw_body(D, L+0.001);
}
module screw_hat (D, Dk, K) {cylinder(d1 = Dk, d2 = D, h = K       );}
module screw_body(D, L)     {cylinder(d  = D ,         h = L       );}
module screw_nut (D, L)     {cylinder(d  = D ,         h = L, $fn=6);}
