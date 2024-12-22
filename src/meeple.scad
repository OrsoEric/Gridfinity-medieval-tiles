// author: clayb.rpi@gmail.com
// date: 2012-05-05
// units: mm
// description: a meeple character for games

//LICENSE Creative Commons
//AUTHOR:
//https://www.thingiverse.com/buckyball
//REPO
//https://www.thingiverse.com/thing:22696/remixes

//2024-12-22
//refactored var and function
//adjusted dimensions
//Made a meeple with a vertical through hole to have pins

cn_width = 12;
cn_height = 16;
cn_thickness = 5;
cd_head = 6;
cr_smooth = 1;
cd_foot_hole = 5.5;

cd_hole_through = 2.5+0.3;
//2/sqrt(3)*5
cd_nut = 5.73+0.3;
cl_nut = 4;

$fn=50;

module meeple_with_hole()
{
	difference()
	{
		union()
		{
			meeple();
		}
		union()
		{
			//M2.5 bolt through hole
			translate([0,0,cn_thickness/2])
			rotate([0,90,90])
			linear_extrude(cn_height)
			circle(r=cd_hole_through/2);
			//M2.5 nut hex hole
			translate([0,0,cn_thickness/2])
			rotate([0,90,90])
			linear_extrude(cl_nut)
			circle(r=cd_nut/2,$fn=6);
		}
	}


}

module meeple()
{
	linear_extrude(cn_thickness)
	union()
	{
		// head
		translate([0, cn_height - cd_head / 2])
		circle(r=cd_head / 2);

		// body
		difference()
		{
			hull()
			{
				translate([-(cn_width /2 - cr_smooth), cr_smooth])
				circle(r=cr_smooth);

				translate([cn_width /2 - cr_smooth, cr_smooth])
				circle(r=cr_smooth);

				translate([0, cn_height - cd_head])
				circle(r=cr_smooth);
			}

			// foot cutout
			circle(r=cd_foot_hole / 2);
		}

		// arms
		hull()
		{
			translate([cn_width / 2 - cr_smooth, cn_height / 2])
			circle(r=cr_smooth);

			translate([-cn_width / 2 + cr_smooth, cn_height / 2])
			circle(r=cr_smooth);

			translate([0, cn_height / 2 + cr_smooth])
			circle(r=cd_head / 2);
		}
	}
}

//meeple();
meeple_with_hole();