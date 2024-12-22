//	2024-12-22
//The tile with the short grid very slightly touches the bottom
//I need to slightly move up the tile
//The function is pad_oversize
//bevel2_bottom 2.6->2.3

gridfinity_pitch = 42;
gridfinity_zpitch = 7;
gridfinity_clearance = 0.5; // each bin is undersize by this much

// set this to produce sharp corners on baseplates and bins
// not for general use (breaks compatibility) but may be useful for special cases
sharp_corners = 0;

// basic block with cutout in top to be stackable, optional holes in bottom
// start with this and begin 'carving'
module grid_block(
    num_x = 1,
    num_y = 1,
    num_z = 2,
    magnet_diameter = 6.5,
    screw_depth = 6,
    center = false,
    hole_overhang_remedy = false,
    half_pitch = false,
    box_corner_attachments_only = false
)
{
    corner_radius = 3.75;
    outer_size = gridfinity_pitch - gridfinity_clearance; // typically 41.5
    block_corner_position = outer_size / 2 - corner_radius; // need not match center of pad corners
    magnet_thickness = 2.4;
    magnet_position = min(gridfinity_pitch / 2 - 8, gridfinity_pitch / 2 - 4 - magnet_diameter / 2);
    screw_hole_diam = 3;
    gp = gridfinity_pitch;

    suppress_holes = num_x < 1 || num_y < 1;

    emd = suppress_holes ? 0 : magnet_diameter; // effective magnet diameter after override
    esd = suppress_holes ? 0 : screw_depth; // effective screw depth after override

    overhang_fix = hole_overhang_remedy && emd > 0 && esd > 0;
    overhang_fix_depth = 0.3; // assume this is enough

    totalht = gridfinity_zpitch * num_z + 3.75;

    translate(center ? [-(num_x - 1) * gridfinity_pitch / 2, -(num_y - 1) * gridfinity_pitch / 2, 0] : [0, 0, 0])
    difference()
    {
        intersection()
        {
            union()
            {
                pad_grid(num_x, num_y, half_pitch);
                translate([-gridfinity_pitch / 2, -gridfinity_pitch / 2, 5])
                cube([gridfinity_pitch * num_x, gridfinity_pitch * num_y, totalht - 5]);
            }

            translate([0, 0, -0.1])
            hull()
            cornercopy(block_corner_position, num_x, num_y)
            cylinder(r = corner_radius, h = totalht + 0.2, $fn = 32);
        }

        color("blue")
        translate([0, 0, gridfinity_zpitch * num_z])
        pad_oversize(num_x, num_y, 1);

        if (esd > 0)
        {
            gridcopycorners(ceil(num_x), ceil(num_y), magnet_position, box_corner_attachments_only)
            translate([0, 0, -0.1])
            cylinder(d = screw_hole_diam, h = esd + 0.1, $fn = 28);
        }

        if (emd > 0)
        {
            gridcopycorners(ceil(num_x), ceil(num_y), magnet_position, box_corner_attachments_only)
            translate([0, 0, -0.1])
            cylinder(d = emd, h = magnet_thickness + 0.1, $fn = 41);
        }

        if (overhang_fix)
        {
            gridcopycorners(ceil(num_x), ceil(num_y), magnet_position, box_corner_attachments_only)
            translate([0, 0, magnet_thickness - 0.1])
            render()
            intersection()
            {
                translate([-emd / 2, -screw_hole_diam / 2, 0])
                cube([emd, screw_hole_diam, overhang_fix_depth + 0.1]);
                cylinder(d = emd, h = 1, $fn = 41);
            }
        }
    }
}

module pad_grid(num_x, num_y, half_pitch = false)
{
    cut_far_x = (num_x < 1 && !half_pitch) || (num_x < 0.5);
    cut_far_y = (num_y < 1 && !half_pitch) || (num_y < 0.5);

    if (half_pitch)
    {
        gridcopy(ceil(num_x), ceil(num_y))
        intersection()
        {
            pad_halfsize();

            if (cut_far_x)
            {
                translate([gridfinity_pitch * (-0.5 + num_x), 0, 0])
                pad_halfsize();
            }

            if (cut_far_y)
            {
                translate([0, gridfinity_pitch * (-0.5 + num_y), 0])
                pad_halfsize();
            }

            if (cut_far_x && cut_far_y)
            {
                translate([gridfinity_pitch * (-0.5 + num_x), gridfinity_pitch * (-0.5 + num_y), 0])
                pad_halfsize();
            }
        }
    }
    else
    {
        gridcopy(ceil(num_x), ceil(num_y))
        intersection()
        {
            pad_oversize();

            if (cut_far_x)
            {
                translate([gridfinity_pitch * (-1 + num_x), 0, 0])
                pad_oversize();
            }

            if (cut_far_y)
            {
                translate([0, gridfinity_pitch * (-1 + num_y), 0])
                pad_oversize();
            }

            if (cut_far_x && cut_far_y)
            {
                translate([gridfinity_pitch * (-1 + num_x), gridfinity_pitch * (-1 + num_y), 0])
                pad_oversize();
            }
        }
    }
}

