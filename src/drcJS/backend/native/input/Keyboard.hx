package drc.backend.native.input;

import haxe.ds.Vector;
import drc.input.Device;

class Keyboard extends Device implements drc.input.Keyboard {

    // ** Publics.

    public var active(get, null):Bool;

    // ** Privates.

    private var __active:Bool = false;

    public function new() {

        __checkControls = new Vector(284);

		__pressControls = new Array<Int>();

		__releaseControls = new Array<Int>();
    }

    public function onButtonPress(control:Int):Void {

        __checkControls[control] = true;

		__checkCount++;

		__pressControls[__pressCount++] = control;
    }

    public function onButtonRelease(control:Int):Void {

        __checkControls[control] = false;

		__checkCount--;

		__releaseControls[__releaseCount++] = control;
    }

    // ** Getters and setters.

    private function get_active():Bool {

        return __active;
    }
}