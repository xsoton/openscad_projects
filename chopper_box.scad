use <electrode_box.scad>

$fn=200;

// диск модулятора
module disk()
{
	d1 = 2;     // диаметр центрального отверстия
	d2 = 46;    // внутренний диаметр вырезов
	d3 = 82;    // внешний диаметр вырезов
	d4 = 86;    // внешний диаметр диска
	n  = 12;    // количество вырезы
	da = 360/n; // угловой шаг вырезов

	difference()
	{
		// весь диск
		cylinder(d=d4, h=2);

		// центрально отверстие
		translate([0, 0, -0.01])
		cylinder(d=d1, h=2.02);

		// вырезы
		translate([0, 0, -0.01])
		for(a=[0:da:360-da])
		rotate([0, 0, a-da/4])
		rotate_extrude(angle=da/2)
		translate([d2/2, 0, 0])
		square([(d3-d2)/2, 2.02]);
	}
}

// радиатор охлаждения
module radiator()
{
	d1 = 14;    // диаметр излучателя
	d2 = 15.4;  // диаметр упорного кольца
	h2 = 10;    // смещение упока
	d3 = 25;    // диамтер основания радиатора
	w  = 51;    // ширина радиатора
	l  = 51;    // длина радиатора
	h  = 30.2;  // высота радиатора
	n  = 12;    // количество ребер
	da = 360/n; // угловой шаг ребер
	d  = 2.7;   // ширина ребер
	wl = max(w,l); // максимальный латеральный размер
	fw = 12;    // длина "ног"

	difference()
	{
		union()
		{
			cylinder(d=d3, h=h);

			for(a=[0:da:360-da])
			rotate([0, 0, a])
			translate([-d/2, 0, 0])
			cube([d, max(w,l), h]);

			translate([w/2-fw, l/2-d, 0])
			cube([fw, d, h]);
			translate([-w/2, l/2-d, 0])
			cube([fw, d, h]);
			translate([w/2-fw, -l/2, 0])
			cube([fw, d, h]);
			translate([-w/2, -l/2, 0])
			cube([fw, d, h]);
		}

		difference()
		{
			cube_gap()
			translate([-wl, -wl, 0])
			cube([2*wl, 2*wl, h]);

			translate([-w/2, -l/2, 0])
			cube([w, l, h]);
		}

		translate([0, 0, -0.01])
		cylinder(d=d1, h=h+0.02);

		translate([0, 0, h2])
		cylinder(d=d2, h=h-h2+0.01);
	}
}

radiator();
disk();
electrode_box();
