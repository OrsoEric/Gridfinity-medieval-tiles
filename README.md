# Gridfinity-medieval-tiles

Gridfinity tiles inspired by carcassone compatible with gridfinity base plate.

Meant to use to make D&D modular dungeons like overworld maps and dungeons.

## QUICK LINKS
- ### [PROJECT BOARD](https://github.com/users/OrsoEric/projects/12)
- ### [ISSUES](https://github.com/OrsoEric/Gridfinity-medieval-tiles/issues)
- ### [STLs](https://github.com/OrsoEric/Gridfinity-medieval-tiles/tree/Master/stl)

## Gridfinity Base Plate

Found the skinniest base plate. There are plates that incorporate magnets and screw.

![Gridfinity Base Plate](/images/2024-12-19-Gridfinity-5x5.jpg)

## Gridfinity Tile - Grass

My first tile! I combined a gridfinity base tile 1x1 with a fractal terrain generation algorithm to get grass. Changing the seed and the parameter allow to generate lots of unique grass tiles.

![Fractal Terrain Generation](/images/2024-12-22e-fractal-terrain-generation.jpg)

![Grass Tile](/images/2024-12-22f-first-grass-tile-printed.jpg)

SCAD code improved to generate a grid of tiles each with individually different seeds, so I can print tiles all different from each others with little work!

PROBLEM: filament got stuck during the night. I need to move the filament detection closer to the head, it's a problem of my K1

![Grass Tile](/images/2024-12-23a-Print-25-grass-tail-partial-fail.jpg)


## Gridfinity Tile - Grass and Road

Starting from a grass tile, make a structure on top of it.  I made the roads sinusoidal to give them a rural look. The curved road has a different algorithm that modulates the radious into a sin.

I can extrude a smaller sinusoidal road from another to get the guardrails that look great.

Crossroads are simply made with road intersection, and the extrusion of smaller roads work as intended.

I placed a M2.5 pin on each section of the road for markers and such.

![Straight Road](/images/2024-12-23_11_07-grass-straight-road.jpg)


By increasing elevation, I can put a pause and change filament to have colored roads for free on all tiles, while still keeping each tile grass unique.

![Color Change](/images/2024-12-23_11_00_filament-change.jpg)

My K1 supports 25 tiles printed at once. I used two color changes to do a base white (cheap) than do the green for the grass, then return to the white for the road and be ready for the next batch done the same way.

![Slice 25 Tiles](/images/2024-12-23_12_25-25-Grass-Road-Tiles.png)

Printed the plate with 25 mixed tiles and two colors, green for base, white for the road, it came out great!

![25 Grass Road Tiles on K1 Plate](/images/25X-Grass-Road-Tiles-Plate.jpg)

Some pins need to be deeper when the generation gives a low Z.

![25 Grass Road Tiles](/images/25X-Grass-Road-Tiles.jpg)

## Gridfinity Tile - Grass Church and Road

This tile creates a single church building on top of a platform on top of a hill.

![Slice 9X Church Tiles](/images/9X-Church-Tiles-OptionalRoad.jpg)

I improved the grid generator to select the number of tiles with road, and it will give you a grid with the tiles already mixed road/no road.

I created hill function that modifies the fractal to always creat a hill. The height is not the millimeters you give but is consistent, I would have to dig in the procedural generation to see why the number is what it is.

Created truncated cone function to make a platform. I'd like to make cobblestone patterns on top.

Made the pin deeper from 7 to 10mm as some tiles are too low in Z.

Set a pause at layer 158 to switch from green to white. Had some bleeding on a few taller hills.

![9X Church Tiles Printed](/images/9X-Church-Tiles-Printed.jpg)

Placing alongside the road tiles works great!

![9X Church Tiles Printed](/images/9X-Church-Tiles-Placed.jpg)

## Gridfinity City Tile

Taking inspiration from carcassone, I can a number of sides to be cities, so I can tile them and build cities of arbitrary size for my campaigns.

First hurdle is 1/4 city generation. I need the city to be higher than the road to get away from terrain and have margin for the filament change.

The walls are a module that go from point to point and have a top indent. One day I'd like to texture the wall.

![Procedural Buildings](/images/Wall.png)

I decided to have three linear walls dotted with four rounded towers, and behind a plaza where the buildings are placed. The rounded walls of the tower round the corners nicely and hide the connection. Anotherr advantge is that I can select point to get 2/4 and 3/4 cities without changing the generation rules, just the points.

![City Walls](/images/City-Walls.png)


For the buildings, I reuse the house module I made. I tried several way, and the way to go is to place random houses of small and medium size on a rectangle, then extrude the polygon that makes the city. This approach shoud scale to larger city tiles with different shape.

![Procedural Buildings](/images/city-procedural-generation.jpg)

Combine All and I have the 1/4 city tile that scales to 2/4 3/4 and 4/4 hopefully. Just add optional roads and pins on the terrain.

![City Tile](/images/City-Tile.png)

I added two functions to render tiles with multiple 1/4 cities and 1/4 city tiles with multiple road configuration and made a 25X city tile plate that fits my printer with one color change from green to white at layer 158.

![25X City Tiles](/images/25-Quarter-City-Road-Tiles.png)

## Attribution

The fractal generation in terrain.scad has been copied and modified from: [Author](https://www.printables.com/@Anachronist) [Repository](https://www.printables.com/model/129126-procedural-weathered-fractal-terrain-in-openscad/files) inder a CC 4.0 license.