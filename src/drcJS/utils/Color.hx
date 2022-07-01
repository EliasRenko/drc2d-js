package drc.utils;

class Color {

	// ** Publics.
	
	public var a:Int;
	
	public var b:Int;
	
	public var g:Int;
	
	public var r:Int;
	
	public var value(get, set):Int;
	
	// ** Privates.
	
	/** @private **/ private var __value:Int;
	
	public function new(value:Int) {
        
		this.value = value;
	}
	
	public function getAlphaFloat():Float {

		return a / 255;
	}
	
	public function getBlueFloat():Float {

		return b / 255;
	}
	
	public function getGreenFloat():Float {

		return g / 255;
	}
	
	public function getRedFloat():Float {

		return r / 255;
	}
	
	private function __setAlpha():Void {

		a = (__value >> 24) & 0xff;
	}
	
	private function __setBlue():Void {

		b = __value & 0xff;
	}
	
	private function __setGreen():Void {

		g = (__value >> 8) & 0xff;
	}
	
	private function __setRed():Void {

		r = (__value >> 16) & 0xff;
	}
	
	// ** Getters and setters.
	
	private function get_value():Int {

		return __value;
	}
	
	private function set_value(value:Int):Int {

		__value = value;
		
		__setAlpha();
		
		__setBlue();
		
		__setGreen();
		
		__setRed();
		
		return value;
	}
}