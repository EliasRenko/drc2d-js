package drcJS.utils;

import drcJS.core.Context;
import drcJS.system.Input;
import drcJS.backend.web.system.Window;
import drcJS.display.Stage;
import drc.utils.Resources;

class Common {

	//public static var app:App;

	public static var stage:Stage;

	public static var context:Context;
	
	public static var input:Input;

	public static var window:Window;

	public static var resources:Resources;

	public static function clamp(value:Float, max:Float, min:Float) {
		
		return Math.max(min, Math.min(max, value));
	}

	public static function roundWithPrecision(value:Float, ?precision = 2):Float {

		value = Math.round(value);

		value *= Math.pow(10, precision);

		return Math.round(value) / Math.pow(10, precision);
	}
}