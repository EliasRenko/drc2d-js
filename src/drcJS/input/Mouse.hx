package drc.input;

import haxe.ds.Vector;
import drc.core.EventDispacher;

class Mouse extends Device<Mouse> {

    public var x:Int = 0;

    public var y:Int = 0;

    public var leftClick:Bool = false;

    public var middleClick:Bool = false;

    public var rightClick:Bool = false;

    public var leftClickUp:Bool = false;

    public var middleClickUp:Bool = false;

    public var rightClickUp:Bool = false;

    public function new() {
        
        super();

        __checkControls = new Vector(256);

        __pressControls = new Array();

        __releaseControls = new Array();
    }

    private function __onButtonDown(num:Int, type:Int) {
        
        __checkControls[num] = true;
		
		__checkCount ++;
		
		__pressControls[__pressCount ++] = num;

        dispatchEvent(this, 1);
    }

    private function __onButtonUp(num:UInt, type:UInt) {
        
        __checkControls[num] = false;
		
		__checkCount --;
		
		__releaseControls[__releaseCount ++] = num;
        
        dispatchEvent(this, 2);
    }

    private function __onMotion(x:Int, y:Int) {
        
        this.x = x;

        this.y = y;

        dispatchEvent(this, 3);
    }
}