module pad_halfsize()
{
    render()
    for (xi = [0 : 1]) for (yi = [0 : 1])
    translate([xi * gridfinity_pitch / 2, yi * gridfinity_pitch / 2, 0])
    intersection()
    {
        pad_oversize();
        translate([-gridfinity_pitch / 2, 0, 0])
        pad_oversize();
        translate([0, -gridfinity_pitch / 2, 0])
        pad_oversize();
        translate([-gridfinity_pitch / 2, -gridfinity_pitch / 2, 0])
        pad_oversize();
    }
}

module cylsq(d, h)
{
    translate([-d / 2, -d / 2, 0])
    cube([d, d, h]);
}

module cylsq2(d1, d2, h)
{
    linear_extrude(height = h, scale = d2 / d1)
    square([d1, d1], center = true);
}

module pad_oversize(num_x = 1, num_y = 1, margins = 0)
{
    pad_corner_position = gridfinity_pitch / 2 - 4; // must be 17 to be compatible
    bevel1_top = 0.8; // z of top of bottom-most bevel (bottom of bevel is at z=0)
    bevel2_bottom = 2.3; // z of bottom of second bevel
    bevel2_top = 5; // z of top of second bevel
    bonus_ht = 0.2; // extra height (and radius) on second bevel

    radialgap = margins ? 0.25 : 0; // oversize cylinders for a bit of clearance
    axialdown = margins ? 0.1 : 0; // a tiny bit of axial clearance present in Zack's design

    translate([0, 0, -axialdown])
    difference()
    {
        union()
        {
            hull()
            cornercopy(pad_corner_position, num_x, num_y)
            {
                if (sharp_corners)
                {
                    cylsq(d = 1.6 + 2 * radialgap, h = 0.1);
                    translate([0, 0, bevel1_top])
                    cylsq(d = 3.2 + 2 * radialgap, h = 1.9);
                }
                else
                {
                    cylinder(d = 1.6 + 2 * radialgap, h = 0.1, $fn = 24);
                    translate([0, 0, bevel1_top])
                    cylinder(d = 3.2 + 2 * radialgap, h = 1.9, $fn = 32);
                }
            }

            hull()
            cornercopy(pad_corner_position, num_x, num_y)
            {
                if (sharp_corners)
                {
                    translate([0, 0, bevel2_bottom])
                    cylsq2(d1 = 3.2 + 2 * radialgap, d2 = 7.5 + 0.5 + 2 * radialgap + 2 * bonus_ht, h = bevel2_top - bevel2_bottom + bonus_ht);
                }
                else
                {
                    translate([0, 0, bevel2_bottom])
                    cylinder(d1 = 3.2 + 2 * radialgap, d2 = 7.5 + 0.5 + 2 * radialgap + 2 * bonus_ht, h = bevel2_top - bevel2_bottom + bonus_ht, $fn = 32);
                }
            }
        }

        if (margins)
        {
            translate([-gridfinity_pitch / 2, -gridfinity_pitch / 2, 0])
            cube([gridfinity_pitch * num_x, gridfinity_pitch * num_y, axialdown]);
        }
    }
}

module gridcopycorners(num_x, num_y, r, onlyBoxCorners = false)
{
    for (xi = [1 : num_x]) for (yi = [1 : num_y])
    for (xx = [-1, 1]) for (yy = [-1, 1])
    if (
        !onlyBoxCorners || 
        (xi == 1 && yi == 1 && xx == -1 && yy == -1) ||
        (xi == num_x && yi == num_y && xx == 1 && yy == 1) ||
        (xi == 1 && yi == num_y && xx == -1 && yy == 1) ||
        (xi == num_x && yi == 1 && xx == 1 && yy == -1)
    )
    {
        translate([gridfinity_pitch * (xi - 1), gridfinity_pitch * (yi - 1), 0])
        translate([xx * r, yy * r, 0])
        children();
    }
}

module cornercopy(r, num_x = 1, num_y = 1)
{
    for (xx = [-r, gridfinity_pitch * (num_x - 1) + r])
    for (yy = [-r, gridfinity_pitch * (num_y - 1) + r])
    translate([xx, yy, 0])
    children();
}

module gridcopy(num_x, num_y)
{
    for (xi = [1 : num_x]) for (yi = [1 : num_y])
    translate([gridfinity_pitch * (xi - 1), gridfinity_pitch * (yi - 1), 0])
    children();
}

//grid_block(num_x = 1, num_y = 1, num_z = 0.5, magnet_diameter = 0, screw_depth = 0);
