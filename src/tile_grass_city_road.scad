//This tile is the most complex
//it creates a combination of city sides and road sides
//With optional buildings

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

//AUX function to help with the rotation
//Use gray encoding that ought to conserve rotational simmetry
function direction(angle) = 
    (angle % 360 == 0)   ? [1, 1] :
    (angle % 360 == 90)  ? [-1, 1] :
    (angle % 360 == 180) ? [-1, -1] :
    (angle % 360 == 270) ? [1, -1] :
    [0, 0]; // Default for invalid inputs


module quarter_city_block( ir_orientation = 0, in_z_wall_top_height=18, in_z_wall_height = 12, iz_plaza_top_height = 14 )
{

	n_gridfinity = 41;

	//WALL PARAMETERS

	nw_wall_width = 4;

	//TOWER PARAMETERS
	n_z_short_tower = 20;
	n_z_tall_tower = 30;

	//COMPUTE POINTS

	n_corner = n_gridfinity/2-2.2;
	n_edge = 10;

	dir = direction(ir_orientation);
	start_l = [ dir[0]*n_corner, dir[1]*n_corner];
	end_l = [ dir[0]*n_edge, dir[1]*n_edge];
	corner_l = (ir_orientation % 180 == 0) ?
		[ dir[0]*n_corner, dir[1]*n_gridfinity/2] :
		[ dir[0]*n_gridfinity/2, dir[1]*n_corner] ;

	echo("Left Points: ", start_l, end_l);

	dir_r = direction(ir_orientation+90);
	start_r = [ dir_r[0]*n_corner, dir_r[1]*n_corner];
	end_r = [ dir_r[0]*n_edge, dir_r[1]*n_edge];
	corner_r = (ir_orientation % 180 == 0) ?
		[ dir_r[0]*n_corner, dir_r[1]*n_gridfinity/2] :
		[ dir_r[0]*n_gridfinity/2, dir_r[1]*n_corner] ;

	echo("Right Points ", start_r, end_r);
	
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


	//CITY PLAZA
	//Platform where the buildings are spawned
	translate([0,0,in_z_wall_top_height-in_z_wall_height])
	city
	(
		[
			corner_l,
			end_l,
			end_r,
			corner_r
		]
	);


}

//A grass tile with a road going straight through
module tile_grass_city_road_single(ib_road=true)
{
	//the road reaches up to this height
	n_z_road_top_height = 14;
	//the road digs inside the model by this height
	n_z_road_thickness = 7;
	n_z_road_indent = 1;

	n_w_road_width = 7;
	
	n_z_wall_top_height = 18;
	

	difference()
	{
		union()
		{
			//Create a grifinity tile
			grid_block(num_x=1, num_y=1, num_z=0.5, magnet_diameter=0, screw_depth=0);
			//On top, create a fractal terrain
			translate([0,0,6])
			terrain
			(
				in_max_levels = 5,
				in_width = 41,
				in_z_delta = 6,
				in_z_offset = 1,
				in_erosion=0
			);

			//on top create a half weavy road
			if (ib_road == true)
			{
				translate([-41/2.666,0,n_z_road_top_height-n_z_road_thickness])
				bar_sin(41/4, n_w_road_width,n_z_road_thickness, 1, 0);
			}
			
			quarter_city_block
			(
				ir_orientation=0,
				in_z_wall_top_height=n_z_wall_top_height
			);



			//create a basement for the buildings?
			//translate([-0.5,0,8])
			//truncated_cone(24,22,6);

		}
		union()
		{
			if (ib_road == true)
			{
				//on top create a weavy road to extrude and create the sides of the road
				translate([-41/2.666,0,n_z_road_top_height-n_z_road_indent])
				bar_sin(41/4, n_w_road_width-2, n_z_road_indent, 1, 0);
				
				//Drill a hole on the road
				pin(-0.8, -0.0);
			}
			
			//drill the church
			pin(-0.4, -0.0, in_z_top=24, in_z_drill=9);

			//Drill the grassland
			pin(-0.6, -0.6);
			
		}
	}
}

tile_grass_city_road_single();

//quarter_city_block(ir_orientation=0,in_z_wall_top_height=18);