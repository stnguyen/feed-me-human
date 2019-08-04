package core;

class Observable<T> {
    var observers = new List<T->Void>();

	public function new() {
    }
    
    public function notify(data:T) {
        for (observer in observers) {
            observer(data);
        }
    }

    public function addObserver(func:T->Void) {
        observers.push(func);
    }

    public function removeObserver(func:T->Void) {
        observers.remove(func);
    }
}