package drc.objects;

import drc.math.Vector4;
import haxe.io.Float32Array;
import drc.math.Matrix;
import drc.utils.Common;

class Camera {

    public var pitch(get, set):Int;

    public var roll(get, set):Int;

    public var x:Int = 0;

    public var yaw(get, set):Int;

    public var y:Int = 0;

    public var z:Int = 0;

    /** Privates. **/

    private static var __identity:Array<Float> = [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0];

    private var __matrix:Matrix = new Matrix();

    /** @private **/ private var __pitch:Int = 0;

    /** @private **/ private var __roll:Int = 0;

    /** @private **/ private var __yaw:Int = 0;

    public function new(data:Float32Array = null) {

    }

    public function render(modelMatrix:Matrix):Matrix {
        
        var _view:Matrix = new Matrix();

        _view.identity();

        _view.append(modelMatrix);

        __matrix.identity();

        // ** ---

        __matrix.identity();
        
        __matrix.appendTranslation(x, y, z);

        _view.append(__matrix);

        _view.append(Matrix.createOrthoMatrix(0, Common.window.width, Common.window.height, 0, 1000, -1000));

        return _view;
    }

    public function render2(modelMatrix:Matrix) {

        var _view:Matrix = new Matrix();

        _view.identity();

        _view.append(modelMatrix);

        __matrix.identity();

        __matrix.appendRotation(yaw, Vector4.Y_AXIS);

        __matrix.appendTranslation(x, y, z);

        _view.append(__matrix);

        var fov:Float = 45 * Math.PI / 180;
				
        var aspect:Float = 4 / 3;
        
        //projection.perspective(fov, aspect, __width, __height, 0.1, 10000);

        _view.append(Matrix.createPerspectiveMatrix(fov, aspect, 640, 480, 10, 1000));

        return _view;
    }

    // ** Getters and setters.

    private function get_pitch():Int {

        return __pitch;
    }

    private function set_pitch(value:Int):Int {

        return __pitch = (value %= 360) >= 0 ? value : (value + 360);
    }

    private function get_roll():Int {

        return __roll;
    }

    private function set_roll(value:Int):Int {

        return __roll = (value %= 360) >= 0 ? value : (value + 360);
    }

    private function get_yaw():Int {

        return __yaw;
    }

    private function set_yaw(value:Int):Int {

        return __yaw = (value %= 360) >= 0 ? value : (value + 360);
    }
}