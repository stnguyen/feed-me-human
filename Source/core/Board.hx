package core;

import haxe.ds.Vector;

/**
    Board state

    Coordinates increase from top left (0, 0) to bottom right (NUM_ROWS, NUM_COLS)
**/
class Board {
    public static var NUM_ROWS = 10;
    public static var NUM_COLS = 10;

    static var HASH_ROW_MULTIPLIER = 100;
    static var NEIGHBOR_DELTAS = [ [0,1], [0,-1], [1, 0], [-1, 0] ];
    
    public var onCellRemoved = new Observable<Coordinate>();
    public var onCellMoved = new Observable<{ from:Coordinate, to:Coordinate }>();
    
    var cellColors:Vector<Vector<CellColor>>;

    public function new() {
        cellColors = new Vector(NUM_ROWS);
        for (r in 0...NUM_ROWS) {
            cellColors[r] = new Vector(NUM_COLS);
        }
    }
    
    /**
        Override board state with the new one
    **/
    public function load(cellColors:Vector<Vector<CellColor>>) {
        for (r in 0...NUM_ROWS) {
            this.cellColors[r] = cellColors[r].copy();
        }
    }

    /**
        Check if given row and col make a valid coordinate
    **/
    public function isValidCoordinate(row:Int, col:Int):Bool {
        return !(row < 0 || row >= NUM_ROWS || col < 0 || col >= NUM_COLS);
    }

    /**
        Get current color of the cell at given coordinate
    **/
    public function getCellColor(row:Int, col:Int):CellColor {
        validateCoordinate(row, col);
        return cellColors[row][col];
    }

    /**
        Try blast the cell at given coordinate and its neighbors of the same color.
        
        Also collapse the board.
    **/
    public function tryBlast(row:Int, col:Int):Bool {
        validateCoordinate(row, col);

        var blastingCoors = floodFill(row, col);
        trace('tryBlast($row, $col): color is ${cellColors[row][col]}, connected cells: ${blastingCoors}');
        
        if (blastingCoors.length < 2) return false;

        var blastingCoorLookup = new Map<Int, Bool>();
        for (coor in blastingCoors) {
            blastingCoorLookup.set(hashCoordinate(coor.row, coor.col), true);
            onCellRemoved.notify(coor);
        }

        collapse(blastingCoorLookup);

        return true;
    }
    
    public function toString():String {
        var buffer = new StringBuf();
        for (r in 0...NUM_ROWS) {
            // Always put a new line on top to avoid breaking layout
            buffer.add("\n");

            for (c in 0...NUM_COLS) {
                var chr = cellColors[r][c].getName().charAt(0).toLowerCase();
                if (cellColors[r][c] == CellColor.Empty) chr = '-';
                buffer.add(chr);
            }
        }
        return buffer.toString();
    }

    /**
        Generate a random board with uniform distribution of colors
    **/
    public static function random():Board {
        var board = new Board();

        var lowerBound = CellColor.Empty.getIndex() + 1;
        var upperBound = CellColor.UpperBound.getIndex();
        var randRange = upperBound - lowerBound;
        for (r in 0...NUM_ROWS) {
            for (c in 0...NUM_COLS) {
                var randIndex = lowerBound + Std.random(randRange);
                board.cellColors[r][c] = CellColor.createByIndex(randIndex);
            }
        }
        return board;
    }

    /**
        Find cells of the same color with and include the given coordinate
    **/
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
                for (delta in NEIGHBOR_DELTAS) {
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
    
    /**
        Collapse the board down and remove empty columns by shifting left
    **/
    function collapse(blastingCoorLookup:Map<Int, Bool>) {
        // First, collapse down
        for (c in 0...NUM_COLS) {
            var numCollapsed = 0;
            for (rTopdown in 0...NUM_ROWS) {
                var r = NUM_ROWS - rTopdown - 1;

                if (cellColors[r][c] == CellColor.Empty) break;

                if (blastingCoorLookup.exists(hashCoordinate(r, c))) {
                    numCollapsed++;
                    cellColors[r][c] = CellColor.Empty;
                } else if (numCollapsed > 0) {
                    cellColors[r + numCollapsed][c] = cellColors[r][c];
                    cellColors[r][c] = CellColor.Empty;
                    
                    onCellMoved.notify({
                        from:   { row: r, col: c },
                        to:     { row: r + numCollapsed, col: c },
                    });
                }
            }
        }
        
        // Then, if there are empty columns, collapse to the left
        var numEmptyCols = 0;
        for (c in 0...NUM_COLS) {
            if (cellColors[NUM_ROWS - 1][c] == CellColor.Empty) {
                numEmptyCols++;
            } else if (numEmptyCols > 0) {
                // Shift left
                for (rTopdown in 0...NUM_ROWS) {
                    var r = NUM_ROWS - rTopdown - 1;
                    if (cellColors[r][c] == CellColor.Empty) break;

                    cellColors[r][c - numEmptyCols] = cellColors[r][c];
                    cellColors[r][c] = CellColor.Empty;

                    onCellMoved.notify({
                        from:   { row: r, col: c },
                        to:     { row: r, col: c - numEmptyCols },
                    });
                }
            }
        }
    }

    /**
        Calculate (unique) hash code for the given coordinate
    **/
    function hashCoordinate(row:Int, col:Int):Int {
        return row * HASH_ROW_MULTIPLIER + col;
    }

    /**
        Validate the given coordinate
        
        @throws exception if failed
    **/
    function validateCoordinate(row:Int, col:Int) {
        if (!isValidCoordinate(row, col)) throw 'Invalid board coordinate: $row, $col';
    }
}