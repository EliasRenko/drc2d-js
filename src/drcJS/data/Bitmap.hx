package drc.data;

import drc.utils.Color;
import drc.math.Rectangle;
import drc.core.Buffers;
import stb.Image;
import drc.utils.Common;

class Bitmap {

    // ** Publics.

    public var bytes:UInt8Array;

    public var bytesPerPixel(get, null):Int;

    public var dirty(get, null):Bool;

    public var height(get, null):Int;

    public var powerOfTwo(get, null):Bool;

    public var transparent(get, null):Bool;

    public var width(get, null):Int;

    // ** Privates.

    /** @private **/ //private var __bytes:UInt8Array;

    /** @private **/ private var __bytesPerPixel:Int;

    /** @private **/ private var __dirty:Bool = false;

    /** @private **/ private var __height:Int;

    /** @private **/ private var __transparent:Bool;

    /** @private **/ private var __width:Int;

    public function new(?data:UInt8Array, ?bytesPerPixel:Int, ?width:Int, ?height:Int) {
        
        if (data == null) {

            return;
        }

        //GL.pixelStorei(GL.UNPACK_ALIGNMENT, 1);

        upload(data, bytesPerPixel, width, height);

        //generate(width, height);
    }

    public function clone():Texture {

        return null;
    }

    public function generate(width:Int, height:Int, bpp:Int, value:Int = 0):Void {

        __bytesPerPixel = bpp;

        __width = width;

        __height = height;

        if (__bytesPerPixel == 4) {

            __transparent = true;
        }

        var dim = __width * __height;

        var _bytes = new UInt8Array(dim * __bytesPerPixel);

        //var _bytes = haxe.io.Bytes.alloc(dim * __bytesPerPixel);

        for (i in 0...dim) {

            var pos = __bytesPerPixel * i;

            for(j in 0...__bytesPerPixel) {

                _bytes[pos + j] = value;
            }

            if (__transparent) _bytes[pos + 3] = 0;

            //if (__transparent) _bytes[j] = 255;

            //_bytes.set(pos, 250);
            //_bytes.set(pos + 1, 250);
            //_bytes.set(pos + 2, 250);

            

            //_bytes[pos + 3] = 1;
        }

        //bytes = _bytes;

        //GL.bindTexture(GL.TEXTURE_2D, glTexture);

        //glTexture = Common.context.generateTexture();

        //Common.context.loadTexture(__width, __height, __bytesPerPixel, _bytes);

        #if js

        upload(_bytes, __bytesPerPixel, width, height);

        #else

        upload(_bytes, __bytesPerPixel, width, height);

        #end
    }

    public function create(width:Int, height:Int) {

        __bytesPerPixel = 4;

        __width = width;

        __height = height;

        if (__bytesPerPixel == 4) {

            __transparent = true;
        }
    }

    public function copyPixels(sourceTexture:drc.data.Texture, x:Int, y:Int, width:UInt, height:UInt):Void {
        
        if (bytes == null) return;

        var pixels:UInt8Array = new UInt8Array((width * height) * sourceTexture.bytesPerPixel);

        var channels = sourceTexture.bytesPerPixel;

        var count:Int = (width * height) * sourceTexture.bytesPerPixel;

        for (i in 0...count) {

            pixels[i] = sourceTexture.bytes[i];
        }

        var _w:UInt = x;

        var _h:UInt = y;

        var _j:Int = 0;

        for (j in 0...height) {

            for (i in 0...width) {

                var _pos = (_w + (_h * __width)) * bytesPerPixel;

                for(k in 0...channels) {

                    bytes[_pos + k] = pixels[_j + k];
                }

                // bytes[_pos] = pixels[_j];
                // bytes[_pos + 1] = pixels[_j + 1];
                // bytes[_pos + 2] = pixels[_j + 2];

                //if (channels > 3) bytes[_pos + 3] = pixels[_j + 3];
                //else bytes[_pos + 3] = 255;


                _j += channels;

                _w ++;
            }

            _h ++;

            _w = x;
        }

        upload(bytes, bytesPerPixel, __width, __height);
    }

