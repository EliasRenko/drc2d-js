package drc.format;

import haxe.io.UInt8Array;
import haxe.io.Bytes;
import haxe.io.Input;

enum Color {

    ColGrey( alpha : Bool ) ; // 1|2|4|8|16 without alpha , 8|16 with alpha
    
    ColTrue( alpha : Bool ); // 8|16
    
	ColIndexed; // 1|2|4|8
}

typedef Header = {

    var width : Int;
    
    var height : Int;
    
    var colbits : Int;
    
    var color : Color;
    
	var interlaced : Bool;
}

enum Chunk {

    CEnd;
    
    CHeader( h : Header );
    
    CData( b : haxe.io.Bytes );
    
    CPalette( b : haxe.io.Bytes );
    
	CUnknown( id : String, data : haxe.io.Bytes );
}

class PNG {

    // ** Publics.

    public var data:List<Chunk>;

    public function new(input:haxe.io.Input) {

        

        input.bigEndian = true;

        var pos = 0;

        for (i in [137,80,78,71,13,10,26,10]) {
         
            if (input.readByte() != i) {

                throw "Invalid header";
            }

            pos ++;
        }

        var l = new List();

        while(true) {

            var c = readChunk(input);
            
            //var c = null;

            l.add(c);
            
			if( c == CEnd )
				break;
        }
        
        data = l;

        //** **/

        var header = getHeader(data);
    }

    public static function getHeader( d : List<Chunk> ) : Header {
		for( c in d )
			switch( c ) {
			case CHeader(h): return h;
			default:
			}
        throw "Header not found";
	}

    public function readChunk(i:Input) {

        var dataLen = i.readInt32();

        var id = i.readString(4);
        
        var data = i.read(dataLen);
        
        var crc = i.readInt32();
        
		if( true ) {
			
			var c = new haxe.crypto.Crc32();
			for( i in 0...4 )
				c.byte(id.charCodeAt(i));
			c.update(data, 0, data.length);
			if( c.get() != crc )
				throw "CRC check failure";
			
		}
		return switch( id ) {
		case "IEND": CEnd;
		case "IHDR": CHeader(readHeader(new haxe.io.BytesInput(data)));
		case "IDAT": CData(data);
		case "PLTE": CPalette(data);
		default: CUnknown(id,data);
		}
    }

    public function readHeader(i:Input):Header {

        i.bigEndian = true;
	
		var width = i.readInt32();
		var height = i.readInt32();
		
		var colbits = i.readByte();
        var color = i.readByte();
        
		var color = switch( color ) {
		case 0: ColGrey(false);
		case 2: ColTrue(false);
		case 3: ColIndexed;
		case 4: ColGrey(true);
		case 6: ColTrue(true);
		default: throw "Unknown color model "+color+":"+colbits;
		};
		var compress = i.readByte();
		var filter = i.readByte();
		if( compress != 0 || filter != 0 )
			throw "Invalid header";
		var interlace = i.readByte();
		if( interlace != 0 && interlace != 1 )
			throw "Invalid header";
		return {
			width : width,
			height : height,
			colbits : colbits,
			color : color,
			interlaced : interlace == 1,
		};
    }

