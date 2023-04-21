# Aldous-Broder algorithm for maze generation.

Here is algorithm implementation (with visualization) in Pascal language.

I am implement few my small idea:

`abmaze.pas` visit cells with even (x,y) only. In this case, odd cells will
be wall of maze. Also, i am not try to visit 100% of cells. IMHO, 50% is enough.

`abmaze2.pas` +disable make steps to visided cells during walk thru unvisided.

`abmaze3.pas` +teleport when stuck (instead start random walk by visited cells).

## Original algorithm description

1. Choose a cell. Any cell.
2. Choose a connected neighbor of the cell and travel to it.
   If the neighbor has not yet been visited, add the traveled edge
   to the spanning tree.
3. Repeat step 2 until all cells have been visited.

## Screenshot

![Screenshot: maze generation](https://github.com/DosWorld/abmaze/blob/master/ABMAZE.PNG?raw=true)

## Alorithm positive points

1. Too hard implement maze-solver (maze has a good random-level)
2. No visible artifacts
3. Simple implementation

## Alorithm negative points

1. Speed
2. Impossible generate infinity mazes
3. Speed became too slow (more and more) at end process

https://weblog.jamisbuck.org/2011/1/17/maze-generation-aldous-broder-algorithm

https://www.youtube.com/watch?v=-EZwuFdkJes

https://github.com/DosWorld/abmaze/

## License

MIT-0 (See LICENSE.TXT)