    public function copyPixels2(sourceTexture:drc.data.Texture, x:Int, y:Int, width:UInt, height:UInt, x2:Int, y2:Int):Void {

        if (bytes == null) return;

        //trace(sourceTexture.bytesPerPixel);

        var pixels:UInt8Array = new UInt8Array((width * height) * sourceTexture.bytesPerPixel);

        var _w:UInt = x;

        var _h:UInt = y;

        for (j in 0...height) {

            for (i in 0...width) {

                var _pos = (_w + (_h * sourceTexture.width)) * bytesPerPixel;

                var index = 0;

                for (k in _pos..._pos + bytesPerPixel) {

                    //pixels.buffer.push(sourceTexture.bytes[k]);

                    //pixels.set(index, sourceTexture.bytes[k])

                    //pixels.

                    pixels[index] = sourceTexture.bytes[k];

                    index ++;
                }

                //pixels.push(sourceTexture.bytes[_pos]);
                //pixels.push(sourceTexture.bytes[_pos + 1]);
                //pixels.push(sourceTexture.bytes[_pos + 2]);
                //pixels.push(sourceTexture.bytes[_pos + 3]);

                _w ++;
            }

            _h ++;

            _w = x;
        }

        _w = x2;

        _h = y2;

        var _j:Int = 0;
        
        for (j in 0...height) {

            for (i in 0...width) {

                var _pos = (_w + (_h * __width)) * bytesPerPixel;

                //bytes.buffer[_pos] = pixels[_j];
                //bytes.buffer[_pos + 1] = pixels[_j + 1];
                //bytes.buffer[_pos + 2] = pixels[_j + 2];
                //bytes.buffer[_pos + 3] = 255;

                bytes[_pos] = pixels[_j];
                bytes[_pos + 1] = pixels[_j + 1];
                bytes[_pos + 2] = pixels[_j + 2];
                bytes[_pos + 3] = 255;

                _j += 4;

                _w ++;
            }

            _h ++;

            _w = x;
        }

        upload(bytes, bytesPerPixel, __width, __height);
    }

    public function draw(x:UInt, y:UInt, width:UInt, height:UInt, color:Color):Void {

        var _x:UInt = 0;

        var _y:UInt = 0;

        var _w:UInt = x;

        var _h:UInt = y;

        for (j in 0...height) {

            for (i in 0...width) {

                setPixel(_w, _h, color);

                _w ++;
            }

            _h ++;

            _w = x;
        }

        upload(bytes, bytesPerPixel, __width, __height);
    }

    private function setPixel(x:UInt, y:UInt, color:Color):Void {

        var _pos = (x + (y * __width)) * bytesPerPixel;

        // for (i in _pos..._pos + bytesPerPixel) {

        //     bytes[i] = 1;
        // }

        bytes[_pos] = color.r;
        bytes[_pos + 1] = color.g;
        bytes[_pos + 2] = color.b;
        bytes[_pos + 3] = color.a;
    }

    public function upload(data:UInt8Array, bytesPerPixel:Int, width:Int, height:Int):Void {

        bytes = data;

        __bytesPerPixel = bytesPerPixel;

        __width = width;

        __height = height;

        if (__bytesPerPixel == 4) {

            __transparent = true;
        }
    }

    /** Getters and setters. **/

    private function get_bytesPerPixel():Int {

        return __bytesPerPixel;
    }

    private function get_dirty():Bool {
        
        return __dirty;
    }

    public function get_height():Int {
        
        return __height;
    }

    private function get_powerOfTwo():Bool {

        return ((__width != 0) && ((__width & (~__width + 1)) == __width)) && ((__height != 0) && ((__height & (~__height + 1)) == __height));
    }

    private function get_transparent():Bool {

        return __transparent;
    }
    
    public function get_width():Int {
        
        return __width;
    }
}