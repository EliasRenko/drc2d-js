package drc.backend.native.core;

import sdl.GLContext;
import drc.backend.native.input.Gamepad;
import drc.system.Input;
import drc.input.Gamepad;
import drc.input.Mouse;
import drc.input.Keyboard;
//import drc.backend.native.system.Window;
import drc.core.EventDispacher;
import drc.core.EventDispacher;
import drc.core.Runtime;
import drc.debug.Log;
import drc.types.GamepadEvent;
import drc.types.GamepadEventType;
import drc.system.Window;
import drc.types.WindowEventType;
import drc.types.GamepadInputEvent;
import drc.utils.Common;
import glew.GLEW;
import sdl.Event;
import sdl.GameController;
import sdl.Joystick;
import sdl.SDL;

#if cpp

class Runtime {

	// ** Publics.

	public var active(get, null):Bool;

	public var event(get, null):EventDispacher<Float>;

	public var name(get, null):String;

	public var keyboard(get, null):Keyboard;

	public var mouse(get, null):Mouse;

	public var window(get, null):Window;

	// ** Privates.

	/** @private **/ private var __active:Bool;

	/** @private **/ private var __gameControllers:Map<UInt, GameControllerDevice>;

	/** @private **/ private var __name:String = 'Native';

	/** @private **/ private var __window:BackendWindow;

	/** @private **/ private var __event:EventDispacher<Float>;

	/** @private **/ private var __input:Input;

	/** @private **/ private var __mouse:BackendMouse;

	/** @private **/ private var __keyboard:BackendKeyboard;

	public function new() {

		Log.print(name);

		__event = new EventDispacher();
	}

	public function init():Void {

		var _result:Int = 0;
		
		// ** Set SDL hints.
		
		SDL.setHint(SDL_HINT_XINPUT_ENABLED, '0');
		
		// ** Init SDL timer.
		
		_result = (SDL.init(SDL_INIT_TIMER));
		
		#if debug
		
		if (_result == 0)
		{
			Log.print(name + 'timer initiated.');
		}
		else
		{
			throw 'SDL failed to initiate timer: `${SDL.getError()}`';
		}
		
		#end
		
		// ** Init SDL video.
		
		_result = SDL.initSubSystem(SDL_INIT_VIDEO);
		
		#if debug
		
		if (_result == 0)
		{
			Log.print(name + 'video initiated.');
		}
		else
		{
			throw 'SDL failed to initiate video: `${SDL.getError()}`';
		}
		
		#end
		
		__initVideo();
		
		// ** Init SDL controllers.
		
		__gameControllers = new Map<UInt, GameControllerDevice>();

		_result = SDL.initSubSystem(SDL_INIT_GAMECONTROLLER | SDL_INIT_JOYSTICK);
		
		#if debug
		
		if (_result == 0)
		{
			Log.print(name + 'controllers initiated.');
		}
		else
		{
			throw 'SDL failed to initiate controllers: `${SDL.getError()}`';
		}
		
		#end

		// ** Input.

		//__input = new Input();
		
		//Common.input = __input;
		
		// ** GameControllers.

		__mouse = new BackendMouse();

		__keyboard = new BackendKeyboard();

		__input = new Input(this);

		Common.input = __input;

		__active = true;
	}

	public function release():Void {

		__active = false;
		
		SDL.quit();
	}

	public function requestLoopFrame():Void {
		
		while (active) {

			__event.dispatchEvent(0, 1);

			__input.postUpdate();
		}

		#if cpp

		Sys.exit(0);

		#end
	}

	public function getGamepad(index:UInt):Void {

	}

	public function pollEvents():Void {

		while (SDL.hasAnEvent()) {

			var event = SDL.pollEvent();
			
			__handleInputEvent(event);
			
			__handleWindowEvent(event);
			
			if (event.type == SDL_DROPFILE) {

				var dropped_filedir = event.drop.file;
			}

			if (event.type == SDL_QUIT) {

				release();
			}
		}
	}

