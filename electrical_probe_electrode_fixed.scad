$fn = 100;
dh = 0.01;

E_W = 7;   // ширина электрода
E_L = 20;  // длина электрода
E_H = 0.5; // толщина электрода

NX = 2;    // число рядов электродов
NY = 5;    // число электродов в одном ряду
HX = 2.54; // расстояние между рядами электродов
HY = 1.27; // шаг электродов

// координата нижнего левого электрода
X1 = 1.27;
Y1 = 1.27;

// координата общего электрода
X2 = 5.5;
Y2 = 4;

// граница закрытой чатси электрода
Y3 = 9;

P_D1 = 0.5;   // диаметр острия
P_D2 = 0.68;  // диаметр оболочки
P_H0 = 0.433; // высота заточки
P_H1 = 3.35;  // высота острия
P_H2 = 13;    // высота оболочки

e_g = 0.1; // зазор от электрода до стенок

pb_w = E_W;
pb_l = Y3-1-e_g;
pb_h = P_H2-2;
pb_x = 0;
pb_y = 0;
pb_z = 4;

module p50b1()
{
	cylinder(d1=0, d2=P_D1, h=P_H0);
	translate([0, 0, P_H0])
	cylinder(d=P_D1, h=P_H1-P_H0);
	translate([0, 0, P_H1])
	cylinder(d=P_D2, h=P_H2);
}

module p50b1_array()
{
	for(x=[X1:HX:X1+(NX-1)*HX])
	for(y=[Y1:HY:Y1+(NY-1)*HY])
	{
		translate([x, y, 0])
			p50b1();
		translate([x, y, 0])
			p50b1();
	}
	translate([X2, Y2, 0])
		p50b1();
}

module probe_box()
{
	translate([pb_x, pb_y, pb_z])
		cube([pb_w, pb_l, pb_h]);
}

module electrode()
{
	translate([0, 0, -E_H])
	cube([E_W, E_L, E_H]);
}

module electrode_bed()
{
	translate([0, 0, -E_H])
	difference()
	{
		union()
		{
			translate([-1, -1, -2])
			cube([E_W+2, E_L+2, 3]);
			
			translate([-1, -1, 1])
			cube([E_W+2, Y3+1, 13]);
		}
		
		translate([-e_g, -e_g, 1-dh])
		cube([E_W+2*e_g, Y3-1+2*e_g, 13+2*dh]);
		
		translate([-1-dh, Y3, -2-dh])
		cube([E_W+2+2*dh, E_L+2-Y3+dh, 3+2*dh]);
		
		translate([-e_g, -e_g, 0])
		cube([E_W+2*e_g, E_L+2*e_g, 1+dh]);
		
		*translate([E_W/2-2, -1-dh, -2-dh])
		cube([4, 2-e_g+dh, 3+2*dh]);
	}
}

p50b1_array();
probe_box();

#electrode();
electrode_bed();
