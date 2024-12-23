# Gridfinity-medieval-tiles

Gridfinity tiles inspired by carcassone compatible with gridfinity base plate.

Meant to use to make D&D modular dungeons like overworld maps and dungeons.

## QUICK LINKS
- ### [PROJECT BOARD](https://github.com/users/OrsoEric/projects/12)
- ### [ISSUES](https://github.com/OrsoEric/Gridfinity-medieval-tiles/issues)
- ### [STLs](https://github.com/OrsoEric/Gridfinity-medieval-tiles/tree/Master/stl)

## Gridfinity Base Plate

Found the skinniest base plate. There are plates that incorporate magnets and screw.

![Gridfinity Base Plate](images\2024-12-19-Gridfinity-5x5.jpg)

## Gridfinity Tile - Grass

My first tile! I combined a gridfinity base tile 1x1 with a fractal terrain generation algorithm to get grass. Changing the seed and the parameter allow to generate lots of unique grass tiles.

![Fractal Terrain Generation](images\2024-12-22e-fractal-terrain-generation.jpg)

![Grass Tile](images\2024-12-22f-first-grass-tile-printed.jpg)

SCAD code improved to generate a grid of tiles each with individually different seeds, so I can print tiles all different from each others with little work!

PROBLEM: filament got stuck during the night. I need to move the filament detection closer to the head, it's a problem of my K1

![Grass Tile](images\2024-12-23a-Print-25-grass-tail-partial-fail.jpg)


## Gridfinity Tile - Grass and Road

Starting from a grass tile, make a structure on top of it.  I made the roads sinusoidal to give them a rural look. The curved road has a different algorithm that modulates the radious into a sin.

I can extrude a smaller sinusoidal road from another to get the guardrails that look great.

Crossroads are simply made with road intersection, and the extrusion of smaller roads work as intended.

I placed a M2.5 pin on each section of the road for markers and such.

![Straight Road](images\2024-12-23_11_07-grass-straight-road.jpg)


By increasing elevation, I can put a pause and change filament to have colored roads for free on all tiles, while still keeping each tile grass unique.

![Color Change](images\2024-12-23_11_00_filament-change.jpg)

## Attribution

The fractal generation in terrain.scad has been copied and modified from: [Author](https://www.printables.com/@Anachronist) [Repository](https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files) inder a CC 4.0 license.