package core;

import haxe.ds.Vector;

typedef Coordinate = { row:Int, col:Int }
class Board {
    public static inline var NumRows = 10;
    public static inline var NumCols = 10;

    static var NeighborCoordinateDeltas = [ [0,1], [0,-1], [1, 0], [-1, 0] ];
    
    var cellColors:Vector<Vector<CellColor>>;

    public function new() {
        cellColors = new Vector(NumRows);
        for (r in 0...NumRows - 1) {
            cellColors[r] = new Vector(NumCols);
        }
    }

    public function getCellColor(row:Int, col:Int):CellColor {
        validateCoordinate(row, col);
        return cellColors[row][col];
    }

    public function tryBlast(row:Int, col:Int):Bool {
        var connectedCells = floodFill(row, col);
        trace('tryBlast($row, $col): color is ${getCellColor(row, col)}, connected cells: $connectedCells');
        if (connectedCells.length < 2) return false;
        return true;
    }

    public function toString():String {
        var buffer = new StringBuf();
        for (r in 0...NumRows - 1) {
            // Always put a new line on top to avoid breaking layout
            buffer.add("\n");

            for (c in 0...NumCols - 1) {
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
        for (r in 0...NumRows - 1) {
            for (c in 0...NumCols - 1) {
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

    function floodFill(row:Int, col:Int):Array<Coordinate> {
        var color = getCellColor(row, col);
        var connectedCoors = new Array<Coordinate>();
        var processingCoors = new Array<Coordinate>();
        // A Set would be more optimal, but it's not built-in
        var visitedLookup = new Map<Int, Bool>();

        // Start at the given corodinate
        processingCoors.push({ row: row, col: col });
        visitedLookup.set(hashCoordinate(row, col), true);

        while (processingCoors.length > 0) {
            var coor = processingCoors.pop();
            if (color == getCellColor(coor.row, coor.col)) {
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
    
    function hashCoordinate(row:Int, col:Int):Int {
        return row * 100 + col;
    }
}