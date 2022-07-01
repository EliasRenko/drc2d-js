package drc.part;

import drc.types.ObjectStatus;

class ObjectList<T:Object>
{
	//** Publics.
	
	/**
	 * The maximum capacity of this group. Default is 0, meaning no max capacity.
	 */
	public var capacity(get, null):UInt;
	
	/**
	 * The count of all members inside the list.
	 */
	public var count(get, null):Int;
	
	/**
	 * If the list has a fixed size.
	 */
	public var fixed(get, null):Bool;
	
	/**
	 * An array of all the members.
	 */
	public var members:Array<T>;
	
	//** Privates.
	
	/** @private **/ private var __capacity:UInt = 0;
	
	/** @private **/ private var __count:UInt = 0;
	
	//** Methods.
	
	public function new(?capacity:UInt) 
	{
		members = new Array<T>();
		
		if (capacity == null)
		{
			return;
		}
		
		for (i in 0...capacity) 
		{
			members[i] = null;
		}
		
		__capacity = capacity;
	}
	
	public function add(object:T):T
	{
		if (fixed) return object;
		
		if (@:privateAccess object.__status != ObjectStatus.NULL) //** Define metadata: privateAccess.
		{	
			//** Return.
			
			return object;
		}
		
		if (__capacity > 0 && count >= __capacity)
		{
			//** Return.
			
			return object;
		}
		
		trace("Init");
		
		object.init();
		
		@:privateAccess object.__status = ObjectStatus.ACTIVE; //** Define metadata: privateAccess.
		
		@:privateAccess object.index = members.push(object) - 1; //** Define metadata: privateAccess.
		
		//** Return.
		
		return object;
	}
	
	public function addAt(index:Int, object:T):T
	{
		if (@:privateAccess object.__status != ObjectStatus.NULL) //** Define metadata: privateAccess.
		{	
			//** Return.
			
			return object;
		}
		
		if (members[index] == object)
		{
			//** Return.
			
			return object;
		}
		
		//** Add the object into the array.
		
		members[index] = object;
		
		//** If the index is bigger than the count...
		
		if (index >= __count)
		{
			//** Increment the count.
			
			__count ++;
		}
		
		//** Return.
		
		return object;
	}
	
	public function remove(object:T):T
	{
		if (object.index < 0)
		{
			//** Return.
			
			return object;
		}
		
		if (members[object.index] == object)
		{
			@:privateAccess object.__status = ObjectStatus.NULL;
			
			object.release();
			
			members.splice(object.index, 1);
			
			count --;
		}
		
		return object;
	}
	
	public function removeAt(index:Int):Void
	{
		if (index < 0)
		{
			//** Return.
			
			return;
		}
		
		if (members[index] == null)
		{
			return;
		}
		
		@:privateAccess members[index].status = ObjectStatus.NULL;
		
		members[index].release();
		
		members.splice(index, 1);
		
		__count --;
	}
	
	//** Getters and setters.
	
	public function get_capacity():UInt
	{
		return __capacity;
	}
	
	public function get_count():Int
	{
		return members.length;
	}
	
	public function get_fixed():Bool
	{
		return __capacity > 0 ? true : false;
	}
}