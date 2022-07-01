package drc.backend.native.input;

import sdl.SDL;
import drc.input.Device;
import drc.input.Mouse;
import haxe.ds.Vector;

class Mouse extends Device {

	// ** Publics.

	public var active(get, null):Bool;

	public var doubleClick(get, null):Bool;

	public var hasMoved(get, null):Bool;

	public var x(get, null):Int;

	public var y(get, null):Int;

	// ** Privates.

	/** @private **/ private var __active:Bool = false;

	/** @private **/ private var __doubleClick:Bool = false;

	/** @private **/ private var __hasMoved:Bool = false;

	/** @private **/ private var __x:Int = 0;

	/** @private **/ private var __y:Int = 0;

	public function new() {

		__checkControls = new Vector(4);

		__pressControls = new Array<Int>();

		__releaseControls = new Array<Int>();
	}

	public function onMove(x:Int, y:Int):Void {

		__x = x;

		__y = y;

		__hasMoved = true;
	}

	public function onButtonPress(control:Int, clicks:Int):Void {

		__checkControls[control] = true;

		__checkCount++;

		__pressControls[__pressCount++] = control;

		if (clicks > 1) {

			__doubleClick = true;
		}
	}

	public function onButtonRelease(control:Int):Void {

		__checkControls[control] = false;

		__checkCount--;

		__releaseControls[__releaseCount++] = control;
	}

	public function showCursor(value:Bool):Void {

		if (value) {

			SDL.showCursor(1);
		}
		else {

			SDL.showCursor(0);
		}
	}

	override public function postUpdate():Void {

		super.postUpdate();

		__doubleClick = false;

		__hasMoved = false;
	}

	// ** Getters and setters.

	private function get_active():Bool {

		return true;
	}

	private function get_doubleClick():Bool {

		return __doubleClick;
	}

	private function get_hasMoved():Bool {

		return __hasMoved;
	}

	private function get_x():Int {

		return __x;
	}

	private function get_y():Int {

		return __y;
	}
}
