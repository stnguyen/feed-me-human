package;

import openfl.display.Sprite;
import managers.*;
import display.MainMenuScreen;
import persistence.LocalStorage;

class Main extends Sprite {
    public function new() {
        super();
        
        // Setup order is important
        StorageManager.setup(new LocalStorage());
        ScreenManager.setup(this);
        ScreenManager.instance.transitionToMainMenu();
    }
}
