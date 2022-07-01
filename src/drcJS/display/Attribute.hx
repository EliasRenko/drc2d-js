package drc.display;

import drc.display.AttributeFormat;
import drc.display.Vertex;

class Attribute {

	//** Publics.
	
	/**
	 * The format of the attribute. Cannot be set.
	 */
	public var format(get, null):AttributeFormat;
	
	/**
	 * The name of the attribute. Cannot be set.
	 */
	public var name(get, null):String;
	
	/**
	 * The location of the attribute variable. Cannot be set.
	 */
	public var offset(get, null):Int;
	
	// ** Privates.
	
	/** @private **/ private var __format:AttributeFormat;
	
	/** @private **/ private var __name:String;
	
	/** @private **/ private var __offset:Int;
	
	/** @private **/ private var __location:Int;

	/** @private **/ public var __pointers:Array<Vertex>;
	
	public function new(name:String, format:AttributeFormat, offset:Int, pointers:Array<Vertex>) {

		__name = name;
		
		__format = format;
		
		__offset = offset;
		
		__pointers = pointers;
	}
	
	public function assignLocation(location:Int):Void {

		__location = location;
	}
	
	//** Getters and setters.
	
	private function get_name():String {

		return __name;
	}
	
	private function get_format():AttributeFormat {

		return __format;
	}
	
	private function get_offset():Int {
		
		return __location;
	}
}