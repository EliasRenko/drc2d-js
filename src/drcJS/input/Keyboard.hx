package drc.input;

import haxe.ds.Vector;
import drc.core.EventDispacher;
import drc.types.KeyboardEvent;
import drc.input.Device;

class Keyboard extends Device<KeyboardEvent> {

    public function new() {
        
        super();

        __checkControls = new Vector(256);

        __pressControls = new Array();

        __releaseControls = new Array();
    }

    public function startTextInput():Void {
        
    }

    public function stopTextInput():Void {
        
    }

    public function onKeyDown(keycode:Int):Void {
        
        __checkControls[keycode] = true;
		
		__checkCount ++;
		
		__pressControls[__pressCount ++] = keycode;

        dispatchEvent({key: keycode}, 1);

        trace(keycode);
    }

    public function onKeyUp(keycode:Int):Void {
     
        __checkControls[keycode] = false;
		
		__checkCount --;
		
		__releaseControls[__releaseCount ++] = keycode;

        dispatchEvent({key: keycode}, 2);
    }

    public function onTextInput(text:String):Void {
        
        dispatchEvent({text: text}, 3);
    }

    private function __onKeyDown(key:UInt, type:UInt):Void {

    }

    private function __onKeyUp(key:UInt, type:UInt):Void {

    }
}