    public function extract(flipY:Bool = false):Bytes {

        var d:List<Chunk> = this.data;

        var bytes = null;

        var h = getHeader(d);

        var bgra = bytes == null ? haxe.io.Bytes.alloc(h.width * h.height * 4) : bytes;
        
        var data = null;
        
        var fullData : haxe.io.BytesBuffer = null;
        
        for(c in d) {

            switch(c) {

                case CData(b):

                    if(fullData != null) fullData.add(b);

                    else if( data == null ) data = b;

                    else {

                        fullData = new haxe.io.BytesBuffer();

                        fullData.add(data);

                        fullData.add(b);

                        data = null;
                    }

                default:
            }
        }

        if( fullData != null )
            data = fullData.getBytes();
        if( data == null )
            throw "Data not found";

        data = haxe.zip.Uncompress.run(data);

            var r = 0, w = 0;
            var lineDelta = 0;
            if( flipY ) {
                lineDelta = -h.width * 8;
                w = (h.height - 1) * (h.width * 4);
            }
            var flipY = flipY ? -1 : 1;

            switch( h.color ) {

                case ColIndexed:

                    var pal = getPalette(d);

                    if( pal == null ) throw "PNG Palette is missing";

                    var alpha = null;

                    for( t in d )
                        switch( t ) {
                        case CUnknown("tRNS", data): alpha = data; break;
                        default:
                        }

                        if( alpha != null && alpha.length < 1 << h.colbits ) {
                            var alpha2 = haxe.io.Bytes.alloc(1 << h.colbits);
                            alpha2.blit(0,alpha,0,alpha.length);
                            alpha2.fill(alpha.length, alpha2.length - alpha.length, 0xFF);
                            alpha = alpha2;
                        }
            
                        var width = h.width;
                        var stride = Math.ceil(width * h.colbits / 8) + 1;
            
                        if( data.length < h.height * stride ) throw "Not enough data";
            
                        var tmp = (h.width * h.colbits);
                        var rline = tmp >> 3;
                        for( y in 0...h.height ) {
                            var f = data.get(r++);
                            if( f == 0 ) {
                                r += rline;
                                continue;
                            }
                            switch( f ) {
                            case 1:
                                var c = 0;
                                for( x in 0...width ) {
                                    var v = data.get(r);
                                    c += v;
                                    data.set(r++, c & 0xFF);
                                }
                            case 2:
                                var stride = y == 0 ? 0 : (rline + 1);
                                for( x in 0...width ) {
                                    var v = data.get(r);
                                    data.set(r, v + data.get(r - stride));
                                    r++;
                                }
                            case 3:
                                var c = 0;
                                var stride = y == 0 ? 0 : (rline + 1);
                                for( x in 0...width ) {
                                    var v = data.get(r);
                                    c = (v + ((c + data.get(r - stride)) >> 1)) & 0xFF;
                                    data.set(r++, c);
                                }
                            case 4:
                                var stride = rline + 1;
                                var c = 0;
                                for( x in 0...width ) {
                                    var v = data.get(r);
                                    c = (filter(data, x, y, stride, c, r, 1) + v) & 0xFF;
                                    data.set(r++, c);
                                }
                            default:
                                throw "Invalid filter "+f;
                            }
                        }
            
                        var r = 0;
                        if( h.colbits == 8 ) {
                            for( y in 0...h.height ) {
                                r++;
                                for( x in 0...h.width ) {
                                    var c = data.get(r++);
                                    bgra.set(w++, pal.get(c * 3 + 2));
                                    bgra.set(w++, pal.get(c * 3 + 1));
                                    bgra.set(w++, pal.get(c * 3));
                                    bgra.set(w++, if( alpha != null ) alpha.get(c) else 0xFF);
                                }
                                w += lineDelta;
                            }
                        } else if( h.colbits < 8 ) {
                            var req = h.colbits;
                            var mask = (1 << req) - 1;
                            for( y in 0...h.height ) {
                                r++;
                                var bits = 0, nbits = 0, v;
                                for( x in 0...h.width ) {
                                    if( nbits < req ) {
                                        bits = (bits << 8) | data.get(r++);
                                        nbits += 8;
                                    }
                                    var c = (bits >>> (nbits - req)) & mask;
                                    nbits -= req;
                                    bgra.set(w++, pal.get(c * 3 + 2));
                                    bgra.set(w++, pal.get(c * 3 + 1));
                                    bgra.set(w++, pal.get(c * 3));
                                    bgra.set(w++, if( alpha != null ) alpha.get(c) else 0xFF);
                                }
                                w += lineDelta;
                            }
                        } else
                            throw h.colbits+" indexed bits per pixel not supported";
            
                case ColGrey(alpha):
			if( h.colbits != 8 )
				throw "Unsupported color mode";
			var width = h.width;
			var stride = (alpha ? 2 : 1) * width + 1;
			if( data.length < h.height * stride ) throw "Not enough data";

			// transparent palette extension
			var alphvaIdx:Int = -1;
			if (!alpha)
				for( t in d )
					switch( t ) {
					case CUnknown("tRNS", data):
						if (data.length >= 2) alphvaIdx = data.get(1); // Since library supports only 8-bit greyscale, not bothered with conversions.
						break;
					default:
					}


			#if flash10
			var bytes = data.getData();
			var start = h.height * stride;
			bytes.length = start + h.width * h.height * 4;
			if( bytes.length < 1024 ) bytes.length = 1024;
			flash.Memory.select(bytes);
			var realData = data, realRgba = bgra;
			var data = format.tools.MemoryBytes.make(0);
			var bgra = format.tools.MemoryBytes.make(start);
			#end

			for( y in 0...h.height ) {
				var f = data.get(r++);
				switch( f ) {
				case 0:
					if( alpha )
						for( x in 0...width ) {
							var v = data.get(r++);
							bgra.set(w++,v);
							bgra.set(w++,v);
							bgra.set(w++,v);
							bgra.set(w++,data.get(r++));
						}
					else
						for( x in 0...width ) {
							var v = data.get(r++);
							bgra.set(w++,v);
							bgra.set(w++,v);
							bgra.set(w++,v);
							bgra.set(w++,v == alphvaIdx ? 0 : 0xFF);
						}
				case 1:
					var cv = 0, ca = 0;
					if( alpha )
						for( x in 0...width ) {
							cv += data.get(r++);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							ca += data.get(r++);
							bgra.set(w++,ca);
						}
					else
						for( x in 0...width ) {
							cv += data.get(r++);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++,cv == alphvaIdx ? 0 : 0xFF);
						}
				case 2:
					var stride = y == 0 ? 0 : width * 4 * flipY;
					if( alpha )
						for( x in 0...width ) {
							var v = data.get(r++) + bgra.get(w - stride);
							bgra.set(w++, v);
							bgra.set(w++, v);
							bgra.set(w++, v);
							bgra.set(w++, data.get(r++) + bgra.get(w - stride));
						}
					else
						for( x in 0...width ) {
							var v = data.get(r++) + bgra.get(w - stride);
							bgra.set(w++, v);
							bgra.set(w++, v);
							bgra.set(w++, v);
							bgra.set(w++, v == alphvaIdx ? 0 : 0xFF);
						}
				case 3:
					var cv = 0, ca = 0;
					var stride = y == 0 ? 0 : width * 4 * flipY;
					if( alpha )
						for( x in 0...width ) {
							cv = (data.get(r++) + ((cv + bgra.get(w - stride)) >> 1)) & 0xFF;
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							ca = (data.get(r++) + ((ca + bgra.get(w - stride)) >> 1)) & 0xFF;
							bgra.set(w++,ca);
						}
					else
						for( x in 0...width ) {
							cv = (data.get(r++) + ((cv + bgra.get(w - stride)) >> 1)) & 0xFF;
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++,cv);
							bgra.set(w++, cv == alphvaIdx ? 0 : 0xFF);
						}
				case 4:
					var stride = width * 4 * flipY;
					var cv = 0, ca = 0;
					if( alpha )
						for( x in 0...width ) {
							cv = (filter(bgra, x, y, stride, cv, w) + data.get(r++)) & 0xFF;
							bgra.set(w++, cv);
							bgra.set(w++, cv);
							bgra.set(w++, cv);
							ca = (filter(bgra, x, y, stride, ca, w) + data.get(r++)) & 0xFF;
							bgra.set(w++, ca);
						}
					else
						for( x in 0...width ) {
							cv = (filter(bgra, x, y, stride, cv, w) + data.get(r++)) & 0xFF;
							bgra.set(w++, cv);
							bgra.set(w++, cv);
							bgra.set(w++, cv);
							bgra.set(w++, cv == alphvaIdx ? 0 : 0xFF);
						}
				default:
					throw "Invalid filter "+f;
				}
				w += lineDelta;
			}

