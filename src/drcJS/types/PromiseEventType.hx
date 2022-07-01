package drc.types;

@:enum abstract PromiseEventType(UInt) from UInt to UInt {

	var ANY = 0;

    var COMPLETE = 1;

    var FAILED = 2;

    var PROGRESS = 3;
}