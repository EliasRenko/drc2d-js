package drc.data;

import drc.display.Attribute;
import drc.display.Program;
import drc.display.Uniform;
import drc.core.GL;

typedef TextureData = {

	name:String,

	format:String,

	?location:GLUniformLocation
}

class Profile {
	
	//** Publics.
	
	public var attributes:Array<Attribute> = new Array<Attribute>();
	
	public var dataPerVertex:UInt;
	
	public var name(get, null):String;

	public var textures:Array<TextureData> = new Array<TextureData>();

	public var textureCount(get, null):Int;

	public var program:Program;

	public var uniforms:Array<Uniform> = new Array<Uniform>();
	
	// ** Privates.
	
	/** @private **/ private var __name:String;
	
	public function new(name:String) {

		__name = name;
	}
	
	public function addAttribute(attribute:Attribute):Void {

		attributes.push(attribute);
	}
	
	public function addUniform(uniform:Uniform):Void {

		uniforms.push(uniform);
	}
	
	// ** Getters and setters.
	
	private function get_name():String {

		return __name;
	}

	private function get_textureCount():Int {
		
		return textures.length;
	}
}