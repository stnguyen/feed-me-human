package;

import openfl.display.Sprite;
import managers.*;
import display.MainMenuScreen;
import persistence.SharedObjectStorage;

class Main extends Sprite {
    public function new() {
        super();
        
        // Setup order is important
        StorageManager.setup(new SharedObjectStorage());
        ScreenManager.setup(this);

        // Ready to rock & roll!
        ScreenManager.instance.transitionToMainMenu();
    }
}
