package drcJS.part;

import drcJS.part.ObjectList;

class ObjectGroup<T:Object> extends ObjectList<T>
{
	public function new(?capacity:UInt) 
	{
		super(capacity);
	}
}