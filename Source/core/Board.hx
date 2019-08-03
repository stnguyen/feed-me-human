package core;

import haxe.ds.Vector;

class Board {
    public static inline var NumRows = 10;
    public static inline var NumCols = 10;

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
        var color = cellColors[row][col];
        return false;
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
        if (row < 0 || row >= NumRows || col < 0 || col >= NumCols) {
            throw 'Invalid board coordinate: $row, $col';
        }
    }
}