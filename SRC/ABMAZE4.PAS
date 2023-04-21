(*****************************************************************************
Light modified Aldous-Broder algorithm for maze generation.

https://github.com/DosWorld/abmaze/

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
PROGRAM ABMaze4;

CONST
CELL_VISITED = ' '; (* cell is visited *)
CELL_UNVISIT = '#'; (* cell is not visited *)

(* maze dimension *)
WIDTH    = 76;
HEIGHT   = 20;
MAX_STEP = 3;
MIN_STEP = 2;

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

FUNCTION CheckBounds(x, y : INTEGER) : BOOLEAN;
BEGIN
        CheckBounds := (x >= 0) AND (x <= WIDTH) AND (y >= 0) AND (y <= HEIGHT);
END;

FUNCTION CalcNeib(x, y : INTEGER) : INTEGER;
VAR     r : INTEGER;
BEGIN
        r := 0;
        IF (x - MIN_STEP) >= 0 THEN IF maze[y][x - MIN_STEP] = CELL_UNVISIT THEN INC(r);
        IF (x + MIN_STEP) <= WIDTH THEN IF maze[y][x + MIN_STEP] = CELL_UNVISIT THEN INC(r);
        IF (y - MIN_STEP) >= 0 THEN IF maze[y - MIN_STEP][x] = CELL_UNVISIT THEN INC(r);
        IF (y + MIN_STEP) <= HEIGHT THEN IF maze[y + MIN_STEP][x] = CELL_UNVISIT THEN INC(r);
        CalcNeib := r;
END;

PROCEDURE Teleport(VAR x, y : INTEGER);
VAR     i, j : INTEGER;
BEGIN
        WHILE TRUE DO BEGIN
                j := Random((WIDTH + 1) SHR 1) SHL 1;
                i := Random((HEIGHT + 1) SHR 1) SHL 1;
                IF (maze[i][j] = CELL_VISITED) AND (CalcNeib(j, i) > 1) THEN BEGIN
                        y := i;
                        x := j;
                        EXIT;
                END;
        END;
END;

PROCEDURE GenerateMaze;
VAR     x , y, dx, dy, i : INTEGER;
        unvisited, total : INTEGER;
        isUnVis          : BOOLEAN;
        enough           : INTEGER;
        canStepToVis     : BOOLEAN;
        step             : INTEGER;
        d                : CHAR;
BEGIN
        total := (WIDTH * HEIGHT) SHR 1;
        canStepToVis := FALSE;

        (* Initial point *)
        x := Random((WIDTH + 1) SHR 1) SHL 1;
        y := Random((HEIGHT + 1) SHR 1) SHL 1;
        maze[y][x] := CELL_VISITED;

        unvisited := total;
        enough := 5 * total DIV 10; (* enough visit 50% of maze *)
        WHILE TRUE DO BEGIN
                (* One step *)
                CASE Random(4) OF
                0: BEGIN dx := 0;  dy := -1; d := '^'; END; (* UP *)
                1: BEGIN dx := 1;  dy := 0;  d := '>'; END; (* RIGHT *)
                2: BEGIN dx := 0;  dy := 1;  d := 'V'; END; (* DOWN *)
                3: BEGIN dx := -1; dy := 0;  d := '<'; END; (* LEFT *)
                END;
                step := 0;
                WHILE step = 0 DO step := (1 + Random(MAX_STEP)) AND $FE;
                IF NOT CheckBounds(x + dx * STEP, y + dy * STEP) THEN CONTINUE;
                IF NOT canStepToVis THEN BEGIN
                        canStepToVis := CalcNeib(x, y) = 0;
                        IF CalcNeib(x, y) = 0 THEN BEGIN
                                IF unvisited > enough THEN Teleport(x, y) ELSE BREAK;
                                canStepToVis := FALSE;
                                CONTINUE;
                        END;
                END;
                isUnVis := maze[y + dy * STEP][x + dx * STEP] = CELL_UNVISIT;
                IF (NOT canStepToVis) AND (NOT isUnVis) THEN CONTINUE;
                FOR i := 1 TO STEP DO BEGIN
                        INC(x, dx);
                        INC(y, dy);
                        IF isUnVis THEN maze[y][x] := CELL_VISITED;
                END;
                IF isUnVis THEN DEC(unvisited);
                IF isUnVis THEN canStepToVis := FALSE;
                (* Visualization *)
                Write(CHR(27), '[0;0H'); (* Cursor to position 0:0 *)
                Write(CHR(27), '[3',CHR($35),'m');
                Writeln('ALDOUS-BRODER MAZE (modified)');
                Write(CHR(27), '[3',CHR($36),'m');
                WriteLn(unvisited, '/', enough, ':', total
                        , CHR(9), 'x:', x:4
                        , CHR(9), 'y:', y:4
                        , CHR(9), 'direction: ', d
                        , '   ');
                Write(CHR(27), '[3',CHR($37),'m');
                WriteMaze(x, y);
        END;
END;

BEGIN
        Randomize;
        Write(CHR(27), '[2J'); (* Clear screen *)
        ClearMaze;
        GenerateMaze;
END.
