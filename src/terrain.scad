/*
Procedural weathered fractal terrain
by Alex Matulich, May 2021, updated with more Customizer sliders March 2022
On Thingiverse: https://www.thingiverse.com/thing:4866655
On Prusaprinters: https://www.prusaprinters.org/prints/129126-procedural-weathered-fractal-terrain-in-openscad

Generate a fractal landscape with an optional weathering erosion algorithm.

See my blog article describing the erosion algorithm here:
https://www.nablu.com/2021/05/simulating-erosion.html

At the moment, this script makes a square paperweight with a landscape intersected by a sea. It is intended, eventually, to be the basis for a model of a planet with continents and oceans.

There are several parameters that can be cusomized, explained in the comments by each parameter below.

The fractal terrain generator tends to produce mountain ridges and valleys aligned north-south or east-west. That's just a natural artifact of the algorithm. The ridges can change orientation slightly with more erosion.

2024-12-22 Orso
created roundbevels to make rounded corners
*/

// ========== customizable parameters ==========

// maximum subdivision levels (max 8)
maxlevels = 5;  // [0:8]
// Number of facets generated is 2 * (2^maxlevels + 1)^2.
// Therefore, 8 subdivisions generates over 130,000 facets, 9 would be over half a million facets, 10 would be over 2 million facets. DO NOT EXCEED 8. Eight is enough!!

// random number seed
seed = -900;
// The landscape generated results from a combination of maxlevels and seed. That is, using a different value of maxlevels with the same seed generates a different landscape.
// Interesting seeds with maxlevel=7: 2, -1000, 8000000
// Interesting seeds with maxlevel=8: 2021

// length of a side in mm (default is 100)
sidelen = 41;  // [50:180]

// z height magnification (default is 30)
zscale = 5;    // [10:50]

// raise or lower entire landscape by this amount (typically 0)
zoffset = 0;

// number of weathering passes to erode the landscape
erosionpasses = 0;  // [0:4]
// This is a slow process for high subdivision levels. The console window displays a count of the weathering passes being done.

// sea level (can disable the sea in the 'show' parameter next)
sealevel = -0.5;
// The landscape+sea object has a varying height above and below z=0, and it is positioned with the z=0 value centered at [0,0,zoffset] on the axes. Changing sealevel does not change the position of the object in 3D space, it just changes the position of the sea relative to the origin.

// render a box base for the terrain
boxed = true;
// If true, the terrain is rendered with a box base extending 1mm below the lowest point of the terrain. If false, only the landscape surface is rendered.

// what to render
show = "terrain"; //[terrain,sea,both]
// "terrain" renders the terrain only (boxed or not)
// "sea" renders the sea only with terrain subtracted from it. This is useful only if you want to print the sea profile on the sides of the box with a multi-color printer.
// "both" shows a union of the landscape and sea together.
// The easier way to make a different color sea is just to print the combined model, setting the slicer to change to a new filament after the top sea level layer is printed.

// bevel off mm from the corners (applies only if boxed==true)
cornerbevel = 3; // [0:20]

// corner elevations; suggested range -1 to +1
cornerelev = [[0, 0], [+0, 0]];
// This is the starting cell for the fractal landscape generation. Regardless of the number of subdivisions, the corners of the landscape always have the values specified here.

// ========== end of customizable parameters ==========

module dummy(){}    // force customizer to stop here if it's active


module terrain_seed( in_seed = -1000, in_max_levels = 4, in_width = 100, in_z_delta = 20, in_z_offset = 0, in_erosion = 0 )
{
	randfield = scaled2drands(in_seed, cornerelev, in_max_levels);

	// now make the landscape
	landscape = make_landscape(cornerelev, in_max_levels, randfield);

	// erode the landscape (happens if erosionpasses > 0)
	plotfield = grayerode(landscape, passes=in_erosion);

