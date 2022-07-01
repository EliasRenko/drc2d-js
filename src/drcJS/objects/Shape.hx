package drc.objects;

import drc.math.Vector2;

class Shape {

    // ** Publics.

    public var active:Bool = true;

    public var angle:Float = 0;

    public var vertices(get, null):Array<Float>;

    public var position:Vector2 = new Vector2(0, 0);

    // ** Privates.

    /** @private **/ private var __vertices:Array<Float>;

    /** @private **/ private var __x:Float = 0;

    /** @private **/ private var __y:Float = 0;

    public function new(vertices:Array<Float>, position:Vector2) {
        
        // ** Set the vertices of the shape.

        __vertices = vertices;

        this.position = position;
    }

    public function init():Void {
        
    }

    public function release():Void {
        
    }

    // ** Getters and setter.

    private function get_vertices():Array<Float> {
        
        return __vertices;
    }

    private function get_x():Float {

		return __x;
	}

	private function set_x(value:Float):Float {

		__x = value;

		return __x;
	}

	private function get_y():Float {

		return __y;
	}

	private function set_y(value:Float):Float {

		__y = value;

		return __y;
	}
}