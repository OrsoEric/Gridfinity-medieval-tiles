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

//tile_river_straight(true,true,true);
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
				in_length 				= gw_gridfinity,
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
				//use two pins to support the bridge
				pin
				(
					in_x = +0.09 *gw_gridfinity_half_pitch,
					in_y = -0.19 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
				pin
				(
					in_x = -0.09 *gw_gridfinity_half_pitch,
					in_y = -0.19 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
				pin
				(
					in_x = -0.09 *gw_gridfinity_half_pitch,
					in_y = +0.19 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
				pin
				(
					in_x = +0.09 *gw_gridfinity_half_pitch,
					in_y = +0.19 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);

			}

			

		}
		union()
		{
			//NORTH WEST GRASS PIN
			pin
			(
				in_x = -0.85 *gw_gridfinity_half_pitch,
				in_y = +0.45 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_river_top_height,
				in_z_drill = 9
			);
			//SOUTH EAST GRASS PIN
			pin
			(
				in_x = +0.85 *gw_gridfinity_half_pitch,
				in_y = -0.45 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_river_top_height,
				in_z_drill = 9
			);
			///BRIDGE PIN
			//If I have a bridge and no second city
			if ((ib_bridge == true) && (ib_one_quarter_city_second==false))
			{
				//bridge pin
				pin
				(
					in_x = +0.0 *gw_gridfinity_half_pitch,
					in_y = -0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height+gz_bridge_height,
					in_z_drill = 10+gz_bridge_height
				);
			}
			///FIRST CITY PIN
			//If I have the first city, place a pin on it and a pin on it's grass
			if (ib_one_quarter_city_first==true)
			{
				//City Pin
				pin
				(
					in_x = +0.2 *gw_gridfinity_half_pitch,
					in_y = +0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_wall_top_height+2,
					in_z_drill = 12
				);
			}	
			///SECOND CITY PIN
			//If I have the first city, place a pin on it and a pin on it's grass
			if (ib_one_quarter_city_second==true)
			{
				//City Pin
				pin
				(
					in_x = -0.2 *gw_gridfinity_half_pitch,
					in_y = -0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_wall_top_height+2,
					in_z_drill = 12
				);
			}	
			///NORTH EAST GRASS PIN
			//if I have the bridge or I have the first city
			if ((ib_one_quarter_city_first==true) || (ib_bridge == true))
			{
				pin
				(
					in_x = +0.85 *gw_gridfinity_half_pitch,
					in_y = +0.45 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			}

			//SOUTH WEST GRASS PIN
			//if I have the bridge or I have the second city
			if ((ib_one_quarter_city_second==true) || (ib_bridge == true))
			{
				pin
				(
					in_x = -0.85 *gw_gridfinity_half_pitch,
					in_y = -0.45 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			}

		}
	}
}

//------------------------------------------------------------------------------
//	RIVER TILE TURN + OPTION BRIDGE + OPTION 2X ONE QUARTER CITY
//------------------------------------------------------------------------------

//vanilla
//tile_river_turn(false,false, false);

//road
//tile_river_turn(true,false, false);

//First City
//tile_river_turn(false,true, false);

//Second City
//tile_river_turn(false,false,true);

//First and second city
//tile_river_turn(false,true, true);

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
			}
		}
		union()
		{
			//SOUTH WEST GRASS PIN			
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_river_top_height,
				in_z_drill = 9
			);

			//If I don't have the second city
			if (ib_one_quarter_city_second == false)
			{
				//NORTH EAST PIN
				pin
				(
					in_x = +0.8 *gw_gridfinity_half_pitch,
					in_y = +0.5 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			}
			//I need to move the pin a little
			else
			{
				//NORTH EAST PIN
				pin
				(
					in_x = +0.4 *gw_gridfinity_half_pitch,
					in_y = +0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			}


			//If I have the road or the first city
			if ((ib_one_quarter_city_first == true) || (ib_road_turn == true))
			{
				//NORTH WEST PIN
				pin
				(
					in_x = -0.8 *gw_gridfinity_half_pitch,
					in_y = +0.45 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			
			}
			//If I have the road or the second city
			if ((ib_one_quarter_city_second == true) || (ib_road_turn == true))
			{
				//SOUTH EAST PIN
				pin
				(
					in_x = +0.45 *gw_gridfinity_half_pitch,
					in_y = -0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_river_top_height,
					in_z_drill = 9
				);
			
			}
		}
	}
}

//------------------------------------------------------------------------------
//	RIVER SOURCE
//------------------------------------------------------------------------------
// This is a 1x2 tile with a mountain in the middle and two rivers at its side
// It's a source that forks


if (false)
{
	tile_river_source_wide
	(
		ib_bridge = true,
		ib_one_quarter_city_first = true
	);
}

