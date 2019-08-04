package core;

import haxe.ds.Vector;

typedef Coordinate = { row:Int, col:Int }

/**
    Board state

    Coordinates increase from top left (0, 0) to bottom right (NumRows, NumCols)
**/
class Board {
    public static inline var NumRows = 10;
    public static inline var NumCols = 10;
    public static inline var CoordinateHashRowMultiplier = 100;

    static var NeighborCoordinateDeltas = [ [0,1], [0,-1], [1, 0], [-1, 0] ];
    
    var cellColors:Vector<Vector<CellColor>>;

    public function new() {
        cellColors = new Vector(NumRows);
        for (r in 0...NumRows) {
            cellColors[r] = new Vector(NumCols);
        }
    }

    public function getCellColor(row:Int, col:Int):CellColor {
        validateCoordinate(row, col);
        return cellColors[row][col];
    }

    public function tryBlast(row:Int, col:Int):Bool {
        validateCoordinate(row, col);

        var blastingCoors = floodFill(row, col);
        trace('tryBlast($row, $col): color is ${cellColors[row][col]}, blasting: ${blastingCoors}');
        
        if (blastingCoors.length < 2) return false;

        var blastingCoorLookup = new Map<Int, Bool>();
        for (coor in blastingCoors) {
            // TODO notify removal
            blastingCoorLookup.set(hashCoordinate(coor.row, coor.col), true);
        }

        collapse(blastingCoorLookup);

        return true;
    }
    
    public function toString():String {
        var buffer = new StringBuf();
        for (r in 0...NumRows) {
            // Always put a new line on top to avoid breaking layout
            buffer.add("\n");

            for (c in 0...NumCols) {
                buffer.add(cellColors[r][c].getName().charAt(0).toLowerCase());
            }
        }
        return buffer.toString();
    }

    public static function random():Board {
        var board = new Board();

        var lowerBound = CellColor.Empty.getIndex() + 1;
        var upperBound = CellColor.UpperBound.getIndex() - 1;
        var randRange = upperBound - lowerBound;
        for (r in 0...NumRows) {
            for (c in 0...NumCols) {
                var randIndex = lowerBound + Std.random(randRange);
                board.cellColors[r][c] = CellColor.createByIndex(randIndex);
            }
        }
        return board;
    }

    function validateCoordinate(row:Int, col:Int) {
        if (!isValidCoordinate(row, col)) throw 'Invalid board coordinate: $row, $col';
    }

    function isValidCoordinate(row:Int, col:Int):Bool {
        return !(row < 0 || row >= NumRows || col < 0 || col >= NumCols);
    }

    /** Find connected (same color) cells with the given cell coordinate **/
    function floodFill(row:Int, col:Int):Array<Coordinate> {
        var color = cellColors[row][col];
        var connectedCoors = new Array<Coordinate>();
        var processingCoors = new Array<Coordinate>();
        // A Set would be more optimal, but it's not built-in
        var visitedLookup = new Map<Int, Bool>();

        // Start at the given corodinate
        processingCoors.push({ row: row, col: col });
        visitedLookup.set(hashCoordinate(row, col), true);

        while (processingCoors.length > 0) {
            var coor = processingCoors.pop();
            if (color == cellColors[coor.row][coor.col]) {
                connectedCoors.push(coor);
                
                // Check surrounding cells
                for (delta in NeighborCoordinateDeltas) {
                    var neighborRow = coor.row + delta[0];
                    var neighborCol = coor.col + delta[1];
                    var hashCode = hashCoordinate(neighborRow, neighborCol);
                    if (isValidCoordinate(neighborRow, neighborCol) && !visitedLookup.exists(hashCode)) {
                        processingCoors.push({ row: neighborRow, col: neighborCol });
                        visitedLookup.set(hashCode, true);
                    }
                }
            }
        }
        return connectedCoors;
    }
    
    /** Collapse the board, remove empty columns (shift left), in linear time **/
    function collapse(blastingCoorLookup:Map<Int, Bool>) {
        // First, collapse down
        for (c in 0...NumCols) {
            var numCollapsed = 0;
            for (rTopdown in 0...NumRows) {
                var r = NumRows - rTopdown - 1;

                if (cellColors[r][c] == CellColor.Empty) break;

                if (blastingCoorLookup.exists(hashCoordinate(r, c))) {
                    numCollapsed++;
                    cellColors[r][c] = CellColor.Empty;
                } else if (numCollapsed > 0) {
                    // TODO notify cell movement
                    cellColors[r + numCollapsed][c] = cellColors[r][c];
                    cellColors[r][c] = CellColor.Empty;
                }
            }
        }
        
        // Then, if there are empty columns, collapse to the left
        var numEmptyCols = 0;
        for (c in 0...NumCols) {
            if (cellColors[NumRows - 1][c] == CellColor.Empty) {
                numEmptyCols++;
            } else if (numEmptyCols > 0) {
                // Shift left
                for (r in 0...NumRows) {
                    cellColors[r][c - numEmptyCols] = cellColors[r][c];
                    cellColors[r][c] = CellColor.Empty;
                }
            }
        }
    }

    function hashCoordinate(row:Int, col:Int):Int {
        return row * CoordinateHashRowMultiplier + col;
    }
}