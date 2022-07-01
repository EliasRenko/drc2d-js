package drc.backend.web.system;

import drc.types.WindowEventType;
import drc.core.EventDispacher;
import drc.types.WindowEvent;

#if js

class Window {

	/** Publics. **/
	
	public var fullscreen(get, set):Bool;

	public var innerData:js.html.CanvasElement;
	
	public var height(get, null):Int;

	//public var onEvent:EventDispacher<drc.system.Window>;

	//public var onEventHandler:WindowEvent -> Void;
	
	public var width(get, null):Int;

	public var x(get, null):Int;

	public var y(get, null):Int;
	
	/** Privates. **/

	private var __fullscreen:Bool = false;

	/**  **/

	public function new() {
	
		//onEvent = new EventDispacher();
	}
	
	public function showDialog(title:String, message:String):Void {
		
		//SDL.showSimpleMessageBox(SDL_MESSAGEBOX_ERROR, title, message, innerData);
	}
	
	public function onEventExposed():Void {

	}

	public function onEventHidden():Void {
		
	}

	public function onEventShown(data1:Int, data2:Int):Void {

		trace(data1);

		trace(data2);
	}

	public function onEventMoved(x:Int, y:Int):Void {
		
	}

	public function onEventResized():Void {

		//onEvent.dispatchEvent(this, RESIZED);
	}

	public function resize(width:Int, height:Int):Void {

		innerData.width = width;

		innerData.height = height;
	}

	//** Getters and setters.
	
	private function get_fullscreen():Bool {
		
		return __fullscreen;
	}

	private function set_fullscreen(value:Bool):Bool {

		if (value) {

			//SDL.setWindowFullscreen(innerData, SDL_WINDOW_FULLSCREEN);
		}
		else {

			//SDL.setWindowFullscreen(innerData, 0);
		}

		return __fullscreen = value;
	}

	private function get_height():Int {

		//var size:SDLSize = {w:0, h:0};
		
		//SDL.getWindowSize(innerData, size);
		
		return innerData.height;
	}

	private function get_x():Int {

		//var position:SDLPoint = {x:0, y:0};

		//SDL.getWindowPosition(innerData, position);

		return 0;
	}

	private function get_y():Int {

		//var position:SDLPoint = {x:0, y:0};

		//SDL.getWindowPosition(innerData, position);

		return 0;
	}
	
	private function get_width():Int {

		//var size:SDLSize = {w:0, h:0};
		
		//SDL.getWindowSize(innerData, size);

		return innerData.width;
	}
}

#end