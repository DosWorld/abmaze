(*****************************************************************************
Aldous-Broder algorithm for maze generation.

Description:
1. Choose a cell. Any cell.
2. Choose a connected neighbor of the cell and travel to it.
   If the neighbor has not yet been visited, add the traveled edge
   to the spanning tree.
3. Repeat step 2 until all cells have been visited.

Alorithm positive side:
1. Too hard implement maze-solver (maze has a good random-level)
2. No visible artifacts
3. Simple implementation

Alorithm negative side:
1. Speed
2. Impossible generate infinity mazes
3. Speed became too slow (more and more) at end process

https://weblog.jamisbuck.org/2011/1/17/maze-generation-aldous-broder-algorithm
https://www.youtube.com/watch?v=-EZwuFdkJes

I am implement my small idea: visit points with even (x,y) only.
In this case, odd cells will be wall of maze.

******************************************************************************

MIT No Attribution

Copyright 2023 Viacheslav Komenda

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*****************************************************************************)
PROGRAM ABMaze;

CONST
CELL_VISITED = ' '; (* cell is visited *)
CELL_UNVISIT = '#'; (* cell is not visited *)

(* maze dimension *)
WIDTH = 70;
HEIGHT = 20;

VAR
maze : ARRAY[0..HEIGHT, 0..WIDTH] OF CHAR;

PROCEDURE ClearMaze;
BEGIN
        FillChar(maze, SizeOf(maze), CELL_UNVISIT);
END;

PROCEDURE WriteMaze(xs, ys : INTEGER);
VAR
        x, y : INTEGER;
BEGIN
        Write('+');
        FOR x := 0 TO WIDTH DO Write('-');
        WriteLn('+');
        FOR y := 0 TO HEIGHT DO BEGIN
                Write('|');
                FOR x := 0 TO WIDTH DO BEGIN
                        IF (x = xs) AND (y = ys) THEN
                                Write(CHR(27), '[3',CHR($33),'m@',CHR(27), '[3',CHR($37),'m')
                        ELSE Write(maze[y][x]);
                END;
                WriteLn('|');
        END;
        Write('+');
        FOR x := 0 TO WIDTH DO Write('-');
        WriteLn('+');
END;

PROCEDURE GenerateMaze;
VAR     x , y, dx, dy, d : INTEGER;
        unvisited, total : INTEGER;
        isunvis          : BOOLEAN;
        enough           : INTEGER;
BEGIN
        total := (WIDTH * HEIGHT) SHR 1;

        (* Initial point *)
        x := Random((WIDTH + 1) SHR 1) SHL 1;
        y := Random((HEIGHT + 1) SHR 1) SHL 1;
        maze[y][x] := CELL_VISITED;

        unvisited := total;
        enough := 5 * total DIV 10; (* enough visit 50% of maze *)
        WHILE unvisited > enough DO BEGIN
                (* One step *)
                d := Random(4);
                Write(CHR(27), '[0;0H'); (* Cursor to position 0:0 *)
                Write(CHR(27), '[3',CHR($35),'m');
                Writeln('ALDOUS-BRODER MAZE');
                Write(CHR(27), '[3',CHR($36),'m');
                WriteLn(unvisited, '/', enough, ':', total
                        , ', x: ', x
                        , ', y: ', y
                        , ', direction: ', d
                        , '   ');
                Write(CHR(27), '[3',CHR($37),'m');
                WriteMaze(x, y);
                CASE d OF
                0: BEGIN dx := 0;  dy := -1; END; (* UP *)
                1: BEGIN dx := 1;  dy := 0;  END; (* RIGHT *)
                2: BEGIN dx := 0;  dy := 1;  END; (* DOWN *)
                3: BEGIN dx := -1; dy := 0;  END; (* LEFT *)
                END;
                IF (x + dx * 2 >= 0) AND (x + dx * 2 <= WIDTH) AND
                   (y + dy * 2 >= 0) AND (y + dy * 2 <= HEIGHT) THEN BEGIN
                        isunvis := maze[y + dy * 2][x + dx * 2] = CELL_UNVISIT;
                        FOR d := 1 TO 2 DO BEGIN
                                INC(x, dx);
                                INC(y, dy);
                                IF isunvis THEN maze[y][x] := CELL_VISITED;
                        END;
                        IF isunvis THEN DEC(unvisited);
                END;
        END;
END;

BEGIN
        Randomize;
        Write(CHR(27), '[2J'); (* Clear screen *)
        ClearMaze;
        GenerateMaze;
END.
