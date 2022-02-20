$fn = 100;
g = 0.01;

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

module probe_box()
{
	cylinder(d=PD2+0.1, h=PH2+PH1);
}

// параметры электрода
EW =      7.62; // ширина
EL =     16.00; // длина
EH =      0.50; // толщина
EG =      0.10; // зазор между электродом и стенкой
EB = 3.00*2.54; // высота закрытой части электрода

module electrode()
{
	color("DarkSlateGray")
	translate([0, 0, -EH])
	cube([EW, EL, EH]);
}

// расположение контактов одноплощадочного электрода
SX11 = 1.00*2.54; // X координата нижнего  левого  электрода
SY11 = 0.25*2.54; // Y координата нижнего  левого  электрода
SX12 =      SX11; // X координата верхнего левого  электрода
SY12 = 1.00*2.54; // Y координата верхнего левого  электрода
SX21 = 2.00*2.54; // X координата нижнего  правого электрода
SY21 =      SY11; // Y координата нижнего  правого электрода
SX22 =      SX21; // X координата верхнего правого электрода
SY22 =      SY12; // Y координата верхнего правого электрода

module single_electrode()
{
	electrode();

	color("Sienna")
	{
		translate([SX11-0.5, 0, 0])
		cube([1, 1.25*2.54, 0.001]);
		translate([SX21-0.5, 0, 0])
		cube([1, 1.25*2.54, 0.001]);
		translate([EW/2-1.0, EL-3.5-1.0, 0])
		cube([2, 2, 0.001]);
		translate([2.50*2.54-1.0, 2.50*2.54-1.0, 0])
		cube([2, 2, 0.001]);
	}
}

module single_probe_array()
{
	translate([SX11, SY11, 0]) probe();
	translate([SX12, SY12, 0]) probe();
	translate([SX21, SY21, 0]) probe();
	translate([SX22, SY22, 0]) probe();
}

module single_probe_box_array()
{
	translate([SX11, SY11, 0]) probe_box();
	translate([SX12, SY12, 0]) probe_box();
	translate([SX21, SY21, 0]) probe_box();
	translate([SX22, SY22, 0]) probe_box();
}

// single_electrode();
// single_probe_array();

// расположение контактов многоплощадочного электрода
MNX  =         2; // число рядов электродов
MNY  =         5; // число электродов в одном ряду
MDX  = 1.00*2.54; // расстояние между рядами электродов
MDY  = 0.50*2.54; // шаг электродов
MX11 = 0.50*2.54; // X координата нижнего левого электрода
MY11 = 0.50*2.54; // Y координата нижнего левого электрода
MX01 = 2.50*2.54; // X координата общего электрода #1
MY01 = 0.75*2.54; // Y координата общего электрода #1
MX02 =      MX01; // X координата общего электрода #2
MY02 = 1.25*2.54; // Y координата общего электрода #2

module multiple_electrode()
{
	electrode();

	color("Sienna")
	{
		for(x=[MX11:MDX:MX11+(MNX-1)*MDX])
		for(y=[MY11:MDY:MY11+(MNY-1)*MDY])
		{
			translate([x, y, 0.001/2])
			cube([0.50*2.54, 0.35*2.54, 0.001], center=true);
		}
		translate([MX01, EL-10.2, 0.001/2])
		cube([2, 2, 0.001], center=true);
		translate([MX01-0.5, 0, 0])
		cube([1, EL-11.2, 0.001]);
		translate([2.75, EL-3.5, 0.001/2])
		cube([1.5, 0.25, 0.001], center=true);
	}
}

module multiple_probe_array()
{
	for(x=[MX11:MDX:MX11+(MNX-1)*MDX])
	for(y=[MY11:MDY:MY11+(MNY-1)*MDY])
	{
		translate([x, y, 0]) probe();
	}
	translate([MX01, MY01, 0]) probe();
	translate([MX02, MY02, 0]) probe();
}

module multiple_probe_box_array()
{
	for(x=[MX11:MDX:MX11+(MNX-1)*MDX])
	for(y=[MY11:MDY:MY11+(MNY-1)*MDY])
	{
		translate([x, y, 0]) probe_box();
	}
	translate([MX01, MY01, 0]) probe_box();
	translate([MX02, MY02, 0]) probe_box();
}

PBB = 1.0;
PBW = EW;
PBL = EB;
PBH = PH2-3.0;
PBX = 0;
PBY = 0;
PBZ = PH1+1.0;