	public function present():Void {

		SDL.GL_SwapWindow(__window.innerData);
	}

	private function __handleInputEvent(event:Event):Void {

		var _eventType:GamepadEventType = GamepadEventType.UNKNOWN;
		
		switch (event.type) {
				
			case SDL_CONTROLLERDEVICEADDED:
				
				// var _gamepad:GameController = SDL.gameControllerOpen(event.cdevice.which);

				// __input.onGamepadConnected(event.cdevice.which, SDL.gameControllerGetJoystick(_gamepad));
				
				// __input.onGamepadEvent(gamepadEvent);

				// ** 

				var _gamepad:GameController = SDL.gameControllerOpen(event.cdevice.which);

				var _gameController = new GameControllerDevice(event.cdevice.which, SDL.gameControllerGetJoystick(_gamepad));

				__gameControllers.set(_gameController.id, _gameController);

				trace('ID = ' + _gameController.id);


				var gamepadEvent:GamepadEvent = {

					timestamp: event.window.timestamp,
					
					gamepad: _gameController,

					index: event.cdevice.which
				}

				__input.event.dispatchEvent(gamepadEvent, 1);

				//__gameControllers.set(SDL.joystickInstanceID(SDL.gameControllerGetJoystick(_gamepad)), )
				
			case SDL_CONTROLLERDEVICEREMOVED:
				
				// __input.onGamepadDisconnected(event.cdevice.which);
				
				// __input.onGamepadEvent(gamepadEvent);

				// ** 

				var _gamepad:GameControllerDevice = __gameControllers.get(event.caxis.which);

				var gamepadEvent:GamepadEvent = {

					timestamp: event.window.timestamp,
					
					gamepad: _gamepad,

					index: _gamepad.index
				}

				__input.event.dispatchEvent(gamepadEvent, 2);
				
			case SDL_CONTROLLERAXISMOTION:
				
				var _val:Float = (event.caxis.value + 32768) / (32767 + 32768);
				
				var _normalized_val = ( -0.5 + _val) * 2.0;
				
				//trace(event.caxis.which + ' - Axis: ' + event.caxis.axis + ' - Value:' + _normalized_val);

				var _gamepadInputEvent:GamepadInputEvent = {

					timestamp: event.window.timestamp,
					
					control: event.caxis.axis,
					
					value: _normalized_val
				}

				//trace(event.caxis.which + ' - Axis: ' + event.caxis.axis + ' - Value:' + _normalized_val);

				__gameControllers.get(event.caxis.which).dispatchEvent(_gamepadInputEvent, 3);
				
			case SDL_CONTROLLERBUTTONDOWN:
				
				var _gamepadInputEvent:GamepadInputEvent = {

					timestamp: event.window.timestamp,
					
					control: event.cbutton.button,
					
					value: 1
				}
				
				__gameControllers.get(event.cbutton.which).dispatchEvent(_gamepadInputEvent, 1);
				
			case SDL_CONTROLLERBUTTONUP:
				
				var gamepadEvent:GamepadInputEvent = {

					timestamp: event.window.timestamp,
					
					control: event.cbutton.button,
					
					value: 0
				}
				
				__gameControllers.get(event.cbutton.which).dispatchEvent(gamepadEvent, 2);
				
			case SDL_CONTROLLERDEVICEREMAPPED:
				
				//_eventType = GamepadEventType.REMAPPED;
				
			case SDL_MOUSEMOTION:
				
				//__input.onMouseMotion(event.button.x, event.button.y);

				@:privateAccess __mouse.__onMotion(event.button.x, event.button.y);
				
			case SDL_MOUSEBUTTONDOWN:
				
				@:privateAccess __mouse.__onButtonDown(event.button.button, 1);
				
			case SDL_MOUSEBUTTONUP:

				@:privateAccess __mouse.__onButtonUp(event.button.button, 2);
				
			case SDL_MOUSEWHEEL:
				
				//__input.onMouseWheel();
				
			case SDL_KEYDOWN:

				__keyboard.onKeyDown(event.key.keysym.scancode);

				//__keyboard.dispatchEvent(event.key.keysym.scancode, 1);
				
			case SDL_KEYUP:
			
				__keyboard.onKeyUp(event.key.keysym.scancode);

				//__keyboard.dispatchEvent(event.key.keysym.scancode, 2);

			case SDL_TEXTEDITING:
			
			case SDL_TEXTINPUT:

				//__input.onTextInput(event.text.text);

				__keyboard.onTextInput(event.text.text);
			
			default:
		}
	}

