package drcJS.core;

import haxe.Timer;
import drcJS.core.Promise;
#if haxe4
import sys.thread.Deque;
import sys.thread.Thread;
#elseif cpp
import cpp.vm.Deque;
import cpp.vm.Thread;
#end

class Thread<T> extends Promise<T> {

    // ** Publics.

    public var threaded(get, null):Bool;

    // ** Privates.

    /** @private **/ private var __threaded:Bool = false;

    public var primary : sys.thread.Thread;

    public function new(func:((T)->Void, ()->Void, (Float)->Void)->Void, threaded:Bool = false, shoudlRun:Bool = true) {
        
        super(func, shoudlRun);

        __threaded = threaded;

        //queue = new Deque<((T)->Void, ()->Void)->Void>();
        //primary = sys.thread.Thread.current();

        //call_primary_ret(func);
        
        //run2();
    }

    override function run():Void {

        __time = Timer.stamp();

        if (__state == ON_QUEUE) {

            __state = PENDING;

            var thread = sys.thread.Thread.create(() -> {

                __funcToRun(__resolve, __reject, __advance);
            });

            //__funcToRun(__resolve, __reject);
        }
    }

    // ** Getters and setters.

    private function get_threaded():Bool {

        return __threaded;
    }
}