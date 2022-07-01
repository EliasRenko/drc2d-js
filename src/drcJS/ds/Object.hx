package drc.ds;

import drc.core.EventDispacher;

class Object extends EventDispacher<UInt> {
  
    public var active(get, null):Bool;

    // ** Getters and setters.

    private function get_active():Bool {

		return true;
	}
}