module tile_river_source_wide
(
	ib_bridge=true,
	ib_one_quarter_city_first = true
)
{
	difference()
	{
		union()
		{
			//Instance a gridfinity base tile
			grid_block
			(
				num_x				= 2,
				num_y 				= 1,
				num_z 				= 0.5,
				magnet_diameter		= 0,
				screw_depth			= 0
			);
			//Instance fractal terrain
			translate([gw_gridfinity_spacing/2,0,gz_gridfinity_socket_offset])
			river
			(
				in_max_levels			= 6,
				in_length				= gw_gridfinity_spacing+gw_gridfinity,
				in_width 				= gw_gridfinity,
				iz_min_surface_height 	= gz_grass_base,
				iz_max_surface_height 	= gz_grass_river_height,
				iz_random 				= gz_grass_river_roughness,
				iz_river_level 			= gz_water_top_height,
				ir_corner_rounding 		= gr_corner_terrain_rounding,
				in_erosion				= 1
			);
			translate([gw_gridfinity_spacing/2,0,gz_gridfinity_socket_offset])
			hill
			(
				in_max_levels 			= 5,
				in_width 				= gw_gridfinity*7/8,
				iz_min_surface_height 	= 2,
				iz_max_surface_height 	= 50,
				in_z_random 			= 20,
				in_erosion				= 1,
				in_height_roll 			= 0.9
			);
			//Instance first city quarter
			if (ib_one_quarter_city_first == true)
			{
				quarter_city_block();
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
		}
	}
}

//------------------------------------------------------------------------------
//	RIVER LAKE
//------------------------------------------------------------------------------

if (false)
{
	tile_river_lake
	(
		ib_one_quarter_city_first = true
	);
}

//tile_river_turn(true,false, false);
//tile_river_turn(false,true, true);

//A grass tile with a road going straight through
module tile_river_lake
(
	ib_one_quarter_city_first = false
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
			lake
			(
				in_max_levels			= 5,
				in_length 				= gw_gridfinity,
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
				quarter_city_block(270);
			}
		}
		union()
		{
		}
	}
}


//------------------------------------------------------------------------------
//	GENERATE PRINTABLE GRID
//------------------------------------------------------------------------------


module grid_of_tiles
(
	//Maximum grid size
	in_rows = 1,
	in_cols = 1,
	//Number of tiles to generate in the grid
	in_river_straight = 3,
	in_river_straight_with_bridge = 4,
	in_river_straight_with_single_one_quarter_city = 1,
	in_river_straight_with_bridge_and_single_one_quarter_city = 1,
	in_river_straight_with_double_one_quarter_city = 1,
	in_river_straight_with_bridged_double_one_quarter_city = 1,
	
	in_river_turn = 3,
	in_river_turn_with_road_turn = 4,
	in_river_turn_left_with_single_one_quarter_city = 1,
	in_river_turn_right_with_single_one_quarter_city = 1,
	in_river_turn_with_double_one_quarter_city = 1,

	in_lake = 1,
	in_lake_with_city = 1,

	in_spring = 1,

	dummy
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * gw_gridfinity_spacing, y * gw_gridfinity_spacing, 0])
		if(n < in_river_straight)
		{	
			tile_river_straight(false, false, false);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge
		)
		{
			tile_river_straight(true, false, false);
		}	
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city
		)
		{
			tile_river_straight(false, true, false);
		}	
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city
		)
		{
			tile_river_straight(true, true, false);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city
		)
		{
			tile_river_straight(false, true, true);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city
		)
		{
			tile_river_straight(true, true, true);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn
		)
		{
			tile_river_turn(false, false, false);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn
		)
		{
			tile_river_turn(true, false, false);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city
		)
		{
			tile_river_turn(false, true, false);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city+
			in_river_turn_right_with_single_one_quarter_city
		)
		{
			tile_river_turn(false, false, true);
		}
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city+
			in_river_turn_right_with_single_one_quarter_city+
			in_river_turn_with_double_one_quarter_city
		)
		{
			tile_river_turn(false, true, true);
		}

		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city+
			in_river_turn_right_with_single_one_quarter_city+
			in_river_turn_with_double_one_quarter_city+
			in_lake
		)
		{
			tile_river_lake(false);
		} 
		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city+
			in_river_turn_right_with_single_one_quarter_city+
			in_river_turn_with_double_one_quarter_city+
			in_lake+
			in_lake_with_city
		)
		{
			tile_river_lake(true);
		} 

		else if
		(
			n <
			in_river_straight+
			in_river_straight_with_bridge+
			in_river_straight_with_single_one_quarter_city+
			in_river_straight_with_bridge_and_single_one_quarter_city+
			in_river_straight_with_double_one_quarter_city+
			in_river_straight_with_bridged_double_one_quarter_city+
			in_river_turn+
			in_river_turn_with_road_turn+
			in_river_turn_left_with_single_one_quarter_city+
			in_river_turn_right_with_single_one_quarter_city+
			in_river_turn_with_double_one_quarter_city+
			in_lake+
			in_lake_with_city+
			in_spring
		)
		{
			rotate([0,0,90])
			tile_river_source_wide();
		} 



		else
		{
			//DO NOT SPAWN TILES
		}
	}
}

grid_of_tiles(5,5);
