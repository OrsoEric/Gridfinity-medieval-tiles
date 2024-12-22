include <gridfinity_modules.scad>


//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

module tile_grass()
{

	union()
	{
		
		grid_block(num_x=1, num_y=1, num_z=0.5, magnet_diameter=0, screw_depth=0);
		translate([0,0,6])
		terrain(in_seed = 20, in_max_levels = 4, in_width = 41, in_z_delta = 5);
	}
}

tile_grass();