package;

import core.*;
import openfl.display.*;
import openfl.Assets;
import haxe.ds.Vector;

class BoardSprite extends Sprite {
    var board:Board;
    var cells:Vector<Vector<Bitmap>>;

    public function new(board:Board) {
        super();
        this.board = board;

        createCells();
    }

    function createCells() {
        cells = new Vector(Board.NumRows);
        for (r in 0...Board.NumRows) {
            cells[r] = new Vector(Board.NumCols);

            for (c in 0...Board.NumCols) {
                // TODO use pools
                var color = board.getCellColor(r, c);
                var bitmap = color == CellColor.Empty ? new Bitmap() : new Bitmap(Assets.getBitmapData(cellFileName(color)));
                bitmap.smoothing = true;
                bitmap.x = bitmap.width * c;
                bitmap.y = bitmap.height * r;
                addChild(bitmap);

                cells[r][c] = bitmap;
            }
        }
    }

    function cellFileName(cellColor:CellColor) {
        return 'assets/cell-${cellColor.getName().toLowerCase()}.png';
    }
}