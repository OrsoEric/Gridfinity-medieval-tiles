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


tile_river();

//A grass tile with a road going straight through
module tile_river
(
	ir_second_block = 0,
	ib_road = true
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
			
			quarter_city_block();

			if (ir_second_block!=0)
			{
				quarter_city_block(ir_second_block);
			}

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
		}
	}
}


