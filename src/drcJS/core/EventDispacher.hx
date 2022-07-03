package drcJS.core;

class EventDispacher<T> {
	
	// ** Privates
	
	/** @private **/ private var __listeners:Array<Listener<T>> = new Array<Listener<T>>();
	
	public function new() {}
	
	public function addEventListener(listener:T -> UInt -> Void, type:UInt = 0, priority:UInt = 0):Void {

		var eventListener:Listener<T> = {

			func: listener,

			type: type,
			
			priority: priority
		}
		
		for (i in 0...__listeners.length) {

			if (priority > __listeners[i].priority) {

				__listeners.insert(i, eventListener);
				
				return;
			}
		}
		
		__listeners.push(eventListener);
	}

	public function clearEventListeners():Void {

		var i:Int = __listeners.length - 1;

		while (i > -1) {

			__listeners.pop();

			i --;
		}
	}
	
	public function dispatchEvent(value:T, type:UInt = 0):Void {

		for (i in 0...__listeners.length) {

			if (__listeners[i].type == type || __listeners[i].type == 0) {

				__listeners[i].func(value, type);
			}
		}
	}
	
	public function hasEventListener(listener:T -> UInt -> Void):Bool {

		for (i in 0...__listeners.length) {

			if (Reflect.compareMethods(__listeners[i].func, listener)) return true;
		}
		
		return false;
	}
	
	public function removeEventListener(listener:T -> UInt -> Void):Void {

		var i:Int = __listeners.length - 1;

		while (i > -1) {

			if (Reflect.compareMethods(__listeners[i].func, listener)) {

				__listeners.splice(i, 1);
			}

			i --;
		}
	}
}

typedef Listener<T> = {
	
	var func:T -> Int -> Void;
	
	var type:UInt;

	var priority:UInt;
}