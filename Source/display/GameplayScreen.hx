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
    var gameOver = false;

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
        
        addEventListener(MouseEvent.CLICK, handleMouseClick);
    }

    function handleMouseClick(event:MouseEvent) {
        if (gameOver) return;

        var localX = event.stageX - boardSprite.x;
        var localY = event.stageY - boardSprite.y;
        var row = Math.floor((localY / boardSprite.fullHeight) * Board.NUM_ROWS);
        var col = Math.floor((localX / boardSprite.fullWidth) * Board.NUM_COLS);
        if (board.isValidCoordinate(row, col)) {
            if (board.tryBlast(row, col)) {
                trace('board: $board');
                if (board.isDeadEnd()) {
                    StorageManager.instance.storage.saveBoard(null);
                    handleDeadEnd();
                } else {
                    StorageManager.instance.storage.saveBoard(board);
                }
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
        bitmap.y = 60;
        addChild(bitmap);
    }

    function createBoardSprite(board:Board):BoardSprite {
        var boardSprite = new BoardSprite(board);
        boardSprite.scaleX = boardSprite.scaleY = BOARD_WIDTH_COVERAGE * stage.stageWidth / boardSprite.fullWidth;
        boardSprite.x = (stage.stageWidth - boardSprite.fullWidth) / 2;
        boardSprite.y = stage.stageHeight - boardSprite.fullHeight;
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
        button.x = 10;
        button.y = 10;
        button.addEventListener(MouseEvent.CLICK, handleExitClicked);
        addChild(button);
    }
    
    function handleExitClicked(event) {
        ScreenManager.instance.transitionToMainMenu();
    }
    
    function handleDeadEnd() {
        if (gameOver) return;

        gameOver = true;

        var bitmap = new Bitmap(Assets.getBitmapData("assets/gameover.png"));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = (stage.stageHeight - bitmap.height) / 2;
        addChild(bitmap);
    }
}
