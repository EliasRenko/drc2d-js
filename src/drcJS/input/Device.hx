package drc.input;

import drc.core.EventDispacher;
import haxe.ds.Vector;

class Device<T> extends EventDispacher<T>{

	//** Privates.
	
	/** @private */ private var __controlsCount:Int;
	
	/** @private */ private var __checkCount:Int = 0;
	
	/** @private */ private var __pressCount:Int = 0;
	
	/** @private */ private var __releaseCount:Int = 0;
	
	/** @private */ private var __checkControls:Vector<Bool>;
	
	/** @private */ private var __pressControls:Array<Int>;
	
	/** @private */ private var __releaseControls:Array<Int>;
	
	
	public function check(control:Int):Bool{

		return control < 0 ? __checkCount > 0 : __checkControls[control];
	}
	
	public function pressed(control:Int):Bool {

		return control < 0 ? __pressCount > 0 : __pressControls.indexOf(control) >= 0;
	}
	
	public function released(control:Int):Bool {

		return control < 0 ? __releaseCount > 0 : __releaseControls.indexOf(control) >= 0;
	}
	
	private function __indexOf(vector:Array<Int>, index:Int):Int {

		for (i in 0...vector.length) {

			if (vector[i] == index) {

				return i;
			}
		}
		
		return -1;
	}
	
	public function postUpdate():Void {

		// ** Clear every pressed control for the next frame.
		
		while (__pressCount > 0) {

			__pressControls[-- __pressCount] = -1;
		}
		
		// ** Clear every released control for the next frame.
		
		while (__releaseCount > 0) {
			
			__releaseControls[-- __releaseCount] = -1;
		}
	}
}