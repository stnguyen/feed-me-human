package persistence;

import core.Board;
import core.CellColor;
import haxe.ds.Vector;

class BoardSerializer {
    public static function serialize(board:Board):String {
        var stringBuf = new StringBuf();
        for (r in 0...Board.NUM_ROWS) {
            for (c in 0...Board.NUM_COLS) {
                stringBuf.add(board.getCellColor(r, c).getIndex());
            }
        }
        return stringBuf.toString();
    }
    
    public static function deserialize(serializedBoard:String):Board {
        // Verify first
        // Exactly (NUM_ROWS * NUM_COLS) digits in range [CellColor.Empty, CellColor.UpperBound)
        var regexStr = '[${CellColor.Empty.getIndex()}-${CellColor.UpperBound.getIndex() - 1}]{${Board.NUM_ROWS * Board.NUM_COLS}}';
        trace('regex: $regexStr');
        var regex = new EReg(regexStr, "");
        if (!regex.match(serializedBoard)) {
            trace('WARNING: Failed to deserialize due to invalid board string: $serializedBoard');
            return null;
        }

        var cellColors = new Vector<Vector<CellColor>>(Board.NUM_ROWS);
        for (r in 0...Board.NUM_ROWS) {
            cellColors[r] = new Vector<CellColor>(Board.NUM_COLS);
            for (c in 0...Board.NUM_COLS) {
                var idx = Std.parseInt(serializedBoard.charAt(r * Board.NUM_COLS + c));
                cellColors[r][c] = CellColor.createByIndex(idx);
            }
        }

        var board = new Board();
        board.load(cellColors);
        return board;
    }
}