	translate([0,0,2.5]) 
    difference()
	{
        surfaceplot(plotfield, xlen=in_width, ylen=in_width, zoffset=in_z_offset, zscale=in_z_delta, box=boxed);
		roundbevels(cornerbevel, in_width, in_width, 4*in_z_delta, -2*in_z_delta-in_z_offset);
    }
}


module terrain( in_max_levels = 4, in_width = 100, in_z_delta = 20, in_z_offset = 0, in_erosion = 0 )
{
	n_seed = rands( -1000, 1000, 1 );
	
	randfield = scaled2drands(n_seed[0], cornerelev, in_max_levels);

	// now make the landscape
	landscape = make_landscape(cornerelev, in_max_levels, randfield);

	// erode the landscape (happens if erosionpasses > 0)
	plotfield = grayerode(landscape, passes=in_erosion);

	translate([0,0,2.5]) 
    difference()
	{
        surfaceplot(plotfield, xlen=in_width, ylen=in_width, zoffset=in_z_offset, zscale=in_z_delta, box=boxed);
		roundbevels(cornerbevel, in_width, in_width, 4*in_z_delta, -2*in_z_delta-in_z_offset);
    }
}

module hill( in_seed = -1000, in_max_levels = 4, in_width = 100, in_z_delta = 20, in_z_offset = 0, in_erosion = 0, in_z_random = 5 )
{

	linear_plane = generate_square_2d_array(in_max_levels,in_z_top=in_z_delta,in_z_random=in_z_random);

	// now make the landscape
	//landscape = make_landscape(cornerelev, in_max_levels, randfield);
	landscape = make_landscape(cornerelev, in_max_levels, linear_plane);

	// erode the landscape (happens if erosionpasses > 0)
	plotfield = grayerode(landscape, passes=in_erosion);

	translate([0,0,2.5]) 
    difference()
	{
        surfaceplot(plotfield, xlen=in_width, ylen=in_width, zoffset=in_z_offset, zscale=in_z_delta, box=boxed);
		roundbevels(cornerbevel, in_width, in_width, 4*in_z_delta, -2*in_z_delta-in_z_offset);
    }
}

function generate_square_2d_array(in_level=2, in_z_top=0,in_z_random=1) =
	//HACK: the generation has the Z wonky, i divide by 10 to refactor
    let(size = pow(2, in_level))
    [
        for (y = [0 : size - 1])
		[
            for (x = [0 : size - 1])
                interpolate(x, y, size, in_z_top/10)
			
        ]+rands(-0.5*in_z_random/10,0.5*in_z_random/10,size)
    ];

// Helper function to interpolate values
function interpolate(x, y, size, Ztarget) =
    let(
        cx = size / 2 -0.5, // Center x coordinate
        cy = size / 2 -0.5, // Center y coordinate
		kx = 1-abs((x-cx)/cx),
		ky = 1-abs((y-cy)/cy),
		d = kx*ky
    )
    Ztarget * (d);

//terrain( in_max_levels = 2, in_z_delta = 10);
//hill( in_max_levels = 3, in_z_delta = 15, in_erosion=1);

/*

// first, generate a field of random elevation offsets at each coordinate
randfield = scaled2drands(seed, cornerelev, maxlevels);

// now make the landscape
landscape = make_landscape(cornerelev, maxlevels, randfield);

// erode the landscape (happens if erosionpasses > 0)
plotfield = grayerode(landscape, passes=erosionpasses);

// render the landscape, sea, or both (normally "both" is most useful)



if (show == "terrain") {
    difference() {
        surfaceplot(plotfield, xlen=sidelen, ylen=sidelen, zoffset=zoffset, zscale=zscale, box=boxed);
        if (boxed && cornerbevel > 0)
            //cornerbevels(cornerbevel, sidelen, sidelen, 4*zscale, -2*zscale-zoffset);
			roundbevels(cornerbevel, sidelen, sidelen, 4*zscale, -2*zscale-zoffset);
    }
} else if (show == "sea") { // makes sense only if boxed==true
    difference() {
        seabox(plotfield, sealevel, sidelen, zoffset, zscale, cornerbevel);
    surfaceplot(plotfield, xlen=sidelen, ylen=sidelen, zoffset=zoffset, zscale=zscale, box=true);
    }
} else // both land and sea together
    renderlandscape(plotfield, sealevel, sidelen, zoffset, zscale, boxed, cornerbevel);

*/

