package drc.types;

import drc.input.Gamepad;

typedef GamepadEvent = {

	var timestamp:Float;

	var gamepad:Gamepad;

	var index:UInt;
}