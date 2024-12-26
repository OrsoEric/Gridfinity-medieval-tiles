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
include <building.scad>

//------------------------------------------------------------------------------
//	GRASS TILE + STRAIGHT ROAD OPTION FOR TWO, THREE, FOUR WAYS
//------------------------------------------------------------------------------

//tile_grass_road_straight();
//tile_grass_road_straight(4);

module tile_grass_road_straight
(
	//Nimber of quarters that are roads (2,3,4)
	in_roads = 2
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
			terrain
			(
				in_max_levels = 4,
				in_width = gw_gridfinity,
				iz_min_surface_height = gz_grass_base,
				iz_max_surface_height = gz_grass_flat,
				//I want grass to have very consistent max height
				in_height_roll = gn_grass_flat_consistency,
				in_erosion = 1
			);

			//on top create a weavy road
			translate([0,0,gz_road_top_height-gz_road_height])
			bar_sin
			(
				in_l = gw_gridfinity,
				in_w = gw_road_width,
				in_z = gz_road_height,
				in_w_amplitude = 1,
				in_frequency = 2
			);
			if (in_roads == 3)
			{
				rotate([0,0,90])
				translate([gw_gridfinity/4,0,gz_road_top_height-gz_road_height])
				bar_sin
				(
					in_l = gw_gridfinity/2,
					in_w = gw_road_width,
					in_z = gz_road_height,
					in_w_amplitude = -1,
					in_frequency = 1
				);
			}
			else if (in_roads == 4)
			{
				rotate([0,0,90])
				translate([0,0,gz_road_top_height-gz_road_height])
				bar_sin
				(
					in_l = gw_gridfinity,
					in_w = gw_road_width,
					in_z = gz_road_height,
					in_w_amplitude = 1,
					in_frequency = 2
				);
			}
		}
		union()
		{
			translate([0,0,gz_road_top_height-gz_road_indent])
			bar_sin
			(
				in_l = gw_gridfinity,
				in_w = gw_road_width-gw_road_indent,
				in_z = gw_road_indent,
				in_w_amplitude = 1,
				in_frequency = 2
			);
			if (in_roads == 3)
			{
				rotate([0,0,90])
				translate([gw_gridfinity/4,0,gz_road_top_height-gz_road_indent])
				bar_sin
				(
					in_l = gw_gridfinity/2,
					in_w = gw_road_width-gw_road_indent,
					in_z = gw_road_indent,
					in_w_amplitude = -1,
					in_frequency = 1
				);
			}
			//if it's a four way crossroad
			else if (in_roads == 4)
			{
				rotate([0,0,90])
				translate([0,0,gz_road_top_height-gz_road_indent])
				bar_sin
				(
					in_l = gw_gridfinity,
					in_w = gw_road_width-gw_road_indent,
					in_z = gw_road_indent,
					in_w_amplitude = 1,
					in_frequency = 2
				);
			}

			if (in_roads >= 2)
			{
				//Drill a hole for the EAST road 
				pin
				(
					in_x = +0.8 *gw_gridfinity_half_pitch,
					in_y = -0.05 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
				//Drill a hole for the SOUTH-EAST field 
				pin
				(
					in_x = +0.6 *gw_gridfinity_half_pitch,
					in_y = -0.6 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_top_height,
					in_z_drill = 8
				);
				//Drill a hole for the WEST road 
				pin
				(
					in_x = -0.8 *gw_gridfinity_half_pitch,
					in_y = +0.05 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
				//Drill a hole for the NORTH-WEST field 
				pin
				(
					in_x = -0.6 *gw_gridfinity_half_pitch,
					in_y = +0.6 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_top_height,
					in_z_drill = 8
				);

			}
			if (in_roads >= 3)
			{
				//Drill a hole for the NORTH road 
				pin
				(
					in_x = +0.05 *gw_gridfinity_half_pitch,
					in_y = +0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
				//Drill a hole for the NORTH-EAST field 
				pin
				(
					in_x = +0.6 *gw_gridfinity_half_pitch,
					in_y = +0.6 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_top_height,
					in_z_drill = 8
				);
			}
			if (in_roads >= 4)
			{
				//Drill a hole for the SOUTH road 
				pin
				(
					in_x = -0.05 *gw_gridfinity_half_pitch,
					in_y = -0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
				//Drill a hole for the SOUTH-WEST field 
				pin
				(
					in_x = -0.6 *gw_gridfinity_half_pitch,
					in_y = -0.6 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_top_height,
					in_z_drill = 8
				);
			}	
		}
	}
}


//------------------------------------------------------------------------------
//	GRASS TILE + CURVED ROAD
//------------------------------------------------------------------------------

//tile_grass_road_curved();

module tile_grass_road_curved()
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
				in_erosion = 1
			);

			//on top create a weavy road
			translate([0,0,gz_road_top_height-gz_road_height])
			bar_curved_weavy_indented
			(
				in_r = gw_gridfinity_half_pitch,
				in_w = gw_road_width,
				in_z = gz_road_height,
				iw_indent = gw_road_indent,
				iz_indent = gz_road_indent
			);
		}
		union()
		{
			//Drill a hole for theroad 
			pin
			(
				in_x = +0.0 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//Drill a hole for the NORTH-EAST field 
			pin
			(
				in_x = +0.6 *gw_gridfinity_half_pitch,
				in_y = +0.6 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//Drill a hole for the SOUTH-WEST field 
			pin
			(
				in_x = -0.6 *gw_gridfinity_half_pitch,
				in_y = -0.6 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

//------------------------------------------------------------------------------
//	GENERATE PRINTABLE GRID OF TILES
//------------------------------------------------------------------------------

module grid_of_tiles(in_rows, in_cols, spacing, in_seed_start)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
        translate([x * spacing, y * spacing, 0])
            tile_grass_road();
    }
}


module grid_of_tiles
(
	//Maximum grid size
	in_rows = 1,
	in_cols = 1,
	//Number of tiles to generate in the grid
	in_grass_road_two_way_straight = 9,
	in_grass_road_two_way_curved = 9,
	in_grass_road_three_way = 5,
	in_grass_road_four_way = 2
	
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * gw_gridfinity_spacing, y * gw_gridfinity_spacing, 0])
		if(n < in_grass_road_two_way_straight)
		{	
			tile_grass_road_straight(2);
		}
		else if
		(
			n <
			in_grass_road_two_way_straight+
			in_grass_road_three_way
		)
		{
			tile_grass_road_straight(3);
		}	
		else if
		(
			n <
			in_grass_road_two_way_straight+
			in_grass_road_three_way+
			in_grass_road_four_way
		)
		{
			tile_grass_road_straight(4);
		}	
		else if
		(
			n <
			in_grass_road_two_way_straight+
			in_grass_road_three_way+
			in_grass_road_four_way+
			in_grass_road_two_way_curved
		)
		{
			tile_grass_road_curved();
		}
		else
		{
			//DO NOT SPAWN TILES
		}
	}
}

grid_of_tiles(5,5);