			#if flash10
			var b = realRgba.getData();
			b.position = 0;
			b.writeBytes(realData.getData(), start, h.width * h.height * 4);
            #end
            

                case ColGrey(alpha):
                    if( h.colbits != 8 )
                        throw "Unsupported color mode";
                    var width = h.width;
                    var stride = (alpha ? 2 : 1) * width + 1;
                    if( data.length < h.height * stride ) throw "Not enough data";
        
                    // transparent palette extension
                    var alphvaIdx:Int = -1;
                    if (!alpha)
                        for( t in d )
                            switch( t ) {
                            case CUnknown("tRNS", data):
                                if (data.length >= 2) alphvaIdx = data.get(1); // Since library supports only 8-bit greyscale, not bothered with conversions.
                                break;
                            default:
                            }
        
        
                    #if flash10
                    var bytes = data.getData();
                    var start = h.height * stride;
                    bytes.length = start + h.width * h.height * 4;
                    if( bytes.length < 1024 ) bytes.length = 1024;
                    flash.Memory.select(bytes);
                    var realData = data, realRgba = bgra;
                    var data = format.tools.MemoryBytes.make(0);
                    var bgra = format.tools.MemoryBytes.make(start);
                    #end
        
                    for( y in 0...h.height ) {
                        var f = data.get(r++);
                        switch( f ) {
                        case 0:
                            if( alpha )
                                for( x in 0...width ) {
                                    var v = data.get(r++);
                                    bgra.set(w++,v);
                                    bgra.set(w++,v);
                                    bgra.set(w++,v);
                                    bgra.set(w++,data.get(r++));
                                }
                            else
                                for( x in 0...width ) {
                                    var v = data.get(r++);
                                    bgra.set(w++,v);
                                    bgra.set(w++,v);
                                    bgra.set(w++,v);
                                    bgra.set(w++,v == alphvaIdx ? 0 : 0xFF);
                                }
                        case 1:
                            var cv = 0, ca = 0;
                            if( alpha )
                                for( x in 0...width ) {
                                    cv += data.get(r++);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    ca += data.get(r++);
                                    bgra.set(w++,ca);
                                }
                            else
                                for( x in 0...width ) {
                                    cv += data.get(r++);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv == alphvaIdx ? 0 : 0xFF);
                                }
                        case 2:
                            var stride = y == 0 ? 0 : width * 4 * flipY;
                            if( alpha )
                                for( x in 0...width ) {
                                    var v = data.get(r++) + bgra.get(w - stride);
                                    bgra.set(w++, v);
                                    bgra.set(w++, v);
                                    bgra.set(w++, v);
                                    bgra.set(w++, data.get(r++) + bgra.get(w - stride));
                                }
                            else
                                for( x in 0...width ) {
                                    var v = data.get(r++) + bgra.get(w - stride);
                                    bgra.set(w++, v);
                                    bgra.set(w++, v);
                                    bgra.set(w++, v);
                                    bgra.set(w++, v == alphvaIdx ? 0 : 0xFF);
                                }
                        case 3:
                            var cv = 0, ca = 0;
                            var stride = y == 0 ? 0 : width * 4 * flipY;
                            if( alpha )
                                for( x in 0...width ) {
                                    cv = (data.get(r++) + ((cv + bgra.get(w - stride)) >> 1)) & 0xFF;
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    ca = (data.get(r++) + ((ca + bgra.get(w - stride)) >> 1)) & 0xFF;
                                    bgra.set(w++,ca);
                                }
                            else
                                for( x in 0...width ) {
                                    cv = (data.get(r++) + ((cv + bgra.get(w - stride)) >> 1)) & 0xFF;
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++,cv);
                                    bgra.set(w++, cv == alphvaIdx ? 0 : 0xFF);
                                }
                        case 4:
                            var stride = width * 4 * flipY;
                            var cv = 0, ca = 0;
                            if( alpha )
                                for( x in 0...width ) {
                                    cv = (filter(bgra, x, y, stride, cv, w) + data.get(r++)) & 0xFF;
                                    bgra.set(w++, cv);
                                    bgra.set(w++, cv);
                                    bgra.set(w++, cv);
                                    ca = (filter(bgra, x, y, stride, ca, w) + data.get(r++)) & 0xFF;
                                    bgra.set(w++, ca);
                                }
                            else
                                for( x in 0...width ) {
                                    cv = (filter(bgra, x, y, stride, cv, w) + data.get(r++)) & 0xFF;
                                    bgra.set(w++, cv);
                                    bgra.set(w++, cv);
                                    bgra.set(w++, cv);
                                    bgra.set(w++, cv == alphvaIdx ? 0 : 0xFF);
                                }
                        default:
                            throw "Invalid filter "+f;
                        }
                        w += lineDelta;
                    }
        
                    #if flash10
                    var b = realRgba.getData();
                    b.position = 0;
                    b.writeBytes(realData.getData(), start, h.width * h.height * 4);
                    #end

                case ColTrue(alpha):

                    if( h.colbits != 8 )
                        throw "Unsupported color mode";

                    var width = h.width;

                    var stride = (alpha ? 4 : 3) * width + 1;

                    if( data.length < h.height * stride ) throw "Not enough data";
        
                    var alphaRed:Int = -1;
                    var alphaGreen:Int = -1;
                    var alphaBlue:Int = -1;

                    if (!alpha) {

                        for( t in d ) {

                            switch( t ) {

                            case CUnknown("tRNS", data):

                                if (data.length >= 6) {

                                    alphaRed = data.get(1);
                                    alphaGreen = data.get(3);
                                    alphaBlue = data.get(5);
                                }
                                break;

                            default:
                            }
                        }
                    }

                    var cr = 0, cg = 0, cb = 0, ca = 0;

                    inline function getAlphaValue():Int
                    {
                        return (cr == alphaRed && cg == alphaGreen && cb == alphaBlue) ? 0 : 0xff;
                    }

                    // PNG data is encoded as RGB[A]
                    for( y in 0...h.height ) {
                        var f = data.get(r++);
                        switch( f ) {
                        case 0:
                            if( alpha )
                                for( x in 0...width ) {
                                    bgra.set(w++,data.get(r));
                                    bgra.set(w++,data.get(r+1));
                                    bgra.set(w++,data.get(r+2));
                                    bgra.set(w++,data.get(r+3));
                                    r += 4;
                                }
                            else
                                for( x in 0...width ) {
                                    bgra.set(w++,cr = data.get(r));
                                    bgra.set(w++,cg = data.get(r + 1));
                                    bgra.set(w++,cb = data.get(r + 2));
                                    bgra.set(w++,getAlphaValue());
                                    r += 3;
                                }
                        case 1:
                            cr = cg = cb = ca = 0;
                            if( alpha )
                                for(x in 0...width ) {

                                    // cr += data.get(r);
                                    // bgra.set(w++,cr);

                                    // cg += data.get(r + 1);
                                    // bgra.set(w++,cg);

                                    // cb += data.get(r + 2);
                                    // bgra.set(w++,cb);

                                    // ca += data.get(r + 3);	
                                    // bgra.set(w++,ca);

                                    // r += 4;

                                    cr += data.get(r);
                                    bgra.set(w++,cr);

                                    cg += data.get(r + 1);
                                    bgra.set(w++,cg);

                                    cb += data.get(r + 2);
                                    bgra.set(w++,cb);

                                    ca += data.get(r + 3);	
                                    bgra.set(w++,ca);

                                    r += 4;
                                }
                            else
                                for( x in 0...width ) {
                                   
                                    cr += data.get(r);
                                    cg += data.get(r + 1);
                                    cb += data.get(r + 2);	
                                    

                                    bgra.set(w++,cr);
                                    bgra.set(w++,cg);
                                    bgra.set(w++,cb);

                                    bgra.set(w++,getAlphaValue());
                                    r += 3;
                                }
                        case 2:
                            var stride = y == 0 ? 0 : width * 4 * flipY;
                            if( alpha )
                                for( x in 0...width ) {
                                    bgra.set(w, data.get(r) + bgra.get(w - stride));	w++;
                                    bgra.set(w, data.get(r + 1) + bgra.get(w - stride));	w++;
                                    bgra.set(w, data.get(r + 2) + bgra.get(w - stride));	w++;
                                    bgra.set(w, data.get(r + 3) + bgra.get(w - stride));	w++;
                                    r += 4;
                                }
                            else
                                for( x in 0...width ) {
                                    bgra.set(w, cb = data.get(r) + bgra.get(w - stride));	w++;
                                    bgra.set(w, cg = data.get(r + 1) + bgra.get(w - stride));	w++;
                                    bgra.set(w, cr = data.get(r + 2) + bgra.get(w - stride));		w++;
                                    bgra.set(w++,getAlphaValue());
                                    r += 3;
                                }
                        case 3:
                            cr = cg = cb = ca = 0;
                            var stride = y == 0 ? 0 : width * 4 * flipY;
                            if( alpha )
                                for( x in 0...width ) {
                                    cb = (data.get(r + 0) + ((cb + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cb);
                                    cg = (data.get(r + 1) + ((cg + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cg);
                                    cr = (data.get(r + 2) + ((cr + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cr);
                                    ca = (data.get(r + 3) + ((ca + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, ca);
                                    r += 4;
                                }
                            else
                                for( x in 0...width ) {
                                    cb = (data.get(r + 0) + ((cb + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cb);
                                    cg = (data.get(r + 1) + ((cg + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cg);
                                    cr = (data.get(r + 2) + ((cr + bgra.get(w - stride)) >> 1)) & 0xFF;	bgra.set(w++, cr);
                                    bgra.set(w++,getAlphaValue());
                                    r += 3;
                                }
                        case 4:
                            var stride = width * 4 * flipY;
                            cr = cg = cb = ca = 0;
                            if( alpha )
                                for( x in 0...width ) {
                                    cb = (filter(bgra, x, y, stride, cb, w) + data.get(r + 0)) & 0xFF;
                                    bgra.set(w++, cb);

                                    cg = (filter(bgra, x, y, stride, cg, w) + data.get(r + 1)) & 0xFF;
                                    bgra.set(w++, cg);

                                    cr = (filter(bgra, x, y, stride, cr, w) + data.get(r + 2)) & 0xFF;
                                    bgra.set(w++, cr);

                                    ca = (filter(bgra, x, y, stride, ca, w) + data.get(r + 3)) & 0xFF;
                                    bgra.set(w++, ca);

                                    r += 4;
                                }
                            else
                                for( x in 0...width ) {
                                    cb = (filter(bgra, x, y, stride, cb, w) + data.get(r + 0)) & 0xFF; 
                                    bgra.set(w++, cb);

                                    cg = (filter(bgra, x, y, stride, cg, w) + data.get(r + 1)) & 0xFF;
                                    bgra.set(w++, cg);

                                    cr = (filter(bgra, x, y, stride, cr, w) + data.get(r + 2)) & 0xFF;
                                    bgra.set(w++, cr);
                                    
                                    bgra.set(w++,getAlphaValue());
                                    r += 3;
                                }
                        default:
                            throw "Invalid filter "+f;
                        }
                        w += lineDelta;
                    }


                default:

                    throw 'Color is not truetype.';

                return bgra;

                    
            }

            //return brgaToRgba(bgra);

            return bgra;
        }

        public static function getPalette( d : List<Chunk> ) : haxe.io.Bytes {
            for( c in d )
                switch( c )  {
                case CPalette(b): return b;
                default:
                }
            return null;
	    }

        static inline function filter( data : haxe.io.Bytes, x, y, stride, prev, p, numChannels=4 ) {
            var b = y == 0 ? 0 : data.get(p - stride);
            var c = x == 0 || y == 0  ? 0 : data.get(p - stride - numChannels);
            var k = prev + b - c;
            var pa = k - prev; if( pa < 0 ) pa = -pa;
            var pb = k - b; if( pb < 0 ) pb = -pb;
            var pc = k - c; if( pc < 0 ) pc = -pc;
            return (pa <= pb && pa <= pc) ? prev : (pb <= pc ? b : c);
        }    
}