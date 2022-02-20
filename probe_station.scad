$fn = 100;

g = 0.001;

// electrode
EW = 10;
EL = 10;
EH = 0.45;

// table
TW = 100;
TL = 50;
TH = 5;

// параметры контакта p50b1
PD1 =  0.500; // диаметр острия
PD2 =  0.680; // диаметр оболочки
PH0 =  0.433; // высота заточки
PH1 =  3.350; // высота острия
PH2 = 13.000; // высота оболочки

module probe()
{
	color("Silver")
	{
		cylinder(d1=0, d2=PD1, h=PH0);
		translate([0, 0, PH0])
		cylinder(d=PD1, h=PH1-PH0);
	}

	color("Gold")
	translate([0, 0, PH1])
	cylinder(d=PD2, h=PH2);
}

module electrode()
{
	color("red")
	translate([0, 0, EH/2])
	cube([EW, EL, EH], center=true);
}

module table()
{
	translate([0, 0, -TH/2])
	cube([TW, TL, TH], center=true);
}

table();

electrode();

translate([EW/2-1, 0, EH])
rotate([0, 30, 0])
probe();

translate([-EW/2+1, 0, EH])
rotate([0, -30, 0])
probe();
