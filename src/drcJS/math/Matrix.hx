package drc.math;

//import drc.buffers.Float32Array;
//import haxe.io.Bytes;
//import haxe.io.Float32Array;

import drc.core.Buffers;

@:arrayAccess
abstract Matrix(Float32Array) from Float32Array to Float32Array {

    /** Privates. **/

    private static var __identity:Array<Float> = [1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0];

    public function new(data:Float32Array = null) {

        if (data != null && data.length == 16)
        {
            this = data;
        }
        else
        {
            #if js 

            this = Float32Array.fromArray(__identity);

            #else

            this = Float32Array.fromArray(__identity);

            #end
        }
    }

    public function getData():Float32Array {

        return this;
    }

    public function append(lhs:Float32Array):Void {

        var _m111:Float = this[0],

        _m121:Float = this[4],
        
        _m131:Float = this[8],
        
        _m141:Float = this[12],
        
        _m112:Float = this[1],
        
        _m122:Float = this[5],
        
        _m132:Float = this[9],
        
        _m142:Float = this[13],
        
        _m113:Float = this[2],
        
        _m123:Float = this[6],
        
        _m133:Float = this[10],
        
        _m143:Float = this[14],
        
        _m114:Float = this[3],
        
        _m124:Float = this[7],
        
        _m134:Float = this[11],
        
        _m144:Float = this[15],
        
        _m211:Float = lhs[0],
        
        _m221:Float = lhs[4],
        
        _m231:Float = lhs[8],
        
        _m241:Float = lhs[12],
        
        _m212:Float = lhs[1],
        
        _m222:Float = lhs[5],
        
        _m232:Float = lhs[9],
        
        _m242:Float = lhs[13],
        
        _m213:Float = lhs[2],
        
        _m223:Float = lhs[6],
        
        _m233:Float = lhs[10],
        
        _m243:Float = lhs[14],
        
        _m214:Float = lhs[3],
        
        _m224:Float = lhs[7],
        
        _m234:Float = lhs[11],
        
        _m244:Float = lhs[15];

        this[0] = _m111 * _m211 + _m112 * _m221 + _m113 * _m231 + _m114 * _m241;
        
        this[1] = _m111 * _m212 + _m112 * _m222 + _m113 * _m232 + _m114 * _m242;
        
        this[2] = _m111 * _m213 + _m112 * _m223 + _m113 * _m233 + _m114 * _m243;
        
		this[3] = _m111 * _m214 + _m112 * _m224 + _m113 * _m234 + _m114 * _m244;

        this[4] = _m121 * _m211 + _m122 * _m221 + _m123 * _m231 + _m124 * _m241;
        
        this[5] = _m121 * _m212 + _m122 * _m222 + _m123 * _m232 + _m124 * _m242;
        
        this[6] = _m121 * _m213 + _m122 * _m223 + _m123 * _m233 + _m124 * _m243;
        
		this[7] = _m121 * _m214 + _m122 * _m224 + _m123 * _m234 + _m124 * _m244;

        this[8] = _m131 * _m211 + _m132 * _m221 + _m133 * _m231 + _m134 * _m241;
        
        this[9] = _m131 * _m212 + _m132 * _m222 + _m133 * _m232 + _m134 * _m242;
        
        this[10] = _m131 * _m213 + _m132 * _m223 + _m133 * _m233 + _m134 * _m243;
        
		this[11] = _m131 * _m214 + _m132 * _m224 + _m133 * _m234 + _m134 * _m244;

        this[12] = _m141 * _m211 + _m142 * _m221 + _m143 * _m231 + _m144 * _m241;
        
        this[13] = _m141 * _m212 + _m142 * _m222 + _m143 * _m232 + _m144 * _m242;
        
        this[14] = _m141 * _m213 + _m142 * _m223 + _m143 * _m233 + _m144 * _m243;
        
		this[15] = _m141 * _m214 + _m142 * _m224 + _m143 * _m234 + _m144 * _m244;
    }

    public function appendRotation(angle:Float, axis:Vector4):Void
    {
        var _matrix:Matrix = __getAxisRotation(axis.x, axis.y, axis.z, angle);

        append(_matrix);
    }

    public function appendScale(xScale:Float, yScale:Float, zScale:Float):Void
    {
        // append(new Matrix(Float32Array.fromArray([

        //     xScale, 0.0, 0.0, 0.0, 0.0, yScale, 0.0, 0.0, 0.0, 0.0, zScale, 0.0, 0.0, 0.0, 0.0, 1.0

        // ])));

        this[0] *= xScale;

        this[5] *= yScale;

        this[10] *= zScale;
    }

    public function appendTranslation(x:Float, y:Float, z:Float):Void {

        this[12] += x;

        this[13] += y;

        this[14] += z;
    }

    @:noCompletion private function __getAxisRotation(x:Float, y:Float, z:Float, degrees:Float):Matrix
    {
        var m = new Matrix();

        var a1 = new Vector4(x, y, z);
        var rad = -degrees * (Math.PI / 180);
        var c = Math.cos(rad);
        var s = Math.sin(rad);
        var t = 1.0 - c;

        m[0] = c + a1.x * a1.x * t;
        m[5] = c + a1.y * a1.y * t;
        m[10] = c + a1.z * a1.z * t;

        var tmp1 = a1.x * a1.y * t;
        var tmp2 = a1.z * s;
        m[4] = tmp1 + tmp2;
        m[1] = tmp1 - tmp2;
        tmp1 = a1.x * a1.z * t;
        tmp2 = a1.y * s;
        m[8] = tmp1 - tmp2;
        m[2] = tmp1 + tmp2;
        tmp1 = a1.y * a1.z * t;
        tmp2 = a1.x * s;
        m[9] = tmp1 + tmp2;
        m[6] = tmp1 - tmp2;

        return m;
    }

    public function identity():Void
    {
        this[0] = 1;
        this[1] = 0;
        this[2] = 0;
        this[3] = 0;
        this[4] = 0;
        this[5] = 1;
        this[6] = 0;
        this[7] = 0;
        this[8] = 0;
        this[9] = 0;
        this[10] = 1;
        this[11] = 0;
        this[12] = 0;
        this[13] = 0;
        this[14] = 0;
        this[15] = 1;
    }

    public function createOrthoMatrix2(x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float):Float32Array {

        var i = this;

        if(i == null) i = new Float32Array(16);

        var sx = 1.0 / (x1 - x0);
        var sy = 1.0 / (y1 - y0);
        var sz = 1.0 / (zFar - zNear);

            i[ 0] = 2.0*sx;        i[ 1] = 0;            i[ 2] = 0;                 i[ 3] = 0;
            i[ 4] = 0;             i[ 5] = (2.0*sy);       i[ 6] = 0;                 i[ 7] = 0;
            i[ 8] = 0;             i[ 9] = 0;            i[10] = -2.0*sz;           i[11] = 0;
            i[12] = -(x0+x1)*sx;   i[13] = -(y0+y1)*sy;  i[14] = -(zNear+zFar)*sz;  i[15] = 1;

        return i;
    }

    public function create2DMatrix(x:Float, y:Float, scale:Float = 1, rotation:Float = 0 ) {

        var i = this;
        
        if(i == null) i = new Float32Array(16);

        var theta = rotation * Math.PI / 180.0;
        var c = Math.cos(theta);
        var s = Math.sin(theta);

            i[ 0] = c*scale;  i[ 1] = -s*scale;  i[ 2] = 0;      i[ 3] = 0;
            i[ 4] = s*scale;  i[ 5] = c*scale;   i[ 6] = 0;      i[ 7] = 0;
            i[ 8] = 0;        i[ 9] = 0;         i[10] = 1;      i[11] = 0;
            i[ 12] = x;       i[13] = y;         i[14] = 0;      i[15] = 1;

        return i;
    }

    public static function createOrthoMatrix(x0:Float, x1:Float,  y0:Float, y1:Float, zNear:Float, zFar:Float, ?flipped:Bool = false):Float32Array {

        var i = new Float32Array(16);

        if(i == null) i = new Float32Array(16);

        var sx = 1.0 / (x1 - x0);
        var sy = 1.0 / (y1 - y0);
        var sz = 1.0 / (zFar - zNear);


            i[ 0] = 2.0*sx;        i[ 1] = 0;            i[ 2] = 0;                 i[ 3] = 0;
            i[ 4] = 0;             i[ 5] = (2.0*sy);       i[ 6] = 0;                 i[ 7] = 0;
            i[ 8] = 0;             i[ 9] = 0;            i[10] = -2.0*sz;           i[11] = 0;
            i[12] = -1;            i[13] = 1;            i[14] = -(zNear+zFar)*sz;  i[15] = 1;

        return i;
    }

    public static function createPerspectiveMatrix(fieldOfView:Float, aspect:Float, width:Float, height:Float, zNear:Float, zFar:Float):Matrix {

        var i = new Float32Array(16);

        if(i == null) i = new Float32Array(16);

        var yScale:Float = 1.0/Math.tan(fieldOfView/2.0);
		var xScale:Float = yScale / aspect;
        


            i[ 0] = xScale;        i[ 1] = 0;            i[ 2] = 0;                 i[ 3] = 0;
            i[ 4] = 0;             i[ 5] = -(yScale);       i[ 6] = 0;                 i[ 7] = 0;
            i[ 8] = 0;             i[ 9] = 0;            i[10] = (zFar/(zFar-zNear)); i[11] = 1;
            i[12] = 0;       i[13] = 0;            i[14] = zNear*zFar/(zNear-zFar);  i[15] = 1;

        return i;

        /* var xScale:Float = yScale / aspect; 


            i[ 0] = xScale;        i[ 1] = 0;            i[ 2] = 0;                 i[ 3] = 0;
            i[ 4] = 0;             i[ 5] = -(yScale);       i[ 6] = 0;                 i[ 7] = 0;
            i[ 8] = 0;             i[ 9] = 0;            i[10] = (zFar/(zFar-zNear)); i[11] = 1;
            i[12] = 0;       i[13] = 0;            i[14] = zNear*zFar/(zNear-zFar);  i[15] = 1;

        return i; */
    }   

    // ** Getters and setters.

    @:noCompletion
    @:arrayAccess
    public function get(index:Int):Float {

        #if js

        return this[index];

        #else

        return this.get(index);

        #end
    }
    
    @:noCompletion
    @:arrayAccess
    public function set(index:Int, value:Float):Float {

        #if js

        this[index] = value;

        return value;

        #else

        this.set(index, value);
        
        return value;

        #end
    }
}