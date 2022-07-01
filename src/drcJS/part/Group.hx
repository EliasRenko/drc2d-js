package drc.part;

import haxe.Constraints.Function;
import drc.part.Object;

#if debug // ------

#end // ------

class Group<T:Object> extends List<T>
{
	//** Publics.
	
	//** Privates.
	
	private var __count:Int = 0;
	
	public function new(?lenght:Int, ?fixed:Bool) 
	{
		super(lenght, fixed);
	}
	
	/**
	 * Pushes an object into the group. Does not work if the group is fixed.
	 * 
	 * @param	object The object to be added.
	 * @return	DrcObject
	 */
	override public function add(object:T):T 
	{
		//** If the group is fixed...
		
		//** If the object already exists...
		
		if (members.indexOf(object) >= 0)
		{
			//** Return.
			
			return object;
		}
		
		//** Get the first null index.
		
		var index:Int = getFirstNull();
		
		//** If there is no null index.
		
		if (index != -1)
		{
			//** Add the object into the array.
			
			members[index] = object;
			
			//** If the index is bigger than the count...
			
			if (index >= __count)
			{
				//** Increment the count.
				
				__count = index + 1;
			}
			
			//** Return.
			
			return object;
		}
		
		//** Push the object into the array.
		
		members.push(object);
		
		//** Increment the count.
		
		__count ++;
		
		//** Return.
		
		return object;
	}
	
	/**
	 * Adds an object at the specific index of this group. Will override any other object at this position.
	 * 
	 * @param	index The index of the position.
	 * @param	object The object to be added.
	 * @return	DrcObject
	 */
	override public function addAt(index:Int, object:T):T 
	{
		//** If the object already exists at this index...
		
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
	
	override public function remove(object:T):Void 
	{
		//** Get the index of the object.
		
		var index:Int = members.indexOf(object);
		
		//** Call remove at method.
		
		removeAt(index);
	}
	
	override public function removeAt(index:Int):Void 
	{
		if (index < 0)
		{
			return;
		}
		
		members.splice(index, 1);
		
		//members[index] = null;
		
		__count --;
	}
	
	/**
	 * Returns the first index set to 'null'. Will return '-1' if no index stores a 'null' object.
	 * 
	 * @return Int
	 */
	public function getFirstNull():Int
	{
		var i:Int = 0;
		
		while (i < count)
		{
			if (members[i] == null)
			{
				return i;
			}
			
			i++;
		}
		
		return -1;
	}
	
	/**
	 * Call a method for every member of this group.
	 * 
	 * @param	func The function to be called.
	 * @param	args The arguments of the function.
	 */
	public function callMethod(func:Function, args:Array<Dynamic>):Void
	{
		for (i in 0...members.length) 
		{
			Reflect.callMethod(members[i], func, args);
		}
	}
	
	public function callMethodAt(index:Int, func:Function, args:Array<Dynamic>):Void
	{
		Reflect.callMethod(members[index], func, args);
	}
	
	public function setProperty(field:String, value:Dynamic, ?bypass:Bool = false):Void
	{
		for (i in 0...members.length) 
		{
			setPropertyAt(i, field, value, bypass);
		}
	}
	
	public function setPropertyAt(index:Int, field:String, value:Dynamic, ?bypass:Bool = false):Void
	{
		#if debug // ------
		
		//** If field does not exist and bypass is false.
		
		if (!Reflect.hasField(members[index], field) && !bypass)
		{
			//** Check if a private variable of the field exists.
			
			if (!Reflect.hasField(members[index], "__" + field))
			{
				//** Get the name of the class.
				
				var className = Type.getClassName(Type.getClass(this));
				
				//** Throw an error!
				
				//DrcConsole.showTrace("Class: " + className + " cannot access field " + field + ".");
				
				//** Return.
				
				return;
			}
		}
		
		#end // ------
		
		//** Set the field to a value.
		
		Reflect.setProperty(members[index], field, value);
	}
	
	//** Getters and setters.
	
	override function get_count():Int 
	{
		return members.length;
	}
}