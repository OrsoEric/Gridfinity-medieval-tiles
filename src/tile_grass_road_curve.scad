include <gridfinity_modules.scad>


//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

//Define the weavy bars I use as roads
include <road.scad>

n_gridfinity_half_pitch = 41/2;

//A grass tile with a road going straight through
module tile_grass_road_curved(in_seed)
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
			translate([0,0,n_z_road_top_height-n_z_road_thickness])
			bar_curved_weavy(41/2, n_w_road_width,n_z_road_thickness, 1/30, 2);
		}
		union()
		{
			//on top create a weavy road to extrude and create the sides of the road
			translate([0,0,n_z_road_top_height-n_z_road_indent])
			bar_curved_weavy(41/2, n_w_road_width-2,n_z_road_indent, 1/30, 2);

			//Drill a number of holes to let meeple slot in
			//Drill a hole for the road
			translate([-0*n_gridfinity_half_pitch,-0.8*n_gridfinity_half_pitch,n_z_road_top_height-n_z_road_thickness])
			linear_extrude(n_z_road_thickness)
			circle(d=2.5+0.3, $fs=0.1);
			//Drill hole for the X+Y+ grass field
			translate([+0.6*n_gridfinity_half_pitch,+0.6*n_gridfinity_half_pitch,n_z_road_top_height-n_z_road_thickness])
			linear_extrude(n_z_road_thickness)
			circle(d=2.5+0.3, $fs=0.1);
			//Drill hole for the X-Y- grass field
			translate([-0.6*n_gridfinity_half_pitch,-0.6*n_gridfinity_half_pitch,n_z_road_top_height-n_z_road_thickness])
			linear_extrude(n_z_road_thickness)
			circle(d=2.5+0.3, $fs=0.1);
		}

	}
}

module grid_of_tiles(in_rows, in_cols, spacing, in_seed_start)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass_road_curved(in_seed = in_seed_start+y*in_cols+x); // Random seed
    }
}




tile_grass_road_curved(0);
//grid_of_tiles(3,3,42,500);