// ========== rendering modules ==========

// landscape + sea

module renderlandscape(elevations, sealevel=0, sidelen=100, zoffset=0, zscale=30, box=false, bevel=0) {
    difference() {
        union() {
            surfaceplot(elevations, sidelen, sidelen, zoffset, zscale, box);
            seabox(elevations, sealevel, sidelen, zoffset, zscale, 0);
        }
        if (bevel > 0)
            cornerbevels(bevel, sidelen, sidelen, 4*zscale, -2*zscale-zoffset);
    }
}

// sea only

module seabox(elevations, sealevel=0, sidelen=100, zoffset=0, zscale=30, bevel=0) {
    zmin = min2d(elevations);
    zmax = max2d(elevations);
    zpmin = zmin*zscale+zoffset;
    ht = (sealevel-zmin*zscale)+0.01;
    if (ht>0)
        translate([0,0,zpmin+0.5*ht]) difference() {
            color("blue") cube([sidelen-0.01, sidelen-0.01, ht], true);
            if (bevel > 0) cornerbevels(bevel, sidelen, sidelen, (zmax-zmin)*zscale, zmin*zscale);
        }
}

// corner bevels

module cornerbevels(bevel, xsidelen, ysidelen, zht, zmin) {
    sq2 = sqrt(2);
    xs = xsidelen/2;
    ys = ysidelen/2;
    zm = zmin-2;
    bev = [ [-1,-1], [-1,sq2*(bevel+2)-1], [sq2*(bevel+2)-1,-1] ];
    union() {
        translate([-xs, -ys, zmin]) linear_extrude(zht+4) polygon(points=bev);
        translate([-xs, ys, zmin]) rotate([0,0,-90]) linear_extrude(zht+4) polygon(points=bev);
        translate([xs, ys, zmin]) rotate([0,0,180]) linear_extrude(zht+4) polygon(points=bev);
        translate([xs, -ys, zmin]) rotate([0,0,90]) linear_extrude(zht+4) polygon(points=bev);
    }
}

module roundbevels(bevel, xsidelen, ysidelen, zht, zmin)
{
	//I construct a cube
	//I construct a rounded cube
	//I subtract the two
	translate([0,0,zmin])
	difference()
	{
		union()
		{
			translate([0,0,zht/2])
			cube([xsidelen,ysidelen,zht],center=true);
		}
		union()
		{
			linear_extrude(zht)
			hull($fn=40)
			{
				// Subtract the four rounded corners using circles
				for (x = [-xsidelen/2+bevel, +xsidelen/2-bevel]) {
					for (y = [-ysidelen/2+bevel, +ysidelen/2-bevel]) {
						translate([x, y]) {
							circle(bevel);
						}
					}
				}
			}

		}

	}
}

// Submodule to create the rounded corner "bevel" (rounded square)
module square_bevel(radius) {
    offset = radius;
    square(40, center = true); 
    circle(radius);
}


// general purpose module for plotting an 2D array of elevation values

