package drcJS.types;

import drcJS.input.Gamepad;

typedef GamepadEvent = {

	var timestamp:Float;

	var gamepad:Gamepad;

	var index:UInt;
}