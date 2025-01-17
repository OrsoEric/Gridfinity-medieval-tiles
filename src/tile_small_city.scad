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

//Etch the github url on the back of the tiles
include <url.scad>

//------------------------------------------------------------------------------
//	GRASS TILE + CHURCH + STRAIGHT ROAD OPTION
//------------------------------------------------------------------------------

//tile_grass_city_quarter(0);
//tile_grass_city_quarter(90);
//tile_grass_city_quarter(180);

//A grass tile with a road going straight through
module tile_grass_city_quarter
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
		//Difference
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.0 *gw_gridfinity_half_pitch,
				in_y = +0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//GRASS FIELD
			pin
			(
				in_x = +0.0 *gw_gridfinity_half_pitch,
				in_y = +0.0 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//WEST CITY
			if (ir_second_block==90)
			{
				pin
				(
					in_x = -0.8 *gw_gridfinity_half_pitch,
					in_y = +0.0 *gw_gridfinity_half_pitch,
					in_z_top = gz_wall_top_height+2,
					in_z_drill = 12
				);
			}
			//SOUTH CITY
			if (ir_second_block==180)
			{
				pin
				(
					in_x = +0.0 *gw_gridfinity_half_pitch,
					in_y = -0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_wall_top_height+2,
					in_z_drill = 12
				);
			}
			//ROAD PIN
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
			//Etch the URL to the repo on the back of the tiles
			translate([-0.7*gw_gridfinity/2,-0.0*gw_gridfinity/2,+0.5])
			rotate([180,0,0])
			project_url(in_size = 3,iz_height = 0.5);
		} //Difference
	}
}

//------------------------------------------------------------------------------
//	ROAD
//------------------------------------------------------------------------------

//tile_grass_quarter_city_one_road();

