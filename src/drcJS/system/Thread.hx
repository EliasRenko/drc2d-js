package;

import cpp.vm.Thread;
import cpp.vm.Deque;

#if cpp

class Thread
{
	//** Publics.
	
	public var canceled(default, null):Bool;
	
	public var completed(default, null):Bool;
	
	public var doWork = new Event<Dynamic->Void>();
	
	public var onComplete = new Event<Dynamic->Void>();
	
	public var onError = new Event<Dynamic->Void>();
	
	public var onProgress = new Event<Dynamic->Void>();
	
	//** Privates.
	
	//** Methods.
	
	public function new() 
	{
		
	}	
}

#end