module surfaceplot(elevations, xlen=100, ylen=100, zoffset=0, zscale=30, box=false) {
    echo("Generating 3D plot");
    xrange = [-xlen/2, xlen/2];
    yrange = [-ylen/2, ylen/2];
    irange = len(elevations[0]);
    xrangestep = (xrange[1]-xrange[0]) / (irange-1);
    yrangestep = (yrange[1]-yrange[0]) / (irange-1);
    zmin = min2d(elevations)*zscale+zoffset-1;
    zboff = max(0, zoffset);
    field3d = [
        for(y=[0:irange-1])
            for(x=[0:irange-1]) [x*xrangestep+xrange[0], y*yrangestep+yrange[0], elevations[y][x]*zscale+zoffset],
        if (box) [xrange[0], yrange[0], zmin-zboff],
        if (box) [xrange[0], yrange[1], zmin-zboff],
        if (box) [xrange[1], yrange[0], zmin-zboff],
        if (box) [xrange[1], yrange[1], zmin-zboff]
    ];
    npts = irange*irange;
    faces = [
        for(y=[0:irange-2]) let(jy=irange*y)
            for (x=[0:irange-2])
                [jy+x, jy+irange+x, jy+irange+x+1, jy+x+1],
        if (box) [ npts, npts+1, for(y=[irange-1:-1:0]) irange*y ],
        if (box) [ npts+2, npts, for(x=[0:irange-1]) x ],
        if (box) [ npts+3, npts+2, for(y=[0:irange-1]) irange*y+irange-1 ],
        if (box) [ npts+1, npts+3, for(x=[0:irange-1]) npts-1-x ],
        if (box) [ npts, npts+2, npts+3, npts+1 ]
    ];
    polyhedron(field3d, faces, convexity=10);
}

// ========== functions ==========

function make_landscape(field, levels, randfield, lv=0) =
    let(q = echo("Fractal landscape subdivision level", lv, "of", levels) 1)
    lv >= levels ? field : let(newfield = subdivide_field(field, randfield)) make_landscape(newfield, levels, randfield, lv+1);

function subdivide_field(a, randfield) = let(
    r0len = len(a[0]), r1len = 2*r0len-1, randrowlen = len(randfield[0]),
    skip = (randrowlen-1) / (r1len-1)
    ) [
    for (i=[0:r1len-1]) let(ri = floor(i/2), odd = (i/2 - ri > 0.01))
        odd ?
        subdivide_oddrow(a[ri], a[ri+1], randfield[i*skip])
        : subdivide_evenrow(a[ri], randfield[i*skip])
    ];

function subdivide_evenrow(row, randrownums) = let(
    r0len = len(row), r1len = 2*r0len-1, randrowlen = len(randrownums),
    skip = (randrowlen-1) / (r1len-1)
    ) [
    for(i=[0:r1len-2]) let(ri = floor(i/2), odd = (i/2 - ri > 0.01))
        odd ? 0.5*(row[ri]+row[ri+1]) + randrownums[i*skip] : row[ri],
        row[r0len-1]
];

function subdivide_oddrow(lastrow, nextrow, randrownums) = let(
    r0len = len(lastrow), r1len = 2*r0len-1, randrowlen = len(randrownums),
    skip = (randrowlen-1) / (r1len-1)
    ) [
    for(i=[0:r1len-1]) let(ri = floor(i/2), odd = (i/2 - ri > 0.01))
        odd ?
        0.25*(lastrow[ri]+lastrow[ri+1]+nextrow[ri]+nextrow[ri+1]) + randrownums[i*skip]
        : 0.5*(lastrow[ri]+nextrow[ri]) + randrownums[i*skip]
];

// Function to generate a 2D field of random numbers, scaled according to coordinates.
// Parameters:
// - seed: The base seed for the random number generator, ensures reproducibility.
// - cornervals: A 2x2 array defining values at the corners of the field.
// - levels: Number of levels, determines the resolution of the field (2^levels subdivisions).
// - leftedge: Optional, predefined values for the left edge of the field.
// - rightedge: Optional, predefined values for the right edge of the field.
// - topedge: Optional, predefined values for the top edge of the field.
// - botedge: Optional, predefined values for the bottom edge of the field.
//
// Returns:
// A 2D array of random numbers scaled by coordinates.

