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

//Buildings definitions
include <building.scad>

n_gridfinity_pitch = 41;
n_gridfinity_half_pitch = 41/2;

n_terrain_roughness = 10;

//A grass tile with a road going straight through
module tile_grass_road_church(ib_road=false)
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
			hill(in_max_levels = 5, in_width = 41, in_z_delta = 5.0, in_z_offset = 1,in_erosion=2,in_z_random=3);

			//on top create a half weavy road
			if (ib_road == true)
			{
				translate([-41/2.666,0,n_z_road_top_height-n_z_road_thickness])
				bar_sin(41/4, n_w_road_width,n_z_road_thickness, 1, 0);
			}

			
			//create a basement for the buildings?
			translate([-0.5,0,8])
			truncated_cone(24,22,6);

			//On top create a church
			
			translate([-0.5,0,10])
			rotate([0,0,-90])
			church(in_lenght=20, in_width=13, in_height=30);
		}
		union()
		{
			if (ib_road == true)
			{
				//on top create a weavy road to extrude and create the sides of the road
				translate([-41/2.666,0,n_z_road_top_height-n_z_road_indent])
				bar_sin(41/4, n_w_road_width-2, n_z_road_indent, 1, 0);
				
				//Drill a hole on the road
				pin(-0.8, -0.0);
			}
			
			//drill the church
			pin(-0.4, -0.0, in_z_top=24, in_z_drill=9);

			//Drill the grassland
			pin(-0.6, -0.6);
			
		}
	}
}

module grid_of_tiles(in_rows = 1, in_cols = 1, spacing = 42, in_with_road = 1)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass_road_church(x*in_cols+y<in_with_road); // Random seed
    }
}

//tile_grass_road_church(true);

grid_of_tiles(in_rows=3,in_cols=3, in_with_road=5);
