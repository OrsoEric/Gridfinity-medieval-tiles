//This tile is the most complex
//it creates a combination of city sides and road sides
//With optional buildings

//Handles 2/4 3/4 4/4 cities

//FEAT1: Walls

include <gridfinity_modules.scad>

//Tile Constants
include <tile_constants.scad>

//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

//Define the weavy bars I use as roads
include <road.scad>

//Buildings definitions
include <building.scad>

gz_terrain_translate_up = 8;
gz_terrain_offset = 1;
gz_terrain_roughness = 3;

//---------------------------------------------------------------------------
//	CITY 2/4 BLOCK ADJACENT
//---------------------------------------------------------------------------

//two_quarter_city_block();

module two_quarter_city_block
(
	in_z_wall_height = 16,
	in_z_wall_top_height=22,
	iz_plaza_top_height = 18,
	iz_short_tower_above_wall=10,
	iz_tall_tower_above_wall=24,
	//true= will spawn the lord's building with heraldry
	ib_herald = false,
)
{
	n_gridfinity = gw_gridfinity;

	//WALL PARAMETERS

	nw_wall_width = 4;

	//TOWER PARAMETERS
	n_z_short_tower = in_z_wall_height +iz_short_tower_above_wall;
	n_z_tall_tower = in_z_wall_height +iz_tall_tower_above_wall;

	//COMPUTE POINTS

	n_corner = n_gridfinity/2-2.2;
	n_edge = 10;

	start_l = [ -n_corner, -n_corner];
	end_l = [ -n_edge, -n_edge];
		
	echo("Left Points: ", start_l, end_l);

	start_r = [ +n_corner, +n_corner];
	end_r = [ +n_edge, +n_edge];

	echo("Right Points ", start_r, end_r);

	corner_c = [ +n_corner, -n_corner];
	
	//I want three wall chunks and two towers

	//LEFT BOTTOM TOWER
	translate([start_l[0],start_l[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//LEFT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_l,
		end_l,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);


	//LEFT TOP TOWER
	translate([end_l[0],end_l[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	//FRONT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		end_l,
		end_r,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height+2,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT TOP TOWER
	translate([end_r[0],end_r[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_r,
		end_r,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT BOTTOM TOWER
	translate([start_r[0],start_r[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//EDGE TOWER
	translate([n_gridfinity/2-3.4,-(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//CITY PLAZA
	lp_city_area = 
	[
		//lower wall diagonal on lower tower wall
		[-n_corner, -n_gridfinity/2],
		//Upper wall diagonal on upper tower right wall
		[+n_gridfinity/2, +n_corner],
		//run along the right gridfinity boundary
		[+n_gridfinity/2, -n_corner],
		//run along the lower gridfinity boundary avoiding the curved edge
		[+n_corner, -n_gridfinity/2]
	];

	//Platform where the buildings are spawned
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	city
	(
		lp_city_area,
		iz_plaza_height = iz_plaza_top_height-in_z_wall_top_height+in_z_wall_height,
		in_num_houses_small = 80,
		in_num_houses_medium = 10,
		in_num_towers = 7
	);

	//HERALD
	if (ib_herald==true)
	{
		//Compute center. TODO: figure out how to compute center. 
		x_avg = (lp_city_area[0][0] +lp_city_area[1][0] +lp_city_area[2][0] +lp_city_area[3][0])/4;
		y_avg = (lp_city_area[0][1] +lp_city_area[1][1] +lp_city_area[2][1] +lp_city_area[3][1])/4;
		//Instance of an herald
		translate([x_avg,y_avg, iz_plaza_top_height])
		rotate([0,0,45])
		herald(9,6,7);	
	}

}

//---------------------------------------------------------------------------
//	CITY BLOCK 2/4 OPPOSITE
//---------------------------------------------------------------------------
// This is a long boi
// A city lengthwise with two grasses flanking it

module two_quarter_city_block_opposite
(
	in_z_wall_height = 16,
	in_z_wall_top_height=22,
	iz_plaza_top_height = 18,
	iz_short_tower_above_wall=10,
	iz_tall_tower_above_wall=24,
	//true= will spawn the lord's building with heraldry
	ib_herald = false,
)
{
	n_gridfinity = gw_gridfinity;

	//WALL PARAMETERS

	nw_wall_width = 4;

	//TOWER PARAMETERS
	n_z_short_tower = in_z_wall_height +iz_short_tower_above_wall;
	n_z_tall_tower = in_z_wall_height +iz_tall_tower_above_wall;

	//COMPUTE POINTS

	n_corner = n_gridfinity/2-2.2;
	n_edge = 10;

	//TOP RETAINING WALL
	start_tl = [ -n_corner, +n_corner];
	end_tl = [ -n_edge, +n_edge];
	end_tr = [ +n_edge, +n_edge];
	start_tr = [ +n_corner, +n_corner];
	
	//I want three wall chunks and two towers

	//LEFT BOTTOM TOWER
	translate([start_tl[0],start_tl[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//LEFT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_tl,
		end_tl,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//LEFT TOP TOWER
	translate([end_tl[0],end_tl[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	//FRONT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		end_tl,
		end_tr,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height+2,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT TOP TOWER
	translate([end_tr[0],end_tr[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_tr,
		end_tr,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT BOTTOM TOWER
	translate([start_tr[0],start_tr[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//BOTTOM WALLS

	start_bl = [ -n_corner, -n_corner];
	end_bl = [ -n_edge, -n_edge];
	end_br = [ +n_edge, -n_edge];
	start_br = [ +n_corner, -n_corner];
	
	//I want three wall chunks and two towers

	//LEFT BOTTOM TOWER
	translate([start_bl[0],start_bl[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//LEFT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_bl,
		end_bl,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//LEFT TOP TOWER
	translate([end_bl[0],end_bl[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	//FRONT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		end_bl,
		end_br,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height+2,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT TOP TOWER
	translate([end_br[0],end_br[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_br,
		end_br,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT BOTTOM TOWER
	translate([start_br[0],start_br[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	
	//CITY PLAZA
	lp_city_area = 
	[
		//moved to the left edge of the tower
		//start_tl
		[-n_gridfinity/2, +n_corner],
		end_tl,
		end_tr,
		//moved to the right edge of the tower
		//start_tr,
		[+n_gridfinity/2, +n_corner],
		//moved to the right edge of the tower
		//start_br,
		[+n_gridfinity/2, -n_corner],
		end_br,
		end_bl,
		//moved to the left edge of the tower
		//start_bl
		[-n_gridfinity/2, -n_corner],
	];

	//Platform where the buildings are spawned
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	city
	(
		lp_city_area,
		iz_plaza_height = iz_plaza_top_height-in_z_wall_top_height+in_z_wall_height,
		in_num_houses_small = 120,
		in_num_houses_medium = 20,
		in_num_towers = 15
	);
	
	//HERALD
	if (ib_herald==true)
	{
		//Instance of an herald
		translate([0,0, iz_plaza_top_height])
		rotate([0,0,90])
		herald(9,6,7);	
	}

}

//---------------------------------------------------------------------------
//	CITY BLOCK 3/4
//---------------------------------------------------------------------------

//three_quarter_city_block(ib_herald=true);

module three_quarter_city_block
(
	ir_orientation = 0,
	in_z_wall_height = 16,
	in_z_wall_top_height=22,
	iz_plaza_top_height = 18,
	iz_short_tower_above_wall=10,
	iz_tall_tower_above_wall=20,
	ib_herald = false,
)
{
	n_gridfinity = gw_gridfinity;

	//WALL PARAMETERS

	nw_wall_width = 4;

	//TOWER PARAMETERS
	n_z_short_tower = in_z_wall_height +iz_short_tower_above_wall;
	n_z_tall_tower = in_z_wall_height +iz_tall_tower_above_wall;

	//COMPUTE POINTS

	n_corner = n_gridfinity/2-2.2;
	n_edge = 10;

	start_l = [ -n_corner, +n_corner];
	end_l = [ -n_edge, +n_edge];
	end_r = [ +n_edge, +n_edge];
	start_r = [ +n_corner, +n_corner];
	
	//I want three wall chunks and two towers

	//LEFT BOTTOM TOWER
	translate([start_l[0],start_l[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);

	//LEFT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_l,
		end_l,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//LEFT TOP TOWER
	translate([end_l[0],end_l[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	//FRONT WALL
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		end_l,
		end_r,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT TOP TOWER
	translate([end_r[0],end_r[1],in_z_wall_top_height-in_z_wall_height])
	round_tower(ir_stalk = 2, ir_top = 3, iz_height = n_z_tall_tower);

	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	wall_with_indent
	(
		start_r,
		end_r,
		in_w=nw_wall_width,
		in_z_height=in_z_wall_height,
		in_w_indent = 1.5,
		in_z_indent=2
	);

	//RIGHT BOTTOM TOWER
	translate([start_r[0],start_r[1],in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 2,
		ir_top = 2.5,
		iz_height = n_z_short_tower,
		in_stalk_ratio = 5/7,
		in_roof_ratio = 1/7
	);


	//EDGE TOWER (cleverly rounds the corner
	translate([n_gridfinity/2-3.4,-(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//EDGE TOWER (cleverly rounds the corner
	translate([-n_gridfinity/2+3.4,-(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//CITY PLAZA
	//Platform where the buildings are spawned
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	city
	(
		[
			//BOT LEFT
			[-n_corner, -n_gridfinity/2],
			[-n_gridfinity/2, -n_corner],
			//TOP LEFT
			//start_l,
			[-n_gridfinity/2, +n_corner],
			end_l,
			end_r,
			//TOP RIGHT
			//start_r
			[+n_gridfinity/2, +n_corner],
			//BOT RIGHT
			[+n_gridfinity/2, -n_corner],
			[+n_corner, -n_gridfinity/2]
			
		],
		iz_plaza_height = iz_plaza_top_height-in_z_wall_top_height+in_z_wall_height,
		in_num_houses_small = 120,
		in_num_houses_medium = 20,
		in_num_towers = 15
	);
	
	//HERALD
	if (ib_herald==true)
	{
		//Instance of an herald
		translate([0,0, iz_plaza_top_height])
		rotate([0,0,180])
		herald(9,6,7);	
	}
}


//---------------------------------------------------------------------------
//	CITY BLOCK 4/4
//---------------------------------------------------------------------------
//	This is a full city block
//	I have no retaining walls
//	I should put a cathedral here, it's fitting
//	I place four edge towers

//four_quarter_city_block(ib_herald=true);

module four_quarter_city_block
(
	ir_orientation = 0,
	in_z_wall_height = 16,
	in_z_wall_top_height=22,
	iz_plaza_top_height = 18,
	iz_short_tower_above_wall=10,
	iz_tall_tower_above_wall=20,
	ib_herald = false
)
{
	n_gridfinity = gw_gridfinity;

	//WALL PARAMETERS

	nw_wall_width = 4;

	//TOWER PARAMETERS
	n_z_short_tower = in_z_wall_height +iz_short_tower_above_wall;
	n_z_tall_tower = in_z_wall_height +iz_tall_tower_above_wall;

	//COMPUTE POINTS

	n_corner = n_gridfinity/2-2.2;

	//EDGE TOWER TOP RIGHT
	translate([(n_gridfinity/2-3.4),+(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//EDGE TOWER TOP LEFT
	translate([-(n_gridfinity/2-3.4),+(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//EDGE TOWER BOTTOM RIGHT
	translate([(n_gridfinity/2-3.4),-(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//EDGE TOWER BOTTOM LEFT
	translate([-(n_gridfinity/2-3.4),-(n_gridfinity/2-3.4),in_z_wall_top_height-in_z_wall_height])
	round_tower
	(
		ir_stalk = 3.5,
		ir_top = 3.5,
		iz_height = in_z_wall_height+2,
		in_stalk_ratio = 1/7,
		in_roof_ratio = 1/7
	);

	//CHURCH
	translate([0,0,iz_plaza_top_height])
	church
	(
		in_lenght=25,
		in_width=18,
		in_height=30,
		in_width_building = 6,
		in_z_ratio_tower = 2/6
	);


	//CITY PLAZA
	//Platform where the buildings are spawned
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	city
	(
		[
			//BOT LEFT
			[-n_corner, -n_gridfinity/2],
			[-n_gridfinity/2, -n_corner],
			//TOP LEFT
			[-n_gridfinity/2, +n_corner],
			[-n_corner, +n_gridfinity/2],
			//TOP RIGHT
			[+n_corner, +n_gridfinity/2],
			[+n_gridfinity/2, +n_corner],
			//BOT RIGHT
			[+n_gridfinity/2, -n_corner],
			[+n_corner, -n_gridfinity/2]
			
		],
		iz_plaza_height = iz_plaza_top_height-in_z_wall_top_height+in_z_wall_height,
		in_num_houses_small = 120,
		in_num_houses_medium = 20,
		in_num_towers = 15
	);
	
	//HERALD
	if (ib_herald==true)
	{
		//Instance of an herald
		translate([0.8*n_corner,0, iz_plaza_top_height])
		rotate([0,0,0])
		herald(9,6,7);	
	}
}

//---------------------------------------------------------------------------
//	TILE CITY 2/4
//---------------------------------------------------------------------------

//tile_grass_two_quarter_city();

//tile_grass_two_quarter_city(ib_herald = true);

//tile_grass_two_quarter_city(ib_herald = false, ib_road_turn = true);

//tile_grass_two_quarter_city(ib_herald = true, ib_road_turn = true);

//A grass tile with a road going straight through
module tile_grass_two_quarter_city
(
	ib_herald = false,
	ib_road_turn = false
)
{
	n_z_wall_top_height = 20;
	n_z_city_top_height = 16;
	n_z_wall_height = 15;

	difference()
	{
		union()
		{
			//Create a grifinity tile
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
			
			two_quarter_city_block
			(
				in_z_wall_height = n_z_wall_height,
				in_z_wall_top_height = n_z_wall_top_height,
				iz_plaza_top_height = n_z_city_top_height,
				ib_herald = ib_herald
			);
			
			if (ib_road_turn == true)
			{
				translate([0,0,gz_road_top_height-gz_road_height])
				rotate([0,0,-90])
				bar_curved_weavy_indented
				(
					in_r=gw_gridfinity_half_pitch,
					in_z=gz_road_height
				);

	
			}

		}
		//Difference
		union()
		{
			//NORTH CITY
			pin
			(
				in_x = +0.3 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//GRASS NORTH WEST
			pin
			(
				in_x = -0.8 *gw_gridfinity_half_pitch,
				in_y = +0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//There are additional pins if a road cut the field
			if (ib_road_turn == true)
			{
				//GRASS MIDDLE
				pin
				(
					in_x = -0.8 *gw_gridfinity_half_pitch,
					in_y = -0.4 *gw_gridfinity_half_pitch,
					in_z_top = gz_grass_top_height,
					in_z_drill = 8
				);
				//ROAD
				pin
				(
					in_x = -0.05 *gw_gridfinity_half_pitch,
					in_y = +0.8 *gw_gridfinity_half_pitch,
					in_z_top = gz_road_top_height,
					in_z_drill = 10
				);
			}
		} //Difference
	}
}

//---------------------------------------------------------------------------
//	TILE CITY 2/4 OPPOSITE
//---------------------------------------------------------------------------


//tile_grass_two_quarter_city_opposite();

//tile_grass_two_quarter_city_opposite(ib_herald = true);

//A grass tile with a road going straight through
module tile_grass_two_quarter_city_opposite
(
	ib_herald = false
)
{
	n_z_wall_top_height = 20;
	n_z_city_top_height = 16;
	n_z_wall_height = 15;

	difference()
	{
		union()
		{
			//Create a grifinity tile
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
			
			two_quarter_city_block_opposite
			(
				in_z_wall_height = n_z_wall_height,
				in_z_wall_top_height = n_z_wall_top_height,
				iz_plaza_top_height = n_z_city_top_height,
				ib_herald = ib_herald
			);

		}
		union()
		{
			//CITY
			pin
			(
				in_x = +0.8 *gw_gridfinity_half_pitch,
				in_y = +0.0 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//GRASS NORTH
			pin
			(
				in_x = -0.0 *gw_gridfinity_half_pitch,
				in_y = +0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS SOUTH
			pin
			(
				in_x = -0.0 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);

			
		}
	}
}

//---------------------------------------------------------------------------
//	TILE CITY 3/4
//---------------------------------------------------------------------------

tile_grass_three_quarter_city_road(ib_herald=true,ib_road=true);

//A grass tile with a road going straight through
module tile_grass_three_quarter_city_road
(
	ib_road = false,
	ib_herald = false,
	iz_road_height = 9,
	iz_road_top_height = 14
)
{	
	n_z_wall_top_height = 20;
	n_z_city_top_height = 16;
	n_z_wall_height = 15;

	difference()
	{
		union()
		{
			//Create a grifinity tile
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
			
			three_quarter_city_block
			(
				in_z_wall_height = n_z_wall_height,
				in_z_wall_top_height = n_z_wall_top_height,
				iz_plaza_top_height = n_z_city_top_height,
				ib_herald = ib_herald
			);
			if (ib_road == true)
			{
				translate([0,20.5-5,iz_road_top_height-iz_road_height])
				rotate([0,0,-90])
				bar_sin_indented
				(
					in_l = 10,
					in_w = 7,
					in_z = iz_road_height,
					in_w_amplitude = 0,
					iw_indent = 1.5,
					iz_indent = 1,
					in_frequency=0
				);
			}
		}
		union()
		{
			//CITY
			pin
			(
				in_x = +0.0 *gw_gridfinity_half_pitch,
				in_y = -0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_wall_top_height+2,
				in_z_drill = 12
			);
			//GRASS NORTH NORTH EAST
			pin
			(
				in_x = +0.4 *gw_gridfinity_half_pitch,
				in_y = +0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
			//GRASS NORTH NORTH WEST
			pin
			(
				in_x = -0.4 *gw_gridfinity_half_pitch,
				in_y = +0.8 *gw_gridfinity_half_pitch,
				in_z_top = gz_grass_top_height,
				in_z_drill = 8
			);
		}
	}
}


//---------------------------------------------------------------------------
//	TILE CITY 4/4
//---------------------------------------------------------------------------

//tile_grass_four_quarter_city(ib_herald=true);

module tile_grass_four_quarter_city
(
	ib_herald = false
)
{
	n_z_wall_top_height = 20;
	n_z_city_top_height = 16;
	n_z_wall_height = 15;

	difference()
	{
		union()
		{
			//Create a grifinity tile
			grid_block
			(
				num_x=1,
				num_y=1,
				num_z=0.5,
				magnet_diameter=0,
				screw_depth=0
			);
			//On top, create a fractal terrain
			translate([0,0,gz_terrain_translate_up])
			terrain
			(
				in_max_levels = 5,
				in_width = 41,
				in_z_delta = gz_terrain_roughness,
				in_z_offset = gz_terrain_offset,
				in_erosion=0
			);
			
			four_quarter_city_block
			(
				in_z_wall_height = n_z_wall_height,
				in_z_wall_top_height = n_z_wall_top_height,
				iz_plaza_top_height = n_z_city_top_height,
				ib_herald = ib_herald
			);

		}
		union()
		{
			//Drill the city block
			pin(-0.8, -0.0,in_z_top = n_z_wall_top_height+4, in_z_drill = 14);
		}
	}
}

//---------------------------------------------------------------------------
//	GENERATE PRINTABLE GRID WITH A MIX OF TILES
//---------------------------------------------------------------------------

module grid_of_tiles_big_city
(
	in_rows = 1,
	in_cols = 1,
	spacing = 42,
	//Two Quarter City with NO Herald
	in_two_quarter_city = 3,
	in_two_quarter_city_with_herald = 2,
	in_two_quarter_city_with_road_turn = 3,
	in_two_quarter_city_with_road_turn_with_herald = 2,
	in_two_quarter_city_opposite = 2,
	in_two_quarter_city_opposite_with_herald = 2,
	// 3/4
	in_three_quarter_city = 3,
	in_three_quarter_city_with_herald = 2,
	in_three_quarter_city_with_road = 2,
	in_three_quarter_city_with_road_and_herald = 2,
	// 4/4
	in_four_quarter_city = 1,
	in_four_quarter_city_with_herald = 1
)
{
    for (x = [0:in_cols-1])
    for (y = [0:in_rows-1])
    {
		n=x*in_cols+y;
		echo("X Y N: ", x, y, n);
		translate([x * spacing, y * spacing, 0])
		if(n < in_two_quarter_city)
		{	
			tile_grass_two_quarter_city(ib_herald=false);
		}
		else if(n < in_two_quarter_city +in_two_quarter_city_with_herald)
		{
			tile_grass_two_quarter_city(ib_herald=true);
		}
		else if(n < in_two_quarter_city +in_two_quarter_city_with_herald+in_two_quarter_city_with_road_turn)
		{
			tile_grass_two_quarter_city_with_road_turn(ib_herald=false);
		}
		else if(n < in_two_quarter_city +in_two_quarter_city_with_herald+in_two_quarter_city_with_road_turn+in_two_quarter_city_with_road_turn_with_herald)
		{
			tile_grass_two_quarter_city_with_road_turn(ib_herald=true);
		}	
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite
		)
		{
			tile_grass_two_quarter_city_opposite(ib_herald=false);
		}	
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald
		)
		{
			tile_grass_two_quarter_city_opposite(ib_herald=true);
		}	
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city
		)
		{
			tile_grass_three_quarter_city_road(ib_herald=false, ib_road=false);
		}
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city +
			in_three_quarter_city_with_herald
		)
		{
			tile_grass_three_quarter_city_road(ib_herald=true, ib_road=false);
		}
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city +
			in_three_quarter_city_with_herald +
			in_three_quarter_city_with_road
		)
		{
			tile_grass_three_quarter_city_road(ib_herald=false, ib_road=true);
		}
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city +
			in_three_quarter_city_with_herald +
			in_three_quarter_city_with_road +
			in_three_quarter_city_with_road_and_herald
		)
		{
			tile_grass_three_quarter_city_road(ib_herald=true, ib_road=true);
		}
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city +
			in_three_quarter_city_with_herald +
			in_three_quarter_city_with_road +
			in_three_quarter_city_with_road_and_herald +
			in_four_quarter_city
		)
		{
			tile_grass_four_quarter_city(ib_herald=true);
		}
		else if
		(
			n <
			in_two_quarter_city+
			in_two_quarter_city_with_herald+
			in_two_quarter_city_with_road_turn+
			in_two_quarter_city_with_road_turn_with_herald+
			in_two_quarter_city_opposite+
			in_two_quarter_city_opposite_with_herald+
			in_three_quarter_city +
			in_three_quarter_city_with_herald +
			in_three_quarter_city_with_road +
			in_three_quarter_city_with_road_and_herald +
			in_four_quarter_city +
			in_four_quarter_city_with_herald
		)
		{
			tile_grass_four_quarter_city(ib_herald=true);
		}

		else
		{
			//PLACE NOTHING
		}

    }
}

//two_quarter_city_block();

//tile_grass_two_quarter_city(ib_herald=true);

//tile_grass_two_quarter_city_with_road_turn();

//two_quarter_city_block_opposite();

//tile_grass_two_quarter_city_opposite(true);

//grid_of_tiles_big_city(5,5);
