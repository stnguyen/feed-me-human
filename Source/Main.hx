package;

import openfl.display.*;
import openfl.Assets;
import core.*;

class Main extends Sprite {
    var level = 1;

    public function new() {
        super();

        // Render order is important
        // later objects are rendered on top of previous ones
        var objects = [
            createBackground(),
            createBoard(),
            createForground(),
        ];
        for (obj in objects) addChild(obj);
    }

    function createBackground():DisplayObject {
        var fileName = level % 2 == 0 ? "day-background.jpg" : "night-background.jpg";
        var bitmap = new Bitmap(Assets.getBitmapData("assets/" + fileName));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = (stage.stageHeight - bitmap.height) / 2;
        return bitmap;
    }

    function createBoard():DisplayObject {
        var board = Board.random();
        trace('randomized board: $board');
        return new DisplayObject();
    }

    function createForground():DisplayObject {
        var bitmap = new Bitmap(Assets.getBitmapData("assets/sea-bottom.png"));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = stage.stageHeight - bitmap.height;
        return bitmap;
    }
}
