package;

import openfl.display.*;
import openfl.Assets;
import core.*;

class Main extends Sprite {
    var level = 1;

    public function new() {
        super();
        createBackground();
        createBoard();
    }

    function createBackground() {
        var fileName = level % 2 == 0 ? "day-background.jpg" : "night-background.jpg";
        var bitmap = new Bitmap(Assets.getBitmapData("assets/" + fileName));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = (stage.stageHeight - bitmap.height) / 2;
        addChild(bitmap);
    }

    function createBoard() {
        var board = Board.random();
        trace('randomized board: $board');
        var boardSprite = new BoardSprite(board);
        boardSprite.x = (stage.stageWidth - boardSprite.width) / 2;
        boardSprite.y = stage.stageHeight - boardSprite.height;
        addChild(boardSprite);
    }
}
