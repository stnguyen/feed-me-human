package core;

/**
    A simple implementation of observer pattern
    
    @see https://en.wikipedia.org/wiki/Observer_pattern
**/
class Observable<T> {
    var observers = new List<T->Void>();

	public function new() {
    }
    
    /**
        Notify observers with the (possibly updated) data
    **/
    public function notify(data:T) {
        for (observer in observers) {
            observer(data);
        }
    }

    /**
        Add an observer
    **/
    public function addObserver(func:T->Void) {
        observers.push(func);
    }

    /**
        Remove an observer
    **/
    public function removeObserver(func:T->Void) {
        observers.remove(func);
    }
}