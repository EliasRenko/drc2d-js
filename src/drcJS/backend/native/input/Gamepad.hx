package drc.backend.native.input;

import haxe.ds.Vector;
import drc.input.Device;
import drc.types.GamepadInputEvent;
//import sdl.Joystick;
//import sdl.SDL;
//import sdl.Haptic;

#if js

typedef GamepadData = js.html.Gamepad;

#elseif cpp

import sdl.SDL;

typedef GamepadData = sdl.Joystick;

#end

#if cpp

class Gamepad extends Device<GamepadInputEvent> {
	
	//** Publics.
	
	public var active(get, null):Bool;
	
	public var id(get, null):UInt;
	
	public var index(get, null):UInt;
	
	public var name(get, null):String;
	
	//** Private.
	
	/** @private **/ private var __active:Bool = false;
	
	/** @private **/ private var __index:UInt;
	
	/** @private **/ private var __sdlJoystick:GamepadData;
	
	public function new(index:UInt) {

		super();

		__index = index;
		
		__checkControls = new Vector(15);
		
		__pressControls = new Array<Int>();
		
		__releaseControls = new Array<Int>();
	}
	
	public function init():Void {
		
	}
	
	public function release():Void {
		
	}
	
	public function open(joystick:GamepadData):Int
	{
		__sdlJoystick = joystick;
		
		return id;
	}
	
	public function onButtonPress(control:Int):Void {

		__checkControls[control] = true;
		
		__checkCount ++;
		
		__pressControls[__pressCount ++] = control;
	}
	
	public function onButtonRelease(control:Int):Void {

		__checkControls[control] = false;
		
		__checkCount --;
		
		__releaseControls[__releaseCount ++] = control;
	}
	
	public function close():Void {
		
		SDL.joystickClose(__sdlJoystick);
	}
	
	// ** Getters and setters.
	
	private function get_active():Bool
	{
		return SDL.joystickGetAttached(__sdlJoystick);
	}
	
	private function get_id():UInt
	{
		return SDL.joystickInstanceID(__sdlJoystick);
	}

	private function get_index():UInt
	{
		return __index;
	}
	
	private function get_name():String
	{
		return __active ? SDL.joystickName(__sdlJoystick) : '';
	}
}

#end