$fn = 100;

g = 0.001;

// электрод
EW = 10;
EL = 10;
EH = 0.45;

// стол
TW = 120;
TL = 50;
TH = 5;

// рельса 1
R1W1 = 24;
R1W2 = 30;
R1W3 = 10;
R1H1 = 5;
R1H2 = 1;
R1H3 = 2;
R1L1 = 40;
R1L2 = 5;
R1D1 = 3;

// рейтер 1
RiD1 = 5;
RiD2 = 3;
RiD3 = 6.4;
RiW1 = 40;
RiW2 = 5.6;           // бегунок
RiL1 = 20;
RiL2 = 5;
RiL3 = RiL2+2;
RiL4 = (RiL1-RiL3)/2;
RiL5 = 5.1;           // бегунок
RiH1 = R1H1+RiD1+2;
RiH2 = RiD1+2;

// рельса 2
R2W1 = RiL1-4-6;
R2W2 = RiL1-4;
R2W3 = 6;
R2H1 = 5;
R2H2 = 1;
R2H3 = 2;
R2L1 = RiW1;
R2L2 = 5;
R2D1 = 3;

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
	cube([EW, EL, EH], center = true);
}

module table()
{
	translate([0, 0, -TH/2])
	cube([TW, TL, TH], center = true);
}

module rail1()
{
	difference()
	{
		union()
		{
			translate([0, 0, R1H2/2])
			cube([R1W1, R1L1, R1H2], center = true);

			hull()
			{
				translate([0, 0, R1H2/2 + R1H2])
				cube([R1W1, R1L1, R1H2], center = true);
				translate([0, 0, R1H2/2 + R1H1 - R1H2])
				cube([R1W2, R1L1, R1H2], center = true);
			}
		}

		translate([0, 0, -R1H3/2 + R1H1 + g])
		cube([R1W3, R1L1 + 2*g, R1H3 + g], center = true);

		translate([0, -10, 0])
		union()
		{
			translate([0, 0, -g])
			cylinder(d = R1D1, h = R1H1-R1H3+2*g);

			hull()
			{
				translate([0, 0, R1H1-R1H3])
				cylinder(d = 5.6, h = g);
				translate([0, 0, 0.5])
				cylinder(d1 = R1D1, d2 = 5.6, h = 1.65);
			}
		}

		translate([0, +10, 0])
		union()
		{
			translate([0, 0, -g])
			cylinder(d = R1D1, h = R1H1-R1H3+2*g);

			hull()
			{
				translate([0, 0, R1H1-R1H3])
				cylinder(d = 5.6, h = g);
				translate([0, 0, 0.5])
				cylinder(d1 = R1D1, d2 = 5.6, h = 1.65);
			}
		}
	}

	translate([0, -R1L2/2-R1L1/2, 0])
	union()
	{
		translate([0, 0, R1H2/2])
		cube([R1W1, R1L2, R1H2], center = true);

		hull()
		{
			translate([0, 0, R1H2/2 + R1H2])
			cube([R1W1, R1L2, R1H2], center = true);
			translate([0, 0, R1H2/2 + R1H1 - R1H2])
			cube([R1W2, R1L2, R1H2], center = true);
		}
	}

