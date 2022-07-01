package drc.types;

@:enum abstract WindowEventType(UInt) from UInt to UInt {

	var ANY = 0;
	
	var SHOWN = 1;
	
	var HIDDEN = 2;
	
    var EXPOSED = 3;
    
    var MOVED = 4;

    var RESIZED = 5;

    var SIZE_CHANGED = 6;

    var MOUSE_ENTER = 7;

	var MOUSE_LEAVE = 8;

	var MINIMIZED = 9;
	
	var MAXIMIZED = 10;
	
	var RESTORED = 11;
	
	var ENTER = 12;
	
	var LEAVE = 13;
	
	var FOCUS_GAINED = 14;
	
	var FOCUS_LOST = 15;
	
	var CLOSE = 16;
}