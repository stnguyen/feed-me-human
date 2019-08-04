package managers;

import persistence.IStorage;

class StorageManager {
    public static var instance(default, null):StorageManager;

    public static function setup(storage:IStorage) {
        instance = new StorageManager(storage);
    }
    
    public var storage(default, null):IStorage;
    
    private function new(storage:IStorage) {
        this.storage = storage;
    }
}