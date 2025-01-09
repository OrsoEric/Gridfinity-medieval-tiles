//Credits to 2022 Jamie MIT License <vector76@gmail.com>
//Repo: https://github.com/vector76/gridfinity_openscad
include <gridfinity_modules.scad>

//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
//Heavily modified to make boxes of consistent height and roll on maximum height instead of scaling factors
include <terrain.scad>

//Tile Constants
include <tile_constants.scad>

include <url.scad>

module tile_grass()
{
	difference()
	{
		union()
		{
			//Instance a gridfinity base tile
			grid_block
			(
				num_x=1,
				num_y=1,
				num_z=0.5,
				magnet_diameter=0,
				screw_depth=0
			);
			//Instance fractal terrain
			translate([0,0,gz_gridfinity_socket_offset])
			terrain
			(
				in_max_levels = 4,
				in_width = gw_gridfinity,
				iz_min_surface_height = gz_grass_base,
				iz_max_surface_height = gz_grass_flat,
				//I want grass to have very consistent max height
				in_height_roll = gn_grass_flat_consistency,
				ir_corner_rounding = gr_corner_terrain_rounding,
				in_erosion = 1
			);
		}
		union()
		{
			//Etch the URL to the repo on the back of the tiles
			translate([-0.7*gw_gridfinity/2,-0.0*gw_gridfinity/2,+0.5])
			rotate([180,0,0])
			project_url(in_size = 3,iz_height = 0.5);
		}
	}
}

module grid_of_tiles(rows, cols, spacing)
{
    for (x = [0:cols-1])
    for (y = [0:rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass();
    }
}

// Set rows, columns, and spacing
grid_of_tiles(rows = 5, cols = 5, spacing = 42);

//tile_grass();