package core;

import haxe.ds.Vector;

class Board {
    public static inline var NumRows = 10;
    public static inline var NumCols = 10;

    var cells : Vector<Vector<CellColor>>;

    public function new() {
        cells = new Vector(NumRows);
        for (r in 0...NumRows - 1) {
            cells[r] = new Vector(NumCols);
        }
    }

    public function toString():String {
        var buffer = new StringBuf();
        for (r in 0...NumRows - 1) {
            for (c in 0...NumCols - 1) {
                buffer.add(cells[r][c].getIndex());
            }
            if (r < NumRows - 1) buffer.add("\n");
        }
        return buffer.toString();
    }

    public static function random():Board {
        var board = new Board();
        for (r in 0...NumRows - 1) {
            for (c in 0...NumCols - 1) {
                board.cells[r][c] = CellColor.createByIndex(Std.random(CellColor.UpperBound.getIndex()));
            }
        }
        return board;
    }
}