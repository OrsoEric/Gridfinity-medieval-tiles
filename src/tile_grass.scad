include <gridfinity_modules.scad>


//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

module tile_grass(in_seed)
{

	union()
	{
		
		grid_block(num_x=1, num_y=1, num_z=0.5, magnet_diameter=0, screw_depth=0);
		translate([0,0,6])
		terrain(in_seed = in_seed, in_max_levels = 5, in_width = 41, in_z_delta = 4, in_z_offset = 1);
	}
}

module grid_of_tiles(rows, cols, spacing, in_seed_start)
{
    for (x = [0:cols-1])
    for (y = [0:rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass(in_seed = in_seed_start+y*cols+x); // Random seed
    }
}

// Set rows, columns, and spacing
grid_of_tiles(rows = 5, cols = 5, spacing = 42, in_seed_start=100);

//tile_grass();