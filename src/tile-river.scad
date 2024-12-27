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
//Quarter City
include <building.scad>

//------------------------------------------------------------------------------
//	RIVER TILE STRAIGHT + OPTION BRIDGE + OPTION 2X ONE QUARTER CITY
//------------------------------------------------------------------------------

if (false)
{
	tile_river_straight
	(
		ib_bridge = false,
		ib_one_quarter_city_first = false,
		ib_one_quarter_city_second = false
	);
}

//tile_river_straight(true, true, true);
//tile_river_straight(true, false, false);

//A grass tile with a road going straight through
module tile_river_straight
(
	ib_bridge = false,
	ib_one_quarter_city_first = false,
	ib_one_quarter_city_second = false
)
{
	difference()
	{
		union()
		{
			//Instance a gridfinity base tile
			grid_block
			(
				num_x				= 1,
				num_y 				= 1,
				num_z 				= 0.5,
				magnet_diameter		= 0,
				screw_depth			= 0
			);
			//Instance fractal terrain
			translate([0,0,gz_gridfinity_socket_offset])
			river
			(
				in_max_levels			= 5,
				in_width 				= gw_gridfinity,
				iz_min_surface_height 	= gz_grass_base,
				iz_max_surface_height 	= gz_grass_river_height,
				iz_random 				= gz_grass_river_roughness,
				iz_river_level 			= gz_water_top_height,
				ir_corner_rounding 		= gr_corner_terrain_rounding,
				in_erosion				= 1
			);
			//Instance first city quarter
			if (ib_one_quarter_city_first == true)
			{
				quarter_city_block();
			}
			//Instance second city quarter
			if (ib_one_quarter_city_second == true)
			{
				quarter_city_block(180);
			}
			
			
			//on top create a half weavy road
			if (ib_bridge == true)
			{
				rotate([0,0,90])
				translate([0,0,gz_road_top_height-gz_bridge_height])
				arch_indented
				(
					//Length of the arch
					il_length = gw_gridfinity,
					//vertical thickness of the arch
					iz_thickness = gz_bridge_height,
					//width of the arch
					iw_width=gw_road_width,
					//How tall is the hump
					iz_height=gz_bridge_hump
				);
			}
		}
		union()
		{
			if (ib_bridge == true)
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
		}
	}
}


//------------------------------------------------------------------------------
//	RIVER TILE TURN + OPTION BRIDGE + OPTION 2X ONE QUARTER CITY
//------------------------------------------------------------------------------

if (false)
{
	tile_river_turn
	(
		ib_one_quarter_city_first = false,
		ib_one_quarter_city_second = false
	);
}

//tile_river_turn(true,false, false);
tile_river_turn(false,true, true);

//A grass tile with a road going straight through
module tile_river_turn
(
	ib_road_turn = false,
	ib_one_quarter_city_first = false,
	ib_one_quarter_city_second = false
)
{
	difference()
	{
		union()
		{
			//Instance a gridfinity base tile
			grid_block
			(
				num_x				= 1,
				num_y 				= 1,
				num_z 				= 0.5,
				magnet_diameter		= 0,
				screw_depth			= 0
			);
			//Instance fractal terrain
			translate([0,0,gz_gridfinity_socket_offset])
			river_turn
			(
				in_max_levels			= 5,
				in_width 				= gw_gridfinity,
				iz_min_surface_height 	= gz_grass_base,
				iz_max_surface_height 	= gz_grass_river_height,
				iz_random 				= gz_grass_river_roughness,
				iz_river_level 			= gz_water_top_height,
				ir_corner_rounding 		= gr_corner_terrain_rounding,
				in_erosion				= 1
			);
			//Instance first city quarter
			if (ib_one_quarter_city_first == true)
			{
				quarter_city_block();
			}
			//Instance second city quarter
			if (ib_one_quarter_city_second == true)
			{
				quarter_city_block(270);
			}
			if (ib_road_turn == true)
			{
				
				//on top create a weavy road
				translate([0,0,gz_road_top_height-gz_road_height])
				rotate([0,0,180])
				bar_curved_weavy_indented_slanted
				(
					in_r = gw_gridfinity/2,
					in_w = gw_road_width,
					in_z = gz_road_height+gz_bridge_hump,
					//It cuts diagonally both sides to make a ramp
					ir_slant = gz_bridge_hump,
					in_w_amplitude=1/30,
					iw_indent = 1.5,
					iz_indent = 1,
					in_frequency=2
				);
				
				/*
				//try to do a diagonal bridge
				rotate([0,0,-45])
				translate([0*gw_gridfinity/2,gw_gridfinity/4+gw_road_width/2,gz_road_top_height-gz_bridge_height])
				arch_indented
				(
					//Length of the arch
					il_length = sqrt(2)*gw_gridfinity/2,
					//vertical thickness of the arch
					iz_thickness = gz_bridge_height,
					//width of the arch
					iw_width=gw_road_width,
					//How tall is the hump
					iz_height=gz_bridge_hump
				);
				*/
			}
			
		}
		union()
		{
		}
	}
}
