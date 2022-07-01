package drc.display;

import drc.data.Profile;
import drc.data.Texture;
import drc.display.Drawable;
import drc.math.Vector4;

class Image extends Drawable {
	
	// ** Publics.

	// ** Privates.

	public function new(profile:Profile, textures:Array<Texture>) {

		// ** Super.

		super(profile);
		
		// ** Insert vertex data.

		vertices.insert(profile.dataPerVertex * 4);

		// ** If textures are null...

		setTextures(textures);

		//this.textures[0].generate(256, 256);
			
		// ** Set the UV.

		setUV(0, 0, 1, 1);
		
		// ** Upload index data.

		indices = [0, 1, 2, 0, 2, 3];
		
		// **

		__verticesToRender = 4;
		
		// **

		__indicesToRender = 6;
	}

	override function setAttribute(name:String, value:Float) {

		#if debug // ------
		
		if (!shadings.exists(name)) {

			throw "Attribute: " + name + " does not exist.";
		}
		
		#end // ------
		
		for (i in 0...4) {

			vertices[shadings[name].positions[i]] = value;
		}
	}

	public function centerOrigin():Void {

		originX = __width / 2;
		
		originY = __height / 2;
	}
		
	public function createTexture(width:Int, height:Int, color:Int = 0xFFFFFF):Void {

		//textures[0].uploadBitmapData(new BitmapData(width, height, false, color));

		var texture = new Texture();

		texture.generate(width, height, 1, color);

		setTextures([texture]);
	}

	public function setTextures(textures:Array<Texture>) {
		
		if (textures.length == 0) {

			return;
		}
		else {

			if (textures.length == profile.textureCount) {

				this.textures = textures;
			}
			else {

				for (i in 0...textures.length) {

					this.textures[i] = textures[i];
				}
			}

			// ** Set the width of the texture.

			width = textures[0].width;
			
			// ** Set the height of the texture.

			height = textures[0].height;
		}
	}
	
	override function setUV(x:Float, y:Float, width:Float, height:Float):Void {

		vertices[shadings["u"].positions[0]] = x;
		
		vertices[shadings["u"].positions[1]] = x;
		
		vertices[shadings["u"].positions[2]] = width;
		
		vertices[shadings["u"].positions[3]] = width;
		
		vertices[shadings["v"].positions[0]] = y;
		
		vertices[shadings["v"].positions[1]] = height;
		
		vertices[shadings["v"].positions[2]] = height;
		
		vertices[shadings["v"].positions[3]] = y;
	}

	override function render():Void {

		if (__shouldTransform) {

			matrix.identity();

			matrix.appendScale(__scaleX, __scaleY, 1);

			matrix.appendRotation(__angle, Vector4.Y_AXIS);

			matrix.appendTranslation(__x, __y, __z);

			__shouldTransform = false;
		}
	}

	//** Getters and setters.
	
	override function set_angle(value:Float):Float {

		__shouldTransform = true;

		return super.set_angle(value);
	}

	override function set_height(value:Float):Float {

		vertices[shadings["y"].positions[0]] = 0 - originY;
		
		vertices[shadings["y"].positions[1]] = value - originY;
		
		vertices[shadings["y"].positions[2]] = value - originY;
		
		vertices[shadings["y"].positions[3]] = 0 - originY;
		
		return super.set_height(value);
	}
		
	override function set_scaleX(value:Float):Float {

		super.set_scaleX(value);
		
		__shouldTransform = true;

		return __scaleX;
	}
		
	override function set_scaleY(value:Float):Float {

		super.set_scaleY(value);
		
		__shouldTransform = true;

		return __scaleY;
	}

	override function set_originX(value:Float):Float {

		super.set_originX(value);
		
		width = __width;
		
		return __originX;
	}
		
	override function set_originY(value:Float):Float {

		super.set_originY(value);
		
		height = __height;
		
		return __originY;
	}
	
	override function set_width(value:Float):Float {

		vertices[shadings["x"].positions[0]] = 0 - originX;
		
		vertices[shadings["x"].positions[1]] = 0 - originX;
		
		vertices[shadings["x"].positions[2]] = value - originX;
		
		vertices[shadings["x"].positions[3]] = value - originX;
		
		return super.set_width(value);
	}

	override function set_x(value:Float):Float {

		__shouldTransform = true;

		return __x = value;
	}
		
	override function set_y(value:Float):Float {

		__shouldTransform = true;

		return __y = value;
	}
}