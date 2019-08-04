package display;

import openfl.display.*;
import openfl.Assets;
import openfl.events.MouseEvent;
import openfl.events.Event;
import managers.*;

class MainMenuScreen extends Screen {
    public function new() {
        super();
        
        addEventListener(Event.ADDED_TO_STAGE, added);
    }
    
    function added(event) {
        createBackground();
        createPlayButtons();
    }
    
    function createPlayButtons() {
        if (StorageManager.instance.storage.hasSavedBoard()) {
            createResumeButton();
        }

        createNewGameButton();
    }

    function createBackground() {
        var bitmap = new Bitmap(Assets.getBitmapData("assets/mainmenu-background.jpg"));
        bitmap.x = (stage.stageWidth - bitmap.width) / 2;
        bitmap.y = 0;
        addChild(bitmap);
    }
    
    function createNewGameButton() {
        var filename = "assets/button-new-game.png";
        var up = new Bitmap(Assets.getBitmapData(filename));
        var over = new Bitmap(Assets.getBitmapData(filename));
        over.alpha = 0.9;
        var down = new Bitmap(Assets.getBitmapData(filename));
        down.alpha = 0.7;

        var button = new SimpleButton(up, over, down, up);
        button.x = (stage.stageWidth - button.width) / 2;
        button.y = (stage.stageHeight - button.height) / 2;
        button.addEventListener(MouseEvent.CLICK, handleNewGameClicked);
        addChild(button);
    }
    
    function handleNewGameClicked(event) {
        StorageManager.instance.storage.saveBoard(null);
        ScreenManager.instance.transitionToGameplay();
    }

    function createResumeButton() {
        var filename = "assets/button-resume.png";
        var up = new Bitmap(Assets.getBitmapData(filename));
        var over = new Bitmap(Assets.getBitmapData(filename));
        over.alpha = 0.9;
        var down = new Bitmap(Assets.getBitmapData(filename));
        down.alpha = 0.7;

        var button = new SimpleButton(up, over, down, up);
        button.x = (stage.stageWidth - button.width) / 2;
        button.y = (stage.stageHeight - button.height) / 2 - 40;
        button.addEventListener(MouseEvent.CLICK, handleResumeClicked);
        addChild(button);
    }
    
    function handleResumeClicked(event) {
        ScreenManager.instance.transitionToGameplay();
    }
}