	private function __handleWindowEvent(event:Event):Void {

		var data1:Int = event.window.data1;
		
		var data2:Int = event.window.data2;
		
		if (event.type == SDL_WINDOWEVENT) {

			var type:WindowEventType = 0;
			
			switch (event.window.event) {

				case SDL_WINDOWEVENT_SHOWN:
					
					type = WindowEventType.SHOWN;

					__window.onEventShown(data1, data2);
					
				case SDL_WINDOWEVENT_HIDDEN:
					
					type = WindowEventType.HIDDEN;

					__window.onEventHidden();
					
				case SDL_WINDOWEVENT_EXPOSED:
					
					type = WindowEventType.EXPOSED;
					
					__window.onEventExposed();

				case SDL_WINDOWEVENT_MOVED:
					
					type = WindowEventType.MOVED;

					__window.onEventMoved(data1, data2);
					
				case SDL_WINDOWEVENT_MINIMIZED:
					
					type = WindowEventType.MINIMIZED;
					
				case SDL_WINDOWEVENT_MAXIMIZED:
					
					type = WindowEventType.MAXIMIZED;
					
				case SDL_WINDOWEVENT_RESTORED:
					
					type = WindowEventType.RESTORED;
					
				case SDL_WINDOWEVENT_ENTER:
					
					type = WindowEventType.ENTER;
					
				case SDL_WINDOWEVENT_LEAVE:
					
					type = WindowEventType.LEAVE;
					
				case SDL_WINDOWEVENT_FOCUS_GAINED:
					
					type = WindowEventType.FOCUS_GAINED;
					
				case SDL_WINDOWEVENT_FOCUS_LOST:
					
					type = WindowEventType.FOCUS_LOST;
					
				case SDL_WINDOWEVENT_CLOSE:
					
					type = WindowEventType.CLOSE;
					
					release();
					
				case SDL_WINDOWEVENT_RESIZED:
					
					type = WindowEventType.RESIZED;

					__window.onEventResized();
					
				case SDL_WINDOWEVENT_SIZE_CHANGED:
					
					type = WindowEventType.SIZE_CHANGED;
					
				case SDL_WINDOWEVENT_NONE:
					
				default:
			}
			
			var windowEvent:drc.types.WindowEvent = {

				type : type,
				
				timestamp : event.window.timestamp,
				
				data1 : data1,
				
				data2 : data2
			}
			
			//__window.onEvent(windowEvent);
		}
	}

	private function __initVideo():Void {

		var _flags:SDLWindowFlags = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE;
		
		__window = new BackendWindow(SDL.createWindow('Director2D', 64, 64, 640, 480, _flags));
		
		//__window.innerData = SDL.createWindow('Director2D', 64, 64, 640, 480, _flags);
		
		Common.window = __window;
		
		if (__window == null) {

			throw 'SDL failed to create a window: `${SDL.getError()}`';
		}
		
		SDL.GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
		
		SDL.GL_SetAttribute(SDL_GL_RED_SIZE, 8);
		SDL.GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
		SDL.GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
		SDL.GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
		SDL.GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		SDL.GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);
		SDL.GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL.GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0);
		
		var gl:GLContext = SDL.GL_CreateContext(__window.innerData);

		if (gl.isnull()) {

			//throw 'SDL failed to create a GL context: `${SDL.getError()}`';
		}

		SDL.GL_SetSwapInterval(true);
		
		SDL.GL_MakeCurrent(__window.innerData, gl);
		
		var _result = GLEW.init();
		

		if (_result != GLEW.OK) {

			trace('runtime / sdl / failed to setup created render context, unable to recover / `${GLEW.error(_result)}`');
		}
		else {

			trace('sdl / GLEW init / ok');
		}
	}

	//** Getters and setters.

	private function get_active():Bool {

		return __active;
	}

	private function get_event():EventDispacher<Float> {

		return __event;
	}

	private function get_name():String {

		return __name;
	}

	private function get_keyboard():Keyboard {
		
		return __keyboard;
	}

	private function get_mouse():Mouse {
		
		return __mouse;
	}

	private function get_window():Window {
		
		return __window;
	}
}

