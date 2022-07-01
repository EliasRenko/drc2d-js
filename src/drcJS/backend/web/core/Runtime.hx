package drc.backend.web.core;

import js.Browser;
import js.html.DOMRect;
import js.html.webgl.RenderingContext;
import drc.system.Input;
import drc.backend.web.core.GL;
import drc.core.EventDispacher;
import drc.utils.Common;
import drc.input.Keyboard;
import drc.input.Mouse;

class Runtime {

    // ** Publics.

    public var active(get, null):Bool;

    //public var event(get, null):EventDispacher<Float>;

    public var input(get, null):Input;

    public var name(get, null):String;

    public var keyboard(get, null):Keyboard;

    public var mouse(get, null):Mouse;

    //private var __mouse:BackendMouse;

    // ** Privates.

    /** @private **/ private var __active:Bool;

    /** @private **/ private var __input:Input;

    /** @private **/ private var __name:String = 'Web';

    /** @private **/ private var __window:drc.backend.web.system.Window;

    ///** @private **/ private var __event:EventDispacher<Float>;

    /** @private **/ private var __keyboard:BackendKeyboard;

    /** @private **/ private var __mouse:BackendMouse;

    /** @private **/ private var __boundingRect:DOMRect;

    private var view:js.html.Window;

    public function new() {

        __active = true;

        //__event = new EventDispacher();

        // ** __gamepads.
    }

    public function init():Void {

        __initVideo();

        __keyboard = new BackendKeyboard();

        __mouse = new BackendMouse();

        __input = new Input(this);

		Common.input = __input;

        if (js.Browser.navigator.getGamepads != null) {

            trace('getGamepads is true');
        }

        if (untyped js.Browser.navigator.webkitGetGamepads != null) {

            trace('webkit getGamepads is true');
        }

        __window.innerData.addEventListener("gamepadconnected", function(gamepad:js.html.Gamepad) {

            trace('Gamepad connected!');
        });

        __window.innerData.addEventListener("gamepaddisconnected", function(event) {

            
        });

        __window.innerData.addEventListener('mousedown', function(event:js.html.MouseEvent) {


        });

        __window.innerData.addEventListener('mousemove', function(event) {

            __mouse.x = Std.int(event.clientX - __boundingRect.left);

            __mouse.y = Std.int(event.clientY - __boundingRect.top);
        });

        js.Browser.document.addEventListener('keydown', function(keyboardEvent:js.html.KeyboardEvent) {

            //__keyboard.dispatchEvent(keyboardEvent.keyCode, 1);
        });

        js.Browser.document.addEventListener('keyup', function(keyboardEvent:js.html.KeyboardEvent) {

        });

        attachWindow("DRC2D_cont");

        requestLoopFrame();
    }

    public function release():Void {}

    public function pollEvents():Void {}

    public function present() {}

    // **

    private function __initVideo():Void {

        __window = new drcJS.system.Window();

        __window.innerData = js.Browser.document.createCanvasElement();

        __window.innerData.id = "glCanvas";

        __window.innerData.className = "glCanvas";

        __window.innerData.width = 640;

        __window.innerData.height = 480;

        Common.window = __window;

        //js.Browser.document.body.appendChild(__window.innerData);

        //var element = js.Browser.document.getElementById("canvas-container");

        //element.appendChild(__window.innerData);

        __boundingRect = __window.innerData.getBoundingClientRect();

        var _gl:RenderingContext = null;

        _gl = __window.innerData.getContext('webgl');

        if (_gl != null) {

            trace('Context created');
        }

        _gl.getExtension('OES_element_index_uint');

        GL.gl = _gl;
        
    }

    public function attachWindow(name:String):Void {

        var element = js.Browser.document.getElementById("container");

        if (element != null) {
         
            

            element.appendChild(__window.innerData);

            

            //__window.resize(element.offsetWidth, element.offsetHeight);

            //__window.resize(32, 32);

            return;
        }

        js.Browser.document.body.appendChild(__window.innerData);
    }

    public function requestLoopFrame():Void {

        js.Browser.window.requestAnimationFrame(__loop);
    }

    private function __loop(timestamp:Float):Void {

        // ** Gamepads poll.

        trace('_loop');

        // **

        __event.dispatchEvent(0, 0);

        js.Browser.window.requestAnimationFrame(__loop);
    }

    public function getGamepad(index:UInt):Void {
        
    }

    // ** Getters and setters.

    private function get_active():Bool {

        return __active;
    }

    private function get_event():EventDispacher<Float> {

		return __event;
	}

    private function get_input():Input {
        
        return __input;
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
}

private class BackendKeyboard extends Keyboard {

    public function new() {
        
        super();
    }
}

private class BackendMouse extends Mouse {

    public function new() {
        
        super();
    }
}