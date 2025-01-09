//Credits to 2022 Jamie MIT License <vector76@gmail.com>
//Repo: https://github.com/vector76/gridfinity_openscad
include <gridfinity_modules.scad>

//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

//Tile Constants
include <tile_constants.scad>

//Define the weavy bars I use as roads
include <road.scad>

//Pin
//Church
include <building.scad>

include <url.scad>

//------------------------------------------------------------------------------
//	GRASS TILE + CHURCH + STRAIGHT ROAD OPTION
//------------------------------------------------------------------------------

//tile_grass_road_church(true);

//A grass tile with a road going straight through
module tile_grass_road_church
(
	ib_road=false
)
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
			hill
			(
				in_max_levels = 4,
				in_width = gw_gridfinity,
				iz_min_surface_height = gz_grass_base,
				iz_max_surface_height = gz_grass_hill_height,
				in_z_random = gz_grass_hill_random,
				in_height_roll = gn_grass_hill_consistency
			);
			

			//on top create a half weavy road
			if (ib_road == true)
			{
				rotate([0,0,90])
				translate([gw_gridfinity*(1/8+1/4),0,gz_road_top_height-gz_road_height])
				bar_sin_indented
				(
					in_l = gw_gridfinity/4,
					in_w = gw_road_width,
					in_z = gz_road_height,
					in_w_amplitude = -1,
					in_frequency = 0
				);
			}

			n_truncated_cone_height = 10;

			//create a basement for the buildings?
			translate([-0.5,0,gz_grass_hill_top_height-n_truncated_cone_height])
			truncated_cone
			(
				id_low = 26,
				id_top = 22,
				iz_height = n_truncated_cone_height
			);
			
			//On top create a church
			
			translate([-0.5,0,11])
			rotate([0,0,180])
			church
			(
				in_lenght=20,
				in_width=13,
				in_height=30
			);
		}
		union()
		{
			if (ib_road == true)
			{
				pin
				(
					in_x = +0.0 *gw_gridfinity_half_pitch,
					in_y = +0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
			}
			pin
			(
				in_x = -0.6 *gw_gridfinity_half_pitch,
				in_y = +0.6 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_hill_top_height,
				in_z_drill = 9
			);
			pin
			(
				in_x = -0.0 *gw_gridfinity_half_pitch,
				in_y = +0.3 *gw_gridfinity_half_pitch,
				in_z_top = 24,
				in_z_drill = 5
			);
			//Etch the URL to the repo on the back of the tiles
			translate([-0.7*gw_gridfinity/2,-0.0*gw_gridfinity/2,+0.5])
			rotate([180,0,0])
			project_url(in_size = 3,iz_height = 0.5);
		}
	}
}

//------------------------------------------------------------------------------
//	GRID OF CHURCH TILES
//------------------------------------------------------------------------------

module grid_of_tiles(in_rows = 1, in_cols = 1, spacing = 42, in_with_road = 1)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass_road_church(x*in_cols+y<in_with_road); // Random seed
    }
}

grid_of_tiles(in_rows=3,in_cols=3, in_with_road=5);
