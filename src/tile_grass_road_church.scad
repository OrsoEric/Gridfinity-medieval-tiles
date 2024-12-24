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

module pin( in_x, in_y, in_half_pitch = 41/2, in_z_top = 14, in_z_drill = 7 )
{
	translate([in_x*in_half_pitch,in_y*in_half_pitch,in_z_top-in_z_drill])
	linear_extrude(in_z_drill)
	circle(d=2.5+0.3, $fs=0.1);
}




//A grass tile with a road going straight through
module tile_grass_road_church(in_seed)
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
			//on top create a half weavy road
			translate([-41/4,0,n_z_road_top_height-n_z_road_thickness])
			bar_sin(41/2, n_w_road_width,n_z_road_thickness, 1, 1);

			//create a basement for the buildings?
			translate([0,0,4])
			linear_extrude(10)
			circle(d=20, $fs=0.1);

			//On top create a church
			translate([0,0,12])
			rotate([0,0,90])
			church();
		}
		union()
		{
			//on top create a weavy road to extrude and create the sides of the road
			translate([-41/4,0,n_z_road_top_height-n_z_road_indent])
			bar_sin(41/2, n_w_road_width-2, n_z_road_indent, 1, 1);
			
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

tile_grass_road_church(0);

