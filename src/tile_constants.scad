//------------------------------------------------------------------------------
//	GRIDFINITY CONSTANTS
//------------------------------------------------------------------------------

//Spacing between tiles
gw_gridfinity_spacing = 42.0;
//width of a gridfinity tile
gw_gridfinity = 41.5;
gw_gridfinity_half_pitch = gw_gridfinity/2;

//height above which I can put geometry without interfering with the gridfinity socket
gz_gridfinity_socket_offset = 5;

//------------------------------------------------------------------------------
//	GRASS CONSTANTS
//------------------------------------------------------------------------------
//Constants for generating default grass terrain used in most tiles

//Maximum height at which grass will be found
gz_grass_top_height = 11.5;
//Do not let grass be lower than this, below there is the geometry of the tile
gz_grass_base = 2.5;
//Height of flat grass tiles
gz_grass_flat = gz_grass_top_height -gz_gridfinity_socket_offset;
//Maximum height consistency of flat grass tiles
gn_grass_flat_consistency = 0.9;

//------------------------------------------------------------------------------
//	HILL CONSTANTS
//------------------------------------------------------------------------------
//Constant for generating hill terrain. Used for CHURCH Tile

gz_grass_hill_top_height = 14;
gz_grass_hill_height = gz_grass_hill_top_height -gz_gridfinity_socket_offset;
gn_grass_hill_consistency = 0.9;
gz_grass_hill_random = 4;

//------------------------------------------------------------------------------
//	ROAD CONSTANTS
//------------------------------------------------------------------------------

//the road reaches up to this height
gz_road_top_height = 14;
//the road digs inside the model by this height
gz_road_height = 7;
//Width of the road
gw_road_width = 7;
//The road is indented to make for guardrails
gw_road_indent = 1.5;
gz_road_indent = 1;

//------------------------------------------------------------------------------
//	CITY CONSTANTS
//------------------------------------------------------------------------------

gw_wall_width = 4;
gw_wall_indent = 1.5;
//Top Z of the wall
gz_wall_top_height = 22;
//Height of the wall
gz_wall_height = 16;
//How tall the towers stands above the walls
gz_short_tower_above_wall=10;
gz_tall_tower_above_wall=20;
//Base of the city
gz_plaza_top_height = 18;