function scaled2drands(seed, cornervals, levels, leftedge=undef, rightedge=undef, topedge=undef, botedge=undef) = let(
    // Log the generation process
    q = echo("Generating random number field") 1,

    // Compute the number of subdivisions based on levels
    imax = pow(2, levels),

    // Generate or use predefined edge values
    eleft = leftedge == undef ? randline(seed, levels, cornervals[0][0], cornervals[1][0]) : leftedge,
    eright = rightedge == undef ? randline(seed + 7, levels, cornervals[0][1], cornervals[1][1]) : rightedge
) [
    // Generate top edge values if not provided
    topedge == undef ? randline(seed, levels, cornervals[0][0], cornervals[0][1]) : topedge,

    // Generate random values for the field, row by row
    for (i = [1 : imax - 1])
        randline(seed + 17 * i, levels, eleft[i], eright[i], baselevel = numlevel(i, levels)),

    // Generate bottom edge values if not provided
    botedge == undef ? randline(seed, levels, cornervals[1][0], cornervals[1][1]) : botedge
];

// line of random numbers scaled according to index

function randline(in_seed, levels, firstval=undef, lastval=undef, baselevel=0, randrange=2) = let(
    n = pow(2, levels),
	nr = rands(-0.5*randrange,0.5*randrange, n+1, in_seed),
    endscl = pow(0.5, baselevel)
    ) [ firstval == undef ? endscl*nr[0] : firstval,
        for(i=[1:n-1]) let(ilev = max(baselevel, numlevel(i, levels)))
            pow(0.5,ilev) * nr[i],
        lastval == undef ? endscl*nr[n] : lastval
    ];
        
// subdivision level of a number given 'levels'

function numlevel(num, levels, testnum=0, step=0, lv=0) = let(
    range = pow(2,levels),
    newstep = step==0 ? 0.5*range : (((testnum < num && step < 0) || (testnum > num && step > 0)) ? -0.5*step : 0.5*step))
    (num == testnum || num == range || lv>=levels) ? lv : numlevel(num, levels, testnum+newstep, newstep, lv+1);

// minimum and maximum of a 2d array

function min2d(field) = let(
    rowmins = [ for(y=[0:len(field)-1]) min(field[y]) ]
    ) min(rowmins);

function max2d(field) = let(
    rowmaxes = [ for(y=[0:len(field)-1]) max(field[y]) ]
    ) max(rowmaxes);

// erosion algorithm:
// This is grayscale erosion (see https://en.wikipedia.org/wiki/Erosion_(morphology)#Grayscale_erosion for explanation) modified to use a circular kernel and variable height reduction depending on position of kernel center relative to kernel's elevation range.

function grayerode(field, passes, npass=1) = (passes == 0) ? field : let(
    invsq2 = 1.0/sqrt(2.0),
    ymax = len(field)-1,
    xmax = len(field[0])-1,
    erodedfield = echo("Erosion pass", npass, "of", passes)
    [
        for(y=[0:ymax]) let(dymin = max(0,y-1), dymax = min(ymax, y+1))
        [
            for(x=[0:xmax]) let(
                dxmin = max(0,x-1),
                dxmax = min(xmax, x+1),
                kernel = [
                    for(dy=[dymin:dymax]) [
                        for(dx=[dxmin:dxmax])
                            ((dx==dxmin || dx==dxmax) && (dy==dymin || dy==dymax))
                                // interpolate kernel corner onto circle
                                ? invsq2*(field[dy][dx]-field[y][x]) + field[y][x]
                                : field[dy][dx]
                    ]
                ],
                kmin = min2d(kernel),
                kmax = max2d(kernel),
                f = (field[y][x]-kmin) / (kmax-kmin) // erosion factor
            ) kmin + (1.0-f) * (field[y][x] - kmin)
        ]
    ]
    ) npass >= passes ? erodedfield : grayerode(erodedfield, passes, npass+1);
