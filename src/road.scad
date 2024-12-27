//Encapsulate function for road creation


module bar_sin(in_l, in_w, in_z, in_w_amplitude, in_frequency=1)
{
	n_step = 1/100;

	linear_extrude(height=in_z)
	polygon
	(
		[
			//left side
			//[ -in_l/2, -in_w/2 ],
			//[ in_l/2, -in_w/2 ],
			//make the up side weavy
			for (n=[-0.5:n_step:0.5])
				[ n*in_l, in_w/2+in_w_amplitude*sin(n*360*in_frequency) ],
			for (n=[-0.5:n_step:0.5])
				[ (-n)*in_l, -in_w/2+in_w_amplitude*sin(-n*360*in_frequency) ],

		]
	);
}

module bar_sin_indented
(
	in_l,
	in_w = 7,
	in_z,
	in_w_amplitude,
	iw_indent = 1,
	iz_indent = 1,
	in_frequency=1
)
{
	difference()
	{
		bar_sin
		(
			in_l,
			in_w,
			in_z,
			in_w_amplitude=in_w_amplitude,
			in_frequency=in_frequency
		);
		translate([0,0,in_z-iz_indent])
		bar_sin
		(
			in_l,
			in_w-iw_indent,
			iz_indent,
			in_w_amplitude=in_w_amplitude,
			in_frequency=in_frequency
		);
	}
}



module bar_curved(in_r, in_w, in_z)
{
	n_step = 1/100;

	linear_extrude(height=in_z)
	polygon
	(
		[
			//make the up side weavy
			for (n=[-0.5:n_step:0.5])
				[ (in_r-in_w/2)*sin(n*90+135), (in_r-in_w/2)*sin(n*90+45) ],
			for (n=[-0.5:n_step:0.5])
				[ (in_r+in_w/2)*sin(-n*90+135), (in_r+in_w/2)*sin(-n*90+45) ],

		]
	);
}

module bar_curved_weavy(in_r, in_w, in_z, in_w_amplitude=1/30, in_frequency=2)
{
	n_step = 1/100;
	n_weavy = in_w_amplitude;
	n_weavy_frequency = in_frequency;
	translate([-in_r,-in_r,0])
	linear_extrude(height=in_z)
	polygon
	(
		[
			//make the up side weavy
			for (n=[-0.5:n_step:0.5])
				[ (in_r-in_w/2)*sin(n*90+135)*(1+n_weavy*sin(n*360*n_weavy_frequency)), (in_r-in_w/2)*sin(n*90+45)*(1+n_weavy*sin(n*360*n_weavy_frequency)) ],
			for (n=[-0.5:n_step:0.5])
				[ (in_r+in_w/2)*sin(-n*90+135)*(1+n_weavy*sin((n*360+90)*n_weavy_frequency)), (in_r+in_w/2)*sin(-n*90+45)*(1+n_weavy*sin((n*360+90)*n_weavy_frequency)) ],

		]
	);
}
module bar_curved_weavy_indented
(
	in_r,
	in_w = 7,
	in_z,
	in_w_amplitude=1/30,
	iw_indent = 1.5,
	iz_indent = 1,
	in_frequency=2
)
{
	difference()
	{
		bar_curved_weavy
		(
			in_r,
			in_w = in_w,
			in_z = in_z,
			in_w_amplitude=in_w_amplitude,
			in_frequency=in_frequency
		);
		translate([0,0,in_z-iz_indent])
		bar_curved_weavy
		(
			in_r,
			in_w = in_w-iw_indent,
			in_z = iz_indent,
			in_w_amplitude=in_w_amplitude,
			in_frequency=in_frequency
		);
	}
}

//------------------------------------------------------------------------------
//	ARCH
//------------------------------------------------------------------------------
//	Roads that starts from a point, goes up to an apex, and comes down to that point
//I make it by extruding an arch sideways

//arch();

module arch
(
	il_length = 40,
	iz_thickness = 5,
	iw_width=4,
	iz_height=12,
	in_segments = 10
)
{
	//Construct the arch polygon
	lp_arch_points = 
	[
		//Top Arch
		for (n_cnt = [0 : in_segments])
		[
			n_cnt * il_length / in_segments,
			1*iz_thickness +iz_height * sin((n_cnt/in_segments) * 180)
		],
		//Bottom Arch
		for (n_cnt = [0 : in_segments])
		[
			(in_segments-n_cnt) * il_length / in_segments,
			0*iz_thickness +iz_height * sin((n_cnt/in_segments) * 180)
		]

	];


    // Define the polygon vertices
	translate([-il_length/2,iw_width/2,0])
	rotate([90,0,0])
    linear_extrude(height=iw_width)
    polygon
	(
		lp_arch_points
	);
}

//arch_indented();

module arch_indented
(
	//Length of the arch
	il_length = 40,
	//vertical thickness of the arch
	iz_thickness = 5,
	//width of the arch
	iw_width=4,
	//How tall is the hump
	iz_height=4,
	//Create an indent for the guardrails
	iw_indent = 1.5,
	iz_indent = 1,
	//Rounding of the arch
	in_segments = 10,	
)
{
	difference()
	{
		union()
		{
			arch
			(
				il_length = il_length,
				iz_thickness = iz_thickness,
				iw_width=iw_width,
				iz_height=iz_height,
				in_segments = in_segments
			);
		}
		union()
		{
			translate([0,0,iz_thickness-iz_indent])
			arch
			(
				il_length = il_length,
				iz_thickness = iz_indent,
				iw_width=iw_width-iw_indent,
				iz_height=iz_height,
				in_segments = in_segments
			);
		}
	}

}


// Module to draw a rounded arch bridge
module arch_bridge(bridge_width = 50, bridge_length = 200, arch_height = 40, arch_thickness = 5) {
    // Create the rounded arch shape
    function arch_points(length, height, thickness, segments = 50) =
        [for (i = [0 : segments])
            [
                i * length / segments,
                height * sin(i * 180 / segments) + thickness
            ]
        ];

    // Define the arch shape
    arch_shape = concat(
        arch_points(bridge_length, arch_height, arch_thickness),
        [[bridge_length, 0], [0, 0]] // Closing the bottom of the arch
    );

    // Define the roadbed shape
    roadbed_shape = [
        [0, arch_thickness],
        [0, arch_thickness + 5],
        [bridge_length, arch_thickness + 5],
        [bridge_length, arch_thickness]
    ];

    // Linear extrude the arch and roadbed
    difference() {
        // Extrude the entire bridge structure
        linear_extrude(height = bridge_width) {
            polygon(points = arch_shape);
        }
        // Subtract the space under the roadbed for clearance
        translate([0, 0, 0])
        linear_extrude(height = bridge_width) {
            polygon(points = roadbed_shape);
        }
    }
}


//TESTS
//bar_sin(41,8,5,1);
//bar_curved(41/2,8,5)
//bar_curved_weavy(41/2,6,5);
//bar_curved_weavy_indented(41/2,6,5);