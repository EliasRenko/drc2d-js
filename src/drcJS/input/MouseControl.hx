package drc.input;

@:enum abstract MouseControl(Int) from Int to Int {
	
	var ANY = -1;

	var MOTION = 0;

	var LEFT_CLICK = 1;
	
	var MIDDLE_CLICK = 2;
	
	var RIGHT_CLICK = 3;
}