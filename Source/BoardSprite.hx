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
        
        board.onCellRemoved.addObserver(handleCellRemoved);
        board.onCellMoved.addObserver(handleCellMoved);

        createCells();
    }

    function createCells() {
        cells = new Vector(Board.NUM_ROWS);
        for (r in 0...Board.NUM_ROWS) {
            cells[r] = new Vector(Board.NUM_COLS);

            for (c in 0...Board.NUM_COLS) {
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
    
    function handleCellRemoved(coor:Coordinate) {
        var bitmap = cells[coor.row][coor.col];
        removeChild(bitmap);
        cells[coor.row][coor.col] = null;
    }

    function handleCellMoved(movement:{ from:Coordinate, to:Coordinate }) {
        var bitmap = cells[movement.from.row][movement.from.col];
        bitmap.x = bitmap.width * movement.to.col;
        bitmap.y = bitmap.height * movement.to.row;
        cells[movement.to.row][movement.to.col] = bitmap;
        cells[movement.from.row][movement.from.col] = null;
    }
}