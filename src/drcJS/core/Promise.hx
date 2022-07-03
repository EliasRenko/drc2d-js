package drcJS.core;

import haxe.Timer;
import drcJS.types.PromiseEventType;

class Promise<T> extends EventDispacher<Promise<T>> {

    // ** Publics.

    public var isComplete(get, null):Bool;

    public var state(get, null):PromiseState;

    public var result(get, null):T;

    public var progress(get, null):Float;

    public var time(get, null):Float;

    // ** Privates.

    /** @private **/ private var __completeListeners:EventDispacher<T>;

    /** @private **/ private var __isComplete:Bool = false;

    /** @private **/ private var __state:PromiseState = ON_QUEUE;

    /** @private **/ private var __result:T;

    /** @private **/ private var __progress:Float = 0;

    /** @private **/ private var __queuedPromise:Promise<T>;

    /** @private **/ private var __funcToRun:((T)->Void, ()->Void, (Float)->Void)->Void;

    /** @private **/ private var __time:Float = 0;

    public function new(func:((T)->Void, ()->Void, (Float)->Void)->Void, shoudlRun:Bool = true) {

        super();

        __funcToRun = func;

        if (shoudlRun) {
            
            run();
        }
    }

    public function run():Void {

        __time = Timer.stamp();

        if (__state == ON_QUEUE) {

            __state = PENDING;

            __funcToRun(__resolve, __reject, __advance);
        }
    }

    public static function all<U>(promises:Array<Promise<U>>):Promise<Array<U>> {

        var _count:Int = 0;

        var _results:Array<U> = [];

        return new Promise<Array<U>>(function(resolve, reject, advance) {
        
            var _resolve = function(index:Int, promise:Promise<U>):Void {

                _count ++;

                _results[index] = promise.result;

                if (_count == promises.length) {

                    resolve(_results);
                }
            }

            var _reject = function():Void {

                throw "Promise rejected!";
            }

            for (i in 0...promises.length) {

                //promises[i].then(_resolve, _reject)

                if (promises[i] == null) {

                    _resolve(i, null);

                    continue;
                }

                promises[i].onComplete(function(promise:Promise<U>, type:UInt) {

                    _resolve(i, promise);
                });

                // ** On error.

            }

            //resolve(new Array<U>());
        });
    }

    public function onComplete(listener:(Promise<T>, UInt)->Void):Promise<T> {

        if (listener == null) return this;

        if (__state == COMPLETE) {

            listener(this, 0);

            if (__queuedPromise != null) {

                __queuedPromise.run();
            }
        }
        else if (__state == PENDING) {

            if (__completeListeners == null) {

                __completeListeners = new EventDispacher();
            }

            addEventListener(listener, PromiseEventType.COMPLETE);
        }

        return this;
    }

    public function onReject(listener:(Promise<T>, UInt)->Void):Promise<T> {

        if (listener == null) return this;

        return this;
    }

    public function onProgress(listener:(Promise<T>, UInt)->Void):Promise<T> {

        if (listener == null) return this;

        addEventListener(listener, PromiseEventType.PROGRESS);

        return this;
    }

    public function then<U>(func:((T)->Void, ()->Void, (Float)->Void)->Void):Promise<T> {

        // func:((T)->Void, ()->Void)->Void

        // public function then<U>(func:(T)->Promise<U>):Promise<U> {

        switch(__state) {

            case COMPLETE:

                return new Promise<T>(func);

            case PENDING:

                return __queuedPromise = new Promise<T>(func, false);

            case REJECTED:

                return null;

            case _:

                throw 'ERROR';
        }
    }

    @:noCompletion
    private function __resolve(result:T):Void {

        __time = Timer.stamp() - __time;

        __state = COMPLETE;

        __isComplete = true;

        __result = result;

        dispatchEvent(this, PromiseEventType.COMPLETE);
    }

    @:noCompletion
    private function __reject():Void {

        __time = Timer.stamp() - __time;

        __state = COMPLETE;

        __isComplete = true;

        dispatchEvent(this, PromiseEventType.FAILED);
    }

    @:noCompletion
    private function __advance(value:Float):Void {

        __progress = value;
        
        dispatchEvent(this, PromiseEventType.PROGRESS);
    }

    // ** Getters and setters.

    private function get_isComplete():Bool {

        return __isComplete;
    }

    private function get_state():PromiseState {

        return __state;
    }

    private function get_result():T {
        
        return __result;
    }

    private function get_time():Float {

        return __time;
    }

    private function get_progress():Float {
        
        return __progress;
    }
}

@:enum
abstract PromiseState(Int) from Int to Int {
        
    var ON_QUEUE = 0;

    var PENDING = 1;
        
    var COMPLETE = 2;
        
    var REJECTED = 3;
}