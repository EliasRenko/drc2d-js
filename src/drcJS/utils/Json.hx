package drc.utils;

class Json {

	//** Publics.
	
	public var data(get, null):Dynamic;
	
	//** Privates.
	
	/** @private **/ private var __currentField:Dynamic = null;
	
	/** @private **/ private var __data:Dynamic;
	
	public function new(data:String) {

		__data = haxe.Json.parse(data);
	}
	
	public function field(name:String, defaultValue:Dynamic = null):Dynamic {

		var result:Dynamic;
		
		if (hasField(name)) {

			if (__currentField == null) {

				result = Reflect.field(__data, name);
				
				return result == null ? defaultValue : result;
			}
			
			result = Reflect.field(__currentField, name);
			
			return result == null ? defaultValue : result;
		}
		
		return defaultValue;
	}
	
	public function hasField(name:String):Bool {

		if (__currentField == null) {

			return Reflect.hasField(__data, name);
		}
		
		return Reflect.hasField(__currentField, name);
	}
	
	public function setField(name:String):Bool {

		var result:Dynamic = field(name);
		
		if (result == null) {

			return false;
		}
		
		__currentField = result;
		
		return true;
	}
	
	public function reset():Void {

		__currentField = null;
	}
	
	public function dispose():Void {
		
		__data = null;
		
		__currentField = null;
	}
	
	//** Getters and setters.
	
	private function get_data():Dynamic
	{
		return __data;
	}
}