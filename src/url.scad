//futura is a really rounded sans serif font

//text("tinyurl.com/yyhde59z");
//project_url();

module project_url(in_size = 2,in_spacing=1.1,iz_height = 0.5,ih_line_spacing=3)
{
	translate([0,+2*(in_size+ih_line_spacing),0])
	linear_extrude(iz_height)
	text("GITHUB.COM/",size=in_size,spacing=in_spacing,font="Futura:style=Bold");
	translate([0,+1*(in_size+ih_line_spacing),0])
	linear_extrude(iz_height)
	text("ORSOERIC/",size=in_size,spacing=in_spacing,font="Futura:style=Bold");
	translate([0,+0*(in_size+ih_line_spacing),0])
	linear_extrude(iz_height)
	text("GRIDFINITY-",size=in_size,spacing=in_spacing,font="Futura:style=Bold");
	translate([0,-1*(in_size+ih_line_spacing),0])
	linear_extrude(iz_height)
	text("MEDIEVAL-",size=in_size,spacing=in_spacing,font="Futura:style=Bold");
	translate([0,-2*(in_size+ih_line_spacing),0])
	linear_extrude(iz_height)
	text("TILES",size=in_size,spacing=in_spacing,font="Futura:style=Bold");

}
