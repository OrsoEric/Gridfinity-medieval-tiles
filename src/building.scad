//Library to create buildings
//	a simple box with triangle roof
//	a tower with top room and triangle roof


//Rounded Poly Library for the heraldry symbol
//Credits to:
//IrevDev
//https://github.com/Irev-Dev/Round-Anything/blob/master/polyround.scad
include <polyround.scad>

module pin
(
	in_x,
	in_y,
	in_z_top,
	in_z_drill
)
{
	translate([in_x,in_y,in_z_top-in_z_drill])
	linear_extrude(in_z_drill)
	circle(d=2.5+0.45, $fs=0.1);
}

// Module to create a truncated cone using rotate_extrude and polygon
module truncated_cone
(
	id_low,
	id_top,
	iz_height
)
{
    // Define the 2D profile for the truncated cone
    points = [
		[0,0],
        [id_low / 2, 0],  // Bottom inner radius point
        [id_top / 2, iz_height],  // Top inner radius point
		[0,iz_height]
    ];

    // Use rotate_extrude to create the 3D shape
    rotate_extrude($fs=0.1)
	{
        polygon(points);
    }
}

module house(in_length=30, in_width = 10, in_tall=15 , in_roof_ratio=1/4) {
    // Define the 2D outline of the house
	translate([-in_width/2,in_length/2,0])
	rotate([90,0,0])
	linear_extrude(height = in_length)
    polygon
	(
		points=
		[
			[0, 0],               
			[in_width, 0],        
			[in_width, in_tall*(1-in_roof_ratio)],
			// Apex of the triangular roof
			[in_width / 2, in_tall], 
			[0,in_tall*(1-in_roof_ratio)] 
		]
	);
}

module herald(iy_height, ix_width,iz_height)
{
	r_rounding = (iy_height+iy_height);
    // Define points relative to width and height
    ann_points =
	[
		//Top point
        [+0.0 * ix_width, +0.5 *iy_height, +0.01 *r_rounding],
		//Left point
		[+0.5 * ix_width, +0.4 *iy_height, +0.05 *r_rounding],
		[+0.45 * ix_width, +0.1 *iy_height, +0.2 *r_rounding],

		//Down point (long arc)
		[+0.0 * ix_width, -0.5 *iy_height, +0.05 *r_rounding],
		//Right point
		[-0.45 * ix_width, +0.1 *iy_height, +0.2 *r_rounding],
		[-0.5 * ix_width, +0.4 *iy_height, +0.05 *r_rounding],
        
    ];
    
    // Create the polygon with rounded corners and extrude
    linear_extrude(iz_height)
    polygon(polyRound(ann_points, 20));
}

// Example usage with specific width and height
//herald(20, 10, 5);

module round_tower
(
	ir_stalk = 5,
	ir_top = 7,
	iz_height = 30,
	in_stalk_ratio = 4/7,
	in_roof_ratio = 2/7
)
{
    rotate_extrude($fs=0.1)
	{
        // Define the 2D profile of the tower
        polygon(
            points = [
				// Base of the stalk
				[0, 0],                        
                [ir_stalk, 0],                        
				// End of the stalk
                [ir_stalk, iz_height*in_stalk_ratio-(ir_top-ir_stalk)],         
				//TOP
                [ir_top, iz_height*in_stalk_ratio],               
                [ir_top, iz_height*(1-in_roof_ratio)],
				//ROOF
                [0, iz_height]
            ]
        );
    }
}

//church();

//I use two houses to make a cross, and a round tower to make the bell
module church
(
	in_lenght=20,
	in_width=13,
	in_height=20,
	in_width_building = 6,
	in_z_ratio_tower = 2/5
)
{
	//lengthwise 
	house(in_lenght, in_width_building, in_height*in_z_ratio_tower);
	//widewise
	translate([0,in_lenght/5,0])
	rotate([0,0,90])
	house(in_width, in_width_building, in_height*in_z_ratio_tower);

	translate([0,in_lenght/5,0])
	round_tower(iz_height=in_height,ir_stalk=in_width_building/2,ir_top=in_width_building/2+1);

}


module wall(i_start, i_end, in_w=4, in_z_height=12)
{
    // Calculate the angle of the wall line
    dx = i_end[0] - i_start[0];
    dy = i_end[1] - i_start[1];
    angle = atan2(dy, dx);

    // Calculate the offset for half the width
    offset_x = (in_w / 2) * cos(angle + 90);
    offset_y = (in_w / 2) * sin(angle + 90);

    // Define the polygon vertices
    linear_extrude(height=in_z_height)
    polygon([
        [i_start[0] + offset_x, i_start[1] + offset_y],
        [i_start[0] - offset_x, i_start[1] - offset_y],
        [i_end[0] - offset_x, i_end[1] - offset_y],
        [i_end[0] + offset_x, i_end[1] + offset_y]
    ]);
}

module wall_with_indent( i_start, i_end, in_w=4, in_z_height=12, in_w_indent = 1, in_z_indent = 3 )
{
	difference()
	{
		wall(i_start, i_end, in_w, in_z_height=in_z_height);
		translate([0,0,in_z_height-in_z_indent])
		wall(i_start, i_end, in_w=in_w-in_w_indent, in_z_height=in_z_indent);
	}
}