module tile_grass_quarter_city_one_road(iz_road_height = 9, iz_road_top_height = 14)
{
	difference()
	{
		union()
		{
			tile_grass_city_quarter();	
			translate([0,-5,iz_road_top_height-iz_road_height])
			rotate([0,0,90])
			bar_sin_indented
			(
				in_l = 41-10,
				in_w = 7,
				in_z = iz_road_height,
				in_w_amplitude = 2,
				iw_indent = 1.5,
				iz_indent = 1,
				in_frequency=1
			);
		}
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//ROAD
			pin
			(
				in_x = +0.05 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//GRASS EAST
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.0 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS WEST
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = +0.0 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

//tile_grass_quarter_city_two_road_straight();

module tile_grass_quarter_city_two_road_straight(iz_road_height = 9, iz_road_top_height = 14)
{
	difference()
	{
		union()
		{
			tile_grass_city_quarter();	
			translate([0,0,iz_road_top_height-iz_road_height])
			bar_sin_indented
			(
				in_l = 41,
				in_w = 7,
				in_z = iz_road_height,
				in_w_amplitude = 2,
				iw_indent = 1.5,
				iz_indent = 1,
				in_frequency=1
			);
		}
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//ROAD
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.05 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//GRASS NORTH
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = +0.35 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS WEST
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

//tile_grass_quarter_city_two_road_turn_left();

module tile_grass_quarter_city_two_road_turn_left(iz_road_height = 9, iz_road_top_height = 14)
{
	difference()
	{
		union()
		{
			tile_grass_city_quarter();	
			translate([0,0,iz_road_top_height-iz_road_height])
			bar_curved_weavy_indented
			(
				in_r=20.5,
				in_z=iz_road_height
			);
		}
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//ROAD
			pin
			(
				in_x = +0.0 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//GRASS EAST
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

//tile_grass_quarter_city_two_road_turn_right();

module tile_grass_quarter_city_two_road_turn_right(iz_road_height = 9, iz_road_top_height = 14)
{
	difference()
	{
		union()
		{
			tile_grass_city_quarter();	
			translate([0,0,iz_road_top_height-iz_road_height])
			rotate([0,0,90])
			bar_curved_weavy_indented
			(
				in_r=20.5,
				in_z=iz_road_height
			);
		}
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//ROAD
			pin
			(
				in_x = +0.05 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//GRASS SOUTH WEST
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

//tile_grass_quarter_city_three_roads();

module tile_grass_quarter_city_three_roads(iz_road_height = 9, iz_road_top_height = 14)
{
	n_w_road_width = 7;
	n_z_road_indent = 1;
	difference()
	{
		union()
		{
			tile_grass_city_quarter(0);	
			//Crerate two weavy roads
			translate([0,0,iz_road_top_height-iz_road_height])
			bar_sin(41, n_w_road_width,iz_road_height, 1, 2);
			rotate([0,0,90])
			translate([-41/4,0,iz_road_top_height-iz_road_height])
			bar_sin(41/2, n_w_road_width,iz_road_height, 1, 1);
		}
		union()
		{
			//Subtract the indent from the whole
			translate([0,0,iz_road_top_height-n_z_road_indent])
			bar_sin(41, n_w_road_width-1.5, n_z_road_indent, 1, 2);
			rotate([0,0,90])
			translate([-41/4,0,iz_road_top_height-n_z_road_indent])
			bar_sin(41/2, n_w_road_width-1.5, n_z_road_indent, 1, 1);
			
			//NORTH CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//ROAD SOUTH
			pin
			(
				in_x = +0.05 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//ROAD EAST
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = -0.05 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//ROAD WEST
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = +0.05 *gw_gridfinity_half_pitch,
				in_z_top = gz_road_top_height,
				in_z_drill = 10
			);
			//GRASS NORTH
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = +0.4 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS SOUTH WEST
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS SOUTH EAST
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}

module grid_of_tiles_no_road
(
	in_rows = 1,
	in_cols = 1,
	spacing = 42,
	in_one_city_quarter = 5,
	in_two_city_quarters_adjacent = 3,
	in_two_city_quarters_opposite = 3
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * spacing, y * spacing, 0])
		if(n < in_one_city_quarter)
		{	
			tile_grass_city_quarter();
		}
		else if(n < in_one_city_quarter +in_two_city_quarters_adjacent)
		{
			tile_grass_city_quarter(90);
		}
		else if(n < in_one_city_quarter +in_two_city_quarters_adjacent+in_two_city_quarters_opposite)
		{
			tile_grass_city_quarter(180);


		}
			
    }
}

module grid_of_tiles_road
(
	in_rows = 1,
	in_cols = 1,
	spacing = 42,
	in_city_quarter_one_roads = 3,
	in_city_quarter_two_roads_straight = 3,
	in_city_quarter_two_roads_turn_left = 3,
	in_city_quarter_two_roads_turn_right = 3,
	in_city_quarter_three_roads = 3,
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * spacing, y * spacing, 0])
		if(n < in_city_quarter_two_roads_straight)
		{
			tile_grass_quarter_city_one_road();
		}
		else if(n < in_city_quarter_one_roads+ in_city_quarter_two_roads_straight)
		{	
			tile_grass_quarter_city_two_road_straight();
		}
		else if(n < in_city_quarter_one_roads+ in_city_quarter_two_roads_straight+in_city_quarter_two_roads_turn_left)
		{	
			tile_grass_quarter_city_two_road_turn_left();
		}	
		else if(n < in_city_quarter_one_roads+ in_city_quarter_two_roads_straight+in_city_quarter_two_roads_turn_left+in_city_quarter_two_roads_turn_right)
		{	
			tile_grass_quarter_city_two_road_turn_right();
		}	
		else if(n < in_city_quarter_one_roads+ in_city_quarter_two_roads_straight+in_city_quarter_two_roads_turn_left+in_city_quarter_two_roads_turn_right+in_city_quarter_three_roads)
		{	
			tile_grass_quarter_city_three_roads();
		}			
    }
}


module grid_of_tiles
(
	in_rows = 1,
	in_cols = 1,
	spacing = 42,
	in_one_city_quarter = 4,
	in_two_city_quarters_adjacent = 3,
	in_two_city_quarters_opposite = 3,
	in_city_quarter_one_roads = 3,
	in_city_quarter_two_roads_straight = 3,
	in_city_quarter_two_roads_turn_left = 3,
	in_city_quarter_two_roads_turn_right = 3,
	in_city_quarter_three_roads = 3,
	dummy
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * spacing, y * spacing, 0])
		if(n < in_one_city_quarter)
		{	
			tile_grass_city_quarter();
		}
		else if(n < in_one_city_quarter +in_two_city_quarters_adjacent)
		{
			tile_grass_city_quarter(90);
		}
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite
		)
		{
			tile_grass_city_quarter(180);
		}
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite+
			in_city_quarter_one_roads
		)
		{
			tile_grass_quarter_city_one_road();
		}
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite+
			in_city_quarter_one_roads+
			in_city_quarter_two_roads_straight
		)
		{	
			tile_grass_quarter_city_two_road_straight();
		}
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite+
			in_city_quarter_one_roads+
			in_city_quarter_two_roads_straight+
			in_city_quarter_two_roads_turn_left
		)
		{	
			tile_grass_quarter_city_two_road_turn_left();
		}	
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite+
			in_city_quarter_one_roads+
			in_city_quarter_two_roads_straight+
			in_city_quarter_two_roads_turn_left+
			in_city_quarter_two_roads_turn_right
		)
		{	
			tile_grass_quarter_city_two_road_turn_right();
		}	
		else if
		(
			n <
			in_one_city_quarter+
			in_two_city_quarters_adjacent+
			in_two_city_quarters_opposite+
			in_city_quarter_one_roads+
			in_city_quarter_two_roads_straight+
			in_city_quarter_two_roads_turn_left+
			in_city_quarter_two_roads_turn_right+
			in_city_quarter_three_roads
		)
		{	
			tile_grass_quarter_city_three_roads();
		}			
			
    }
}

//grid_of_tiles_no_road(4,4);

//grid_of_tiles_road(4,4);

grid_of_tiles(5,5);