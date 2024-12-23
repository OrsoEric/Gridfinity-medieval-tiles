//This tile creates a church with an optional road
//Build a tile
//Build grass
//make central building
//make a road

include <gridfinity_modules.scad>


//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

//Define the weavy bars I use as roads
include <road.scad>

n_gridfinity_half_pitch = 41/2;

module building(in_width = 10, in_tall=15, in_length=30, in_roof_ratio=1/4) {
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
 
//test building
//building();

module round_tower(ir_stalk = 5, ir_top = 7, iz_height = 30, in_stalk_ratio = 4/7, in_roof_ratio = 2/7) {
    rotate_extrude()
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

module pin( in_x, in_y, in_half_pitch = 41/2, in_z_top = 14, in_z_drill = 7 )
{
	translate([in_x*in_half_pitch,in_y*in_half_pitch,in_z_top-in_z_drill])
	linear_extrude(in_z_drill)
	circle(d=2.5+0.3, $fs=0.1);
}

//Test round tower
//round_tower();


//A grass tile with a road going straight through
module tile_grass_crossroad_three_way(in_seed)
{
	//the road reaches up to this height
	n_z_road_top_height = 14;
	//the road digs inside the model by this height
	n_z_road_thickness = 7;
	n_z_road_indent = 1;

	n_w_road_width = 7;
	

	difference()
	{
		union()
		{
			//Create a grifinity tile
			grid_block(num_x=1, num_y=1, num_z=0.5, magnet_diameter=0, screw_depth=0);
			//On top, create a fractal terrain
			translate([0,0,6])
			terrain(in_seed = in_seed, in_max_levels = 5, in_width = 41, in_z_delta = 4, in_z_offset = 1);
			//on top create a weavy road
			
			translate([-41/4,0,n_z_road_top_height-n_z_road_thickness])
			bar_sin(41/2, n_w_road_width,n_z_road_thickness, 1, 1);
			rotate([0,0,90])
			translate([0,0,n_z_road_top_height-n_z_road_thickness])
			bar_sin(41, n_w_road_width,n_z_road_thickness, 1, 2);
		}
		union()
		{
			//on top create a weavy road to extrude and create the sides of the road
			translate([-41/4,0,n_z_road_top_height-n_z_road_indent])
			bar_sin(41/2, n_w_road_width-2, n_z_road_indent, 1, 1);
			rotate([0,0,90])
			translate([0,0,n_z_road_top_height-n_z_road_indent])
			bar_sin(41, n_w_road_width-2, n_z_road_indent, 1, 2);
			
			//Drill a hole for each of the three roads
			pin(-0.8, -0.05);
			pin(-0.05, -0.8);
			pin(+0.05, +0.8);
			//Drill the grassland
			pin(-0.6, -0.6);
			pin(-0.6, +0.6);
			pin(+0.6, +0.0);
		}
	}
}

tile_grass_crossroad_three_way(0);

