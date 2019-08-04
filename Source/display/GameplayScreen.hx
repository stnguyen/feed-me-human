package display;

import openfl.events.MouseEvent;
import openfl.display.*;
import openfl.Assets;
import core.*;
import openfl.events.Event;
import managers.*;

class GameplayScreen extends Screen {
    static var BOARD_WIDTH_COVERAGE = 0.99;

    var board:Board;
    var boardSprite:BoardSprite;
    var fullBoardWidth:Float;
    var fullBoardHeight:Float;

    public function new() {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, added);
    }
    
    function added(event) {
        createBackground();
        createCat();
        createExitButton();

        startGame();
    }
    
    function startGame() {
        board = StorageManager.instance.storage.getSavedBoard();
        if (board == null) board = Board.random();

        boardSprite = createBoardSprite(board);
        fullBoardWidth = boardSprite.width;
        fullBoardHeight = boardSprite.height;
        
        addEventListener(MouseEvent.CLICK, handleMouseClick);
    }

    function handleMouseClick(event:MouseEvent) {
        trace('handleMouseClick: ${event.stageX}, ${event.stageY}');
        var localX = event.stageX - boardSprite.x;
        var localY = event.stageY - boardSprite.y;
        var row = Math.floor((localY / fullBoardHeight) * Board.NUM_ROWS);
        var col = Math.floor((localX / fullBoardWidth) * Board.NUM_COLS);
        if (board.isValidCoordinate(row, col)) {
            if (board.tryBlast(row, col)) {
                trace('board: $board');
                StorageManager.instance.storage.saveBoard(board);
            }
        }
    }

    function createBackground() {
        var fileName = Std.random(2) == 0 ? "day-background.jpg" : "night-background.jpg";
        var bitmap = new Bitmap(Assets.getBitmapData("assets/" + fileName));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = 0;
        addChild(bitmap);
    }

    function createCat() {
        var bitmap = new Bitmap(Assets.getBitmapData("assets/cat.png"));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = 30;
        addChild(bitmap);
    }

    function createBoardSprite(board:Board):BoardSprite {
        var boardSprite = new BoardSprite(board);
        boardSprite.scaleX = boardSprite.scaleY = BOARD_WIDTH_COVERAGE * stage.stageWidth / boardSprite.width;
        boardSprite.x = (stage.stageWidth - boardSprite.width) / 2;
        boardSprite.y = stage.stageHeight - boardSprite.height;
        addChild(boardSprite);
        return boardSprite;
    }

    function createExitButton() {
        var filename = "assets/button-exit.png";
        var up = new Bitmap(Assets.getBitmapData(filename));
        var over = new Bitmap(Assets.getBitmapData(filename));
        over.alpha = 0.9;
        var down = new Bitmap(Assets.getBitmapData(filename));
        down.alpha = 0.7;

        var button = new SimpleButton(up, over, down, up);
        button.x = 5;
        button.y = 5;
        button.addEventListener(MouseEvent.CLICK, handleExitClicked);
        addChild(button);
    }
    
    function handleExitClicked(event) {
        ScreenManager.instance.transitionToMainMenu();
    }
}
