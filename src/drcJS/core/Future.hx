package drcJS.core;

class Future<T>
{
	// ** Publics.

	public var error(default, null):Dynamic;
	
	public var isComplete(default, null):Bool;
	
	public var isError(default, null):Bool;
	
	public var value(default, null):T;
	
	// ** Privates.

	@:noCompletion
	private var __completeListeners:Array<T->Void>;

	@:noCompletion
	private var __errorListeners:Array<Dynamic->Void>;

	@:noCompletion
	private var __progressListeners:Array<Int->Int->Void>;

	public function new(work:Void -> T = null, async:Bool = false) 
	{
		if (work == null) return;
		
		if (async) {

			//var _promise:Promise<T> = new Promise<T>();
			
			//_promise.future = this;
			
			//FutureWork.queue({promise: _promise, work: work});
		}
		else {

			try
			{
				value = work();

				isComplete = true;
			}
			catch (error:Dynamic)
			{
				this.error = error;

				isError = true;
			}
		}
	}
}

private class FutureWork
{
	public static function queue(state:Dynamic = null):Void
	{

	}
}