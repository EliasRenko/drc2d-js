package drcJSJS.core;

import js.Browser;
import js.html.CanvasElement;

import drcJSJS.core.WebGL;

class Context {

    // ** Publics.

    public static inline var CANVAS_ID:String = "canvas_gl";

    public var active(get, null):Bool;
    
    // ** Privates.

    /** @private **/ private var __active:Bool;

    public function new() {
        
    }

    public function init() {
        
        var canvas:CanvasElement = Browser.document.createCanvasElement();

        canvas.id = CANVAS_ID;

        canvas.width = 640;

        canvas.height = 480;

        WebGL.gl = canvas.getContext('webgl');

        if (WebGL.gl != null) {

            trace('Context created');
        }

        // ** Extensions

        WebGL.gl.getExtension('OES_element_index_uint');

        var element = js.Browser.document.getElementById("canvas-container");

        if (element != null) {
         
            element.appendChild(canvas);

            canvas.width = element.offsetWidth;

            canvas.height = element.offsetHeight;

            //__window.resize(32, 32);

            return;
        }

        Browser.document.body.appendChild(canvas);

        Browser.window.requestAnimationFrame(__onFrame);
    }

    private function __onFrame(timestamp:Float):Void {
        
        update();

        render();

        Browser.window.requestAnimationFrame(__onFrame);
    }

    private function render():Void {
        
    }

    private function update():Void {
        
    }

    // ** Getters and setters.

    private function get_active():Bool {

        return __active;
    }
}