private class BackendWindow extends Window {

	// ** Publics.

	public var innerData:sdl.Window;

	/** Privates. **/

	private var __fullscreen:Bool = false;

	public function new(innerData:sdl.Window) {
		
		super();

		this.innerData = innerData;
	}

	public function onEventShown(data1:Int, data2:Int) {

		dispatchEvent(this, SHOWN);
	}

	override function showDialog(title:String, message:String):Void {
		
		SDL.showSimpleMessageBox(SDL_MESSAGEBOX_ERROR, title, message, innerData);
	}

	public function onEventExposed():Void {

		dispatchEvent(this, EXPOSED);
	}

	public function onEventHidden():Void {
		
		dispatchEvent(this, HIDDEN);
	}

	public function onEventMoved(x:Int, y:Int):Void {
		
		dispatchEvent(this, MOVED);
	}

	public function onEventResized():Void {

		dispatchEvent(this, RESIZED);
	}

	override function resize(width:Int, height:Int):Void {

		SDL.setWindowSize(innerData, width, height);
	}

	//** Getters and setters.
	
	override function get_fullscreen():Bool {
		
		return __fullscreen;
	}

	override function set_fullscreen(value:Bool):Bool {

		if (value) {

			SDL.setWindowFullscreen(innerData, SDL_WINDOW_FULLSCREEN);
		}
		else {

			SDL.setWindowFullscreen(innerData, 0);
		}

		return __fullscreen = value;
	}

	override function get_height():Int {

		var size:SDLSize = {w:0, h:0};
		
		SDL.getWindowSize(innerData, size);
		
		return size.h;
	}

	override function get_x():Int {

		var position:SDLPoint = {x:0, y:0};

		SDL.getWindowPosition(innerData, position);

		return position.x;
	}

	override function get_y():Int {

		var position:SDLPoint = {x:0, y:0};

		SDL.getWindowPosition(innerData, position);

		return position.y;
	}
	
	override function get_width():Int {

		var size:SDLSize = {w:0, h:0};
		
		SDL.getWindowSize(innerData, size);
		
		return size.w;
	}
}

private class GameControllerDevice extends Gamepad {

	// ** Privates.

	private var __innerData:sdl.Joystick;

	public function new(index:UInt, innerData:sdl.Joystick) {

		super(index);

		__innerData = innerData;
	}

	override function close() {

		SDL.joystickClose(__innerData);
	}

	// ** 

	override function get_id():UInt {

		return SDL.joystickInstanceID(__innerData);
	}
}

private class BackendKeyboard extends Keyboard {

	public function new() {
		
		super();
	}

	override function onKeyDown(keycode:Int):Void {

		super.onKeyDown(keycode);
	}

	override function onKeyUp(keycode:Int):Void {

		super.onKeyUp(keycode);
	}

	override function startTextInput():Void {

		SDL.startTextInput();

		super.startTextInput();
	}

	override function stopTextInput():Void {

		SDL.stopTextInput();

		super.stopTextInput();
	}

	override function onTextInput(text:String):Void {
		
		super.onTextInput(text);
	}
}

private class BackendMouse extends Mouse {

	public function new() {
		
		super();
	}
}

#end