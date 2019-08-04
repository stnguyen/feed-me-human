package managers;

import openfl.display.Sprite;
import display.*;

class ScreenManager {
    public static var instance(default, null):ScreenManager;

    public static function setup(root:Sprite) {
        instance = new ScreenManager(root);
    }
    
    var root:Sprite;
    
    private function new(root:Sprite) {
        this.root = root;
    }
    
    public function transitionToGameplay() {
        replaceScreen(new GameplayScreen());
    }

    public function transitionToMainMenu() {
        replaceScreen(new MainMenuScreen());
    }
    
    function replaceScreen(screen:Screen) {
        root.removeChildren();
        root.addChild(screen);
    }
}