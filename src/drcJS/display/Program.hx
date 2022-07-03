package drcJS.display;

import drcJS.core.GL.GLProgram;

class Program 
{
	//** Publics.
	
	public var innerData(get, null):GLProgram;
	
	//** Privates.
	
	/** @private **/ private var __glProgram:GLProgram;
	
	public function new(glProgram:GLProgram) 
	{
		__glProgram = glProgram;
	}
	
	//** Getters and setters.
	
	private function get_innerData():GLProgram
	{
		return __glProgram;
	}
}