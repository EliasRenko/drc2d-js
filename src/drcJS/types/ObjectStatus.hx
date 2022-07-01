package drc.types;

@:enum abstract ObjectStatus(Null<Int>)
{
	var UNKNOWN = 0;
	
	var NULL = 1;
	
	var ACTIVE = 2;
	
	var STATIC = 3;
	
	@:from private static function fromString(value:String):ObjectStatus
	{
		return switch (value)
		{
			case "unknown": UNKNOWN;
			
			case "null": NULL;
			
			case "active": ACTIVE;
			
			case "static": STATIC;
			
			default: null;
		}
	}
	
	@:to private function toString():String
	{
		return switch (cast this: ObjectStatus)
		{
			case ObjectStatus.UNKNOWN: "unknown";
			
			case ObjectStatus.NULL: "NULL";
			
			case ObjectStatus.ACTIVE: "ACTIVE";
			
			case ObjectStatus.STATIC: "STATIC";
			
			default: null;
		}
	}
}
	