	difference()
	{
		translate([0, -R1L2/2-R1L1/2, R1H1+(RiH1-R1H1)/2])
		cube([R1W2, R1L2, RiH1-R1H1], center = true);

		translate([0, -R1L1/2+g, R1H1+(RiH1-R1H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD2, h=R1L2+2*g);

		translate([0, -R1L1/2+g, R1H1+(RiH1-R1H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD1, h=2+2*g);

		translate([0, -R1L1/2-R1L2+1.65-g, R1H1+(RiH1-R1H1)/2])
		rotate([90, 0, 0])
		cylinder(d1 = R1D1, d2 = 5.6, h = 1.65+g);
	}
}

module rider1()
{

	difference()
	{
		translate([0, 0, RiH1/2])
		cube([RiW1, RiL1, RiH1], center = true);

		translate([0, 0, 0.25-g/2])
		cube([RiW1+2*g, RiL1+2*g, 0.5+g], center = true);

		union()
		{
			translate([0, 0, R1H2/2])
			cube([R1W1+0.1, RiL1+2*g, R1H2+2*g], center = true);

			hull()
			{
				translate([0, 0, R1H2/2 + R1H2])
				cube([R1W1+0.1, RiL1+2*g, R1H2], center = true);
				translate([0, 0, R1H2/2 + R1H1 - R1H2])
				cube([R1W2+0.1, RiL1+2*g, R1H2], center = true);
			}
		}

		translate([0, 0, R1H1+(RiH1-R1H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD2, h=RiL1+2*g, center = true);

		translate([0, -RiL3/2, R1H1+(RiH1-R1H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD1+0.2, h=RiL4+g);

		*translate([0, RiL3/2, R1H1+(RiH1-R1H1)/2])
		rotate([-90, 0, 0])
		cylinder(d=RiD1+0.1, h=RiL4+g);

		translate([0, 0, R1H1+(RiH1-R1H1)/2])
		cube([RiW2, RiL2, RiH2+2*g], center=true);

		translate([-10, 0, RiH1-RiH2-g])
		union()
		{
			rotate([0, 0, 30])
			cylinder(d = RiD3, h = RiH2-0.5+g, $fn = 6);

			cylinder(d = RiD2, h = RiH2+2*g);
		}

		translate([+10, 0, RiH1-RiH2-g])
		union()
		{
			rotate([0, 0, 30])
			cylinder(d = RiD3, h = RiH2-0.5+g, $fn = 6);

			cylinder(d = RiD2, h = RiH2+2*g);
		}
	}
}

module rail2()
{
	difference()
	{
		union()
		{
			translate([0, 0, R2H2/2])
			cube([R2W1, R2L1, R2H2], center = true);

			hull()
			{
				translate([0, 0, R2H2/2 + R2H2])
				cube([R2W1, R2L1, R2H2], center = true);
				translate([0, 0, R2H2/2 + R2H1 - R2H2])
				cube([R2W2, R2L1, R2H2], center = true);
			}
		}

		translate([0, 0, -R2H3/2 + R2H1 + g])
		cube([R2W3, R2L1 + 2*g, R2H3 + g], center = true);

		translate([0, -10, 0])
		union()
		{
			translate([0, 0, -g])
			cylinder(d = R2D1, h = R2H1-R2H3+2*g);

			hull()
			{
				translate([0, 0, R2H1-R2H3])
				cylinder(d = 5.6, h = g);
				translate([0, 0, 0.5])
				cylinder(d1 = R2D1, d2 = 5.6, h = 1.65);
			}
		}

		translate([0, +10, 0])
		union()
		{
			translate([0, 0, -g])
			cylinder(d = R2D1, h = R2H1-R2H3+2*g);

			hull()
			{
				translate([0, 0, R2H1-R2H3])
				cylinder(d = 5.6, h = g);
				translate([0, 0, 0.5])
				cylinder(d1 = R2D1, d2 = 5.6, h = 1.65);
			}
		}
	}

	translate([0, -R2L2/2-R2L1/2, 0])
	union()
	{
		translate([0, 0, R2H2/2])
		cube([R2W1, R2L2, R2H2], center = true);

		hull()
		{
			translate([0, 0, R2H2/2 + R2H2])
			cube([R2W1, R2L2, R2H2], center = true);
			translate([0, 0, R2H2/2 + R2H1 - R2H2])
			cube([R2W2, R2L2, R2H2], center = true);
		}
	}

	difference()
	{
		translate([0, -R2L2/2-R2L1/2, R2H1+(RiH1-R2H1)/2])
		cube([R2W2, R2L2, RiH1-R2H1], center = true);

		translate([0, -R2L1/2+g, R2H1+(RiH1-R2H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD2, h=R2L2+2*g);

		translate([0, -R2L1/2+g, R2H1+(RiH1-R2H1)/2])
		rotate([90, 0, 0])
		cylinder(d=RiD1, h=2+2*g);

		translate([0, -R2L1/2-R2L2+1.65-g, R2H1+(RiH1-R2H1)/2])
		rotate([90, 0, 0])
		cylinder(d1 = R2D1, d2 = 5.6, h = 1.65+g);
	}
}


table();

translate([40, 0, 0])
rail1();

translate([40, 0, 0])
rider1();

translate([40, 0, RiH1])
rotate([0, 0, 90])
rail2();

electrode();

translate([EW/2-1, 0, EH])
rotate([0, 30, 0])
probe();

translate([-EW/2+1, 0, EH])
rotate([0, -30, 0])
probe();
