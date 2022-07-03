package drcJS.debug;

class Log {
	
	public static function print(value:Dynamic):Void {

		#if debug

		trace(value);

		#end
	}
}