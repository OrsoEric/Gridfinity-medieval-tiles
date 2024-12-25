//This tile is the most complex
//it creates a combination of city sides and road sides
//With optional buildings

//Handles 2/4 3/4 4/4 cities

//FEAT1: Walls

include <gridfinity_modules.scad>


//Credits to
//https://www.printables.com/@Anachronist
//https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files
include <terrain.scad>

//Define the weavy bars I use as roads
include <road.scad>

//Buildings definitions
include <building.scad>

//---------------------------------------------------------------------------
//	CITY 2/4 ADJACENT
//---------------------------------------------------------------------------

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
	n_gridfinity = 41;

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
//	CITY 2/4 OPPOSITE
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
	n_gridfinity = 41;

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
//	TILE CITY 2/4
//---------------------------------------------------------------------------

//A grass tile with a road going straight through
module tile_grass_two_quarter_city
(
	ib_herald = false
)
{
	//the road reaches up to this height
	n_z_road_top_height = 14;
	//the road digs inside the model by this height
	n_z_road_thickness = 7;
	n_z_road_indent = 1;

	n_w_road_width = 7;
	
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
			translate([0,0,6])
			terrain
			(
				in_max_levels = 5,
				in_width = 41,
				in_z_delta = 6,
				in_z_offset = 1.5,
				in_erosion=0
			);
			
			two_quarter_city_block
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
			pin(+0.3, -0.8,in_z_top = n_z_wall_top_height+4, in_z_drill = 14);
			//Drill the grass
			pin(-0.8, +0.8);
		}
	}
}

//---------------------------------------------------------------------------
//	TILE CITY 2/4 WITH 90° ROAD
//---------------------------------------------------------------------------

//A grass tile with a road going straight through
module tile_grass_two_quarter_city_with_road_turn
(
	ib_herald = false
)
{
	//the road reaches up to this height
	iz_road_top_height = 14;
	iz_road_height = 9;
	//the road digs inside the model by this height
	n_z_road_thickness = 7;
	n_z_road_indent = 1;

	n_w_road_width = 7;
	
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
			translate([0,0,6])
			terrain
			(
				in_max_levels = 5,
				in_width = 41,
				in_z_delta = 6,
				in_z_offset = 1.5,
				in_erosion=0
			);
			
			two_quarter_city_block
			(
				in_z_wall_height = n_z_wall_height,
				in_z_wall_top_height = n_z_wall_top_height,
				iz_plaza_top_height = n_z_city_top_height,
				ib_herald = ib_herald
			);

			translate([0,0,iz_road_top_height-iz_road_height])
			rotate([0,0,-90])
			bar_curved_weavy_indented
			(
				in_r=20.5,
				in_z=iz_road_height
			);

		}
		union()
		{
			//Drill the city block
			pin(+0.3, -0.8,in_z_top = n_z_wall_top_height+4, in_z_drill = 14);
			//Drill the grass
			pin(-0.8, +0.8);
			pin(+0.4, +0.8);
			//Drill the road
			pin(-0.8, +0.0);
		}
	}
}

//---------------------------------------------------------------------------
//	TILE CITY 2/4 OPPOSITE
//---------------------------------------------------------------------------


//A grass tile with a road going straight through
module tile_grass_two_quarter_city_opposite
(
	ib_herald = false
)
{
	//the road reaches up to this height
	n_z_road_top_height = 14;
	//the road digs inside the model by this height
	n_z_road_thickness = 7;
	n_z_road_indent = 1;

	n_w_road_width = 7;
	
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
			translate([0,0,6])
			terrain
			(
				in_max_levels = 5,
				in_width = 41,
				in_z_delta = 6,
				in_z_offset = 1.5,
				in_erosion=0
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
			//Drill the city block
			pin(-0.8, +0.0,in_z_top = n_z_wall_top_height+4, in_z_drill = 14);
			//Drill the grass
			pin(-0.0, +0.8);
			pin(-0.0, -0.8);
		}
	}
}


//---------------------------------------------------------------------------
//
//---------------------------------------------------------------------------

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
			//Drill the grassland
			pin(0.05, -0.8);
			//Drill the road
			pin(0.8, +0.4);
		}
	}

}

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
			//Drill the grassland
			pin(-0, -0.8);
			//Drill the road
			pin(0.8, +0.05);
		}
	}
}

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
			//Drill the grassland
			pin(-0.8, -0.8);
			//Drill the road
			pin(0, -0.8);
		}
	}
}

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
			//Drill the grassland
			pin(+0.8, -0.8);
			//Drill the road
			pin(0.05, -0.8);
		}
	}
}

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
			
			//Drill the roads
			pin(+0.05, -0.8);
			pin(+0.8, -0.05);
			pin(-0.8, +0.05);

			//Drill the grasslands
			pin(-0.8, -0.8);
			pin(+0.8, -0.8);
		}
	}
}

module grid_of_tiles_big_city
(
	in_rows = 1,
	in_cols = 1,
	spacing = 42,
	//Two Quarter City with NO Herald
	in_two_quarter_city = 1,
	in_two_quarter_city_with_herald = 1,
	in_two_quarter_city_with_road_turn = 1,
	in_two_quarter_city_with_road_turn_with_herald = 1,
	in_two_quarter_city_opposite = 1,
	in_two_quarter_city_opposite_with_herald = 1,
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

    }
}


if (false)
{
	quarter_city_block
	(
		ir_orientation=0
		//in_z_wall_height = 16,
		//in_z_wall_top_height = 22,
		//iz_plaza_top_height = 18
	);
}

//tile_grass_quarter_city_one_road();

//tile_grass_quarter_city_two_road_straight();

//tile_grass_quarter_city_two_road_turn_left();

//tile_grass_quarter_city_two_road_turn_right();

//tile_grass_quarter_city_three_roads();

//grid_of_tiles_no_road(4,4);

//grid_of_tiles_road(4,4);

//two_quarter_city_block();

//tile_grass_two_quarter_city(ib_herald=true);

//tile_grass_two_quarter_city_with_road_turn();

//two_quarter_city_block_opposite();

//tile_grass_two_quarter_city_opposite(true);

grid_of_tiles_big_city(4,4);
