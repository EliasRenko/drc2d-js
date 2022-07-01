package drc.types;

@:enum abstract GamepadEventType(Null<Int>) from Int to Int
{
	var UNKNOWN = 0;
	
	var ADDED = 1;
	
	var REMOVED = 2;
	
	var PRESSED = 3;
	
	var RELEASED = 4;
	
	var REMAPPED = 5;
	
	@:from private static function fromString(value:String):GamepadEventType
	{
		return switch (value)
		{
			case "unknown": UNKNOWN;
			
			case "added": ADDED;
			
			case "removed": REMOVED;
			
			case "pressed": PRESSED;
			
			case "released": RELEASED;
			
			case "remaped": REMAPPED;
			
			default: null;
		}
	}
	
	@:to private function toString():String
	{
		return switch (cast this : GamepadEventType)
		{
			case GamepadEventType.UNKNOWN: "unknown";
			
			case GamepadEventType.ADDED: "added";
			
			case GamepadEventType.REMOVED: "removed";
			
			case GamepadEventType.PRESSED: "pressed";
			
			case GamepadEventType.RELEASED: "released";
			
			case GamepadEventType.REMAPPED: "remapped";
			
			default: null;
		}
	}
}
	