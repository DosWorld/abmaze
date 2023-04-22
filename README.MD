# Aldous-Broder algorithm for maze generation.

Here is algorithm implementation (with visualization) in Pascal language.
It could be compiled with Free Pascal and Turbo Pascal. Used only two
"non-standard" functions: `Randomize` and `Random`.

For visualization, used output
[ANSI-terminal escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code),
so it must works in DOS, Linux, MAC and Windows. (i am not yet check last two).

Has been implemented few small idea:

`abmaze.pas` visit cells with even coord (x,y) only. In this case, cells with
odd coord will be wall of maze. Also, i am not try to visit 100% of cells.
IMHO, 50% is enough (we have enough of maze and the rest 50% will consume
too mach time). This version is more near to original algorithm.

`abmaze2.pas` as prev, +disable make steps to visided cells during walk
thru unvisided.

`abmaze3.pas` as prev, +"teleport" when stuck (instead start random walk
by visited cells).

`abmaze4.pas` as prev, +random step length

Modifications `abmaze3.pas` and `abmaze4.pas` increase speed. So, make review
`abmaze.pas` as clean implementation and then try `abmaze3.pas` and
`abmaze4.pas`. IMHO, these modifications make it possible to use the
algorithm on computers of the IBM AT 286 class.

## Screenshot

Here is screenshot visualization:
![Screenshot: Maze generation](https://github.com/DosWorld/abmaze/blob/master/ABMAZE.PNG?raw=true)

## Original algorithm description

1. Choose any random cell. (it will be a start point)
2. Choose a connected neighbor of the cell and travel to it. If the this
neighbor has not yet been visited, make path between this two cells.
3. Repeat step 2 until all cells have been visited. (I am made limit to 50%)

### Alorithm positive points

1. Too hard implement maze-solver (maze has a good random-level)
2. No visible artifacts or patterns (like Sidewinder algorithm etc)
3. Simple implementation

### Alorithm negative points

1. Speed. Speed became too slow more and more, at end process. (I am try
to fix it in my modifications)
2. Impossible generate infinity mazes

## Links

https://weblog.jamisbuck.org/2011/1/17/maze-generation-aldous-broder-algorithm

[![Maze generation with Aldous-Broder algorithm](http://img.youtube.com/vi/-EZwuFdkJes/0.jpg)](http://www.youtube.com/watch?v=-EZwuFdkJes "Maze generation with Aldous-Broder algorithm")

https://github.com/DosWorld/abmaze/

https://en.wikipedia.org/wiki/Maze_generation_algorithm

https://github.com/topics/aldous-broder

## License

MIT-0 (See LICENSE.TXT). Free as wind and sky.

