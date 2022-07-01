package drc.part;

import drc.part.ObjectList;

class ObjectGroup<T:Object> extends ObjectList<T>
{
	public function new(?capacity:UInt) 
	{
		super(capacity);
	}
}