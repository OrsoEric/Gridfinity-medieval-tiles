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

//Maximum height at which grass will be found
gz_grass_top_height = 11.5;
//Do not let grass be lower than this, below there is the geometry of the tile
gz_grass_base = 2.5;
//Height of flat grass tiles
gz_grass_flat = gz_grass_top_height -gz_gridfinity_socket_offset;
//Maximum height consistency of flat grass tiles
gn_grass_flat_consistency = 0.9;

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






