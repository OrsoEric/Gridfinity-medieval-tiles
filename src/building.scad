//Library to create buildings
//	a simple box with triangle roof
//	a tower with top room and triangle roof


// Module to create a truncated cone using rotate_extrude and polygon
module truncated_cone(id_low, id_top, iz_height)
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
 
module round_tower(ir_stalk = 5, ir_top = 7, iz_height = 30, in_stalk_ratio = 4/7, in_roof_ratio = 2/7) {
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

//I use two houses to make a cross, and a round tower to make the bell
module church( in_lenght=20, in_width=13, in_height=20, in_width_building = 6, in_z_ratio_tower = 2/5)
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


module wall(ix_start, iy_start, ix_end, iy_end, in_w=4, in_z_height=12)
{
    // Calculate the angle of the wall line
    dx = ix_end - ix_start;
    dy = iy_end - iy_start;
    angle = atan2(dy, dx);

    // Calculate the offset for half the width
    offset_x = (in_w / 2) * cos(angle + 90);
    offset_y = (in_w / 2) * sin(angle + 90);

    // Define the polygon vertices
    linear_extrude(height=in_z_height)
    polygon([
        [ix_start + offset_x, iy_start + offset_y],
        [ix_start - offset_x, iy_start - offset_y],
        [ix_end - offset_x, iy_end - offset_y],
        [ix_end + offset_x, iy_end + offset_y]
    ]);
}

module wall_with_indent( ix_start, iy_start, ix_end, iy_end, in_w=4, in_z_height=12, in_w_indent = 1, in_z_indent = 3 )
{
	difference()
	{
		wall(ix_start, iy_start, ix_end, iy_end, in_w, in_z_height=12);
		translate([0,0,in_z_height-in_z_indent])
		wall(ix_start, iy_start, ix_end, iy_end, in_w=in_w-in_w_indent, in_z_height=in_z_indent);
	}
}

// Example usage
//wall(0, 0, 0, 20, 8, 10);
wall_with_indent(ix_start = 0, iy_start = 0, ix_end = 11, iy_end=13, in_w=4, in_z_height=12, in_w_indent = 1.5, in_z_indent=2);


//test house
//house();
//Test round tower
//round_tower();

//church();
