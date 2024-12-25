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


//TESTS
//bar_sin(41,8,5,1);
//bar_curved(41/2,8,5)
//bar_curved_weavy(41/2,6,5);
//bar_curved_weavy_indented(41/2,6,5);