EBB = 1.0;
EBW = PBW+2*EBB;
EBL = PBL+2*EBB;
EBH = EBB+EH+PH1+PBH-1.0;
EBX = -EBB;
EBY = -EBB;
EBZ = -EH-EBB;

module probes_box()
{
	// body
	translate([PBX, PBY, PBZ])
	cube([PBW, PBL, PBH]);

	// head
	translate([PBX-EBB-PBB, PBY-EBB-PBB, PBZ+PBH-PBB])
	cube([PBW+2*EBB+2*PBB, PBL+2*EBB+PBB, PBB]);

	// left
	translate([PBX-EBB-PBB, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
	cube([PBB-EG, PBL+2*EBB+PBB, EBH+1.0-EBB]);

	// left leg
	hull()
	{
		translate([PBX-EBB-3*PBB, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
		cube([3*PBB-EG, PBL+2*EBB+PBB, PBB/2]);

		translate([PBX-EBB-PBB, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
		cube([PBB-EG, PBL+2*EBB+PBB, PBB]);
	}

	// right
	translate([PBX+PBW+EBB+EG, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
	cube([PBB-EG, PBL+2*EBB+PBB, EBH+1.0-EBB]);

	// right leg
	hull()
	{
		translate([PBX+PBW+EBB+EG, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
		cube([3*PBB-EG, PBL+2*EBB+PBB, PBB/2]);

		translate([PBX+PBW+EBB+EG, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
		cube([PBB-EG, PBL+2*EBB+PBB, PBB]);
	}

	// near wall
	translate([PBX-EBB-PBB, PBY-EBB-PBB, PBZ+PBH-EBH-1.0+EBB])
	cube([PBW+2*EBB+2*PBB, PBB-EG, EBH+1.0-EBB]);

	dx = (PBW+2*EBB+2*PBB)/(12+1);

	for(x=[dx:dx:12*dx])
	{
		translate([x-0.6/2, 0, 0])
		translate([PBX-EBB-PBB, PBY-EBB-PBB, PBZ+PBH-4*PBB])
		difference()
		{
			hull()
			{
				translate([0, 0, -0.3])
				cube([0.6, g, 1.2]);
				translate([0, -0.6, 0])
				cube([0.6, g, 0.6]);
			}

			translate([0.3, -0.3, -0.3])
			cylinder(d=0.35, h=1.2);
		}
	}
}

module single_probes_box()
{
	color("Grey")
	{
		difference()
		{
			probes_box();
			single_probe_box_array();
		}
	}
}

module multiple_probes_box()
{
	color("Grey")
	{
		difference()
		{
			probes_box();
			multiple_probe_box_array();
		}
	}
}

module electrode_box()
{
	color("Red")
	{
		difference()
		{
			union()
			{
				// main
				translate([EBX, EBY, EBZ])
				cube([EBW, EBL, EBH]);

				// bottom
				translate([EBX-EBB-2*PBB, EBY-PBB, EBZ])
				cube([EBW+2*EBB+4*PBB, EBL+PBB, EBB]);
			}

			translate([-EG, -EG, -EH])
			cube([EW+2*EG, EB+EG+EBB+g, EBH-EBB+g]);
		}

		// top wall right
		hull()
		{
			translate([EBX, EB+EG, EBZ+EBB+EH+EG])
			cube([EBB-EG, EBB-EG, EBH-EBB-EH-EG]);

			translate([EBX+EBW/2-g, EBY+EBL-EBB+EG, EBZ+EBB+EH+EBB])
			cube([g, EBB-EG, EBH-EBB-EH-EBB]);
		}

		// top wall left
		hull()
		{
			translate([EBX+EBW/2, EBY+EBL-EBB+EG, EBZ+EBB+EH+EBB])
			cube([g, EBB-EG, EBH-EBB-EH-EBB]);

			translate([EBX+EBW-EBB+EG, EB+EG, EBZ+EBB+EH+EG])
			cube([EBB-EG, EBB-EG, EBH-EBB-EH-EG]);
		}
	}
}

module latch()
{

}

module view()
{
	// single_electrode();
	// single_probe_array();
	// single_probes_box();

	multiple_electrode();
	multiple_probe_array();
	multiple_probes_box();

	electrode_box();

	latch();
}

module print_sla()
{
	translate([0, 0, -EBZ])
	electrode_box();

	translate([22, 0, 0])
	rotate([0, 180, 0])
	translate([0, 0, -PBZ-PBH])
	multiple_probes_box();

	translate([39, 0, 0])
	rotate([0, 180, 0])
	translate([0, 0, -PBZ-PBH])
	single_probes_box();
}

view();
*print_sla();