// OpenSCAD function to calculate bounding box of a polygon
function calculate_bounds(polygon_points) = [
    // Compute the bounding box
    min([for (point = polygon_points) point[0]]), // xmin
    min([for (point = polygon_points) point[1]]), // ymin
    max([for (point = polygon_points) point[0]]), // xmax
    max([for (point = polygon_points) point[1]])  // ymax
];

//I create a slab with houses on it, and cut out to form a polygon
module city
(	
	//Polygon where houses are to be spawned
	i_area,
	//height of the plaza below the houses
	iz_plaza_height = 6,
	//Number of small houses to be procedurally generated
	in_num_houses_small = 40,
	//Number of medium houses to be procedurally generated
	in_num_houses_medium = 5,
	//Number of towers
	in_num_towers = 0,
	//Margins to the polygon where buildings are spawned
	in_margin = 2
)
{
	//Calculate a rectangle that has the given limits
	bounds = calculate_bounds(i_area);
	echo("Limits: ", bounds);

	//RECTANGLE OUTER BOUNDING OF POLYGON
	rectangle =
	[
		//xmin ymin
		[bounds[0],bounds[1]],
		//xmin ymax
		[bounds[0],bounds[3]],
		//xmax ymax
		[bounds[2],bounds[3]],
		//xmax ymin
		[bounds[2],bounds[1]],
	];

	//NEGATIVE POLYGON MASK
	n_outer_margin = 10;
	//create the outer mask that will be needed to extrude
	outer_box =
	[
		//xmin ymin
		[bounds[0]-n_outer_margin,bounds[1]-n_outer_margin],
		//xmin ymax
		[bounds[0]-n_outer_margin,bounds[3]+n_outer_margin],
		//xmax ymax
		[bounds[2]+n_outer_margin,bounds[3]+n_outer_margin],
		//xmax ymin
		[bounds[2]+n_outer_margin,bounds[1]-n_outer_margin],
	];

	//CREATE CITY
	difference()
	{
		union()
		{
			//Construct the base where the buildings will be placed
			linear_extrude(iz_plaza_height)
			polygon( rectangle );

			//Place SMALL houses
			for (i = [0:in_num_houses_small-1])
			{
				// Generate random positions within the polygon boundary
				//xmin + rand(xmax-xmin)
				rand_x = bounds[0] + (bounds[2] - bounds[0]) * rands(1, 0, 1)[0];
				rand_y = bounds[1] + (bounds[3] - bounds[1]) * rands(1, 0, 1)[0];
				rand_r = rands(-90,90,1)[0];
				//echo("House Position: ", rand_x,rand_y);
				translate([rand_x,rand_y,iz_plaza_height])
				rotate([0,0,rand_r])
				house
				(
					in_length=2,
					in_width =2,
					in_tall=3
				);
			}

			//Place MEDIUM houses
			for (i = [0:in_num_houses_medium-1])
			{
				// Generate random positions within the polygon boundary
				//xmin + rand(xmax-xmin)
				rand_x = bounds[0] + in_margin + (bounds[2] - bounds[0] - 2*in_margin) * rands(1, 0, 1)[0];
				rand_y = bounds[1] + in_margin + (bounds[3] - bounds[1] - 2*in_margin) * rands(1, 0, 1)[0];
				rand_r = rands(-90,90,1)[0];
				//echo("House Position: ", rand_x,rand_y);
				translate([rand_x,rand_y,iz_plaza_height])
				rotate([0,0,rand_r])
				house
				(
					in_length=3,
					in_width =2,
					in_tall=5
				);
			}
			if (in_num_towers > 0)
			{
			//Place towers
			for (i = [0:in_num_towers-1])
			{
				// Generate random positions within the polygon boundary
				//xmin + rand(xmax-xmin)
				rand_x = bounds[0] + in_margin + (bounds[2] - bounds[0] - 2*in_margin) * rands(1, 0, 1)[0];
				rand_y = bounds[1] + in_margin + (bounds[3] - bounds[1] - 2*in_margin) * rands(1, 0, 1)[0];
				rand_r = rands(-90,90,1)[0];
				//echo("House Position: ", rand_x,rand_y);
				translate([rand_x,rand_y,iz_plaza_height])
				rotate([0,0,rand_r])
				round_tower
				(
					ir_stalk = 1,
					ir_top = 1.5,
					iz_height = 6
				);
			}
			}

		}
		union()
		{
			//Negative Polygon Mask to delete what's outside the polygon
			difference()
			{
				//Large bounding box
				linear_extrude(iz_plaza_height*2)
				polygon( outer_box );
				//Poligon that will be negated
				linear_extrude(iz_plaza_height*2)
				polygon( i_area );
			}
		}
	}	//CREATE CITY

}

if (false)
{
	city
	(
		[
			[18.3, 18.3],
			[10, 10],
			[-10, 10],
			[-18.3, 18.3]
		]
	);
}


//test house
//house();
//Test round tower
//round_tower();

//church();

//Test wall

//wall([0,0], [10,20], 8, 10);

//wall_with_indent([0,-0],[10,20], in_w=4, in_z_height=16, in_w_indent = 1.5, in_z_indent=2);

