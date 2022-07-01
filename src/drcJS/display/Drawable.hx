package drc.display;

import drc.data.Indices;
import drc.objects.State;
import drc.display.Graphic;
import drc.data.Profile;
import drc.data.Texture;
import drc.math.Matrix;
import drc.display.Shading;
import drc.display.UniformParam;

typedef BlendFactors = {
	
	source:Int,

	destination:Int
}

typedef TextureParameters = {

	magnification:Int,

	minification:Int,

	wrapX:Int,

	wrapY:Int
}

class Drawable extends Graphic {

	//** Publics.

	public var mode:Int = 0x0004;
	
	public var blendFactors:BlendFactors;

	/**
	 * The indices of the graphic.
	 */
	public var indices:Indices = new Indices([]);
	
	/**
	 * The profile of the graphic.
	 */
	public var profile:Profile;

	public var textureParams:TextureParameters;

	/**
	 * The textures of the graphic.
	 */
	public var textures:Array<Texture> = new Array<Texture>();

	/**
	 * The matrix of the graphic.
	 */
	public var matrix:Matrix = new Matrix();

	/**
	 * The shadings of the graphic.
	 */
	public var shadings:Map<String, Shading> = new Map<String, Shading>();

	/**
	 * The shadings of the graphic.
	 */
	public var uniforms:Map<String, UniformParam<Dynamic>> = new Map<String, UniformParam<Dynamic>>();

	// ** Privates.
	
	// ** Methods.
	
	/** @private **/ public var __indicesToRender:UInt = 0;
	
	/** @private **/ private var __state:State;

	public function new(profile:Profile) {

		if (profile == null) throw 'Profile cannot be null';

		super(0, 0);
		
		this.profile = profile;
		
		blendFactors = {

			source: BlendFactor.SRC_ALPHA,

			destination: BlendFactor.ONE_MINUS_SRC_ALPHA
		}

		textureParams = {

			magnification: 0x2600,

			minification: 0x2600,

			wrapX: 0x812F,

			wrapY: 0x812F
		}

		for (i in 0...profile.attributes.length) {

			for (j in 0...profile.attributes[i].__pointers.length) {

				var _name:String = profile.attributes[i].__pointers[j].name;

				var _pos:Int = profile.attributes[i].__pointers[j].position;

				var _positions:Array<Int> = new Array<Int>();

				var sum:Int = _pos;

				for (i in 0...4) {

					_positions.push(sum);

					sum += profile.dataPerVertex;
				}

				var shading:Shading =
				{
					positions: _positions
				}

				shadings.set(_name, shading);
			}
		}

		for (uniform in profile.uniforms) {

			__setUniform(uniform);
		}
	}

	public function remove():Void {

		__state.removeGraphic(this);

		super.release();
	}

	public function setUV(x:Float, y:Float, width:Float, height:Float):Void {	

		vertices[shadings["u"].positions[0]] = x;
		
		vertices[shadings["u"].positions[1]] = x;
		
		vertices[shadings["u"].positions[2]] = width;
		
		vertices[shadings["u"].positions[3]] = width;
		
		vertices[shadings["v"].positions[0]] = y;
		
		vertices[shadings["v"].positions[1]] = height;
		
		vertices[shadings["v"].positions[2]] = height;
		
		vertices[shadings["v"].positions[3]] = y;
	}

	private function __setUniform(uniform:Uniform):Void {

		switch (uniform.format) {

			case FLOAT1:

				uniforms.set(uniform.name, new UniformParam<Float>([1.0], uniform.location, uniform.format));

			case FLOAT2:

				uniforms.set(uniform.name, new UniformParam<Float>([1.0, 1.0], uniform.location, uniform.format));

			case FLOAT3:

				uniforms.set(uniform.name, new UniformParam<Float>([1.0, 1.0, 1.0], uniform.location, uniform.format));

			case FLOAT4:

				uniforms.set(uniform.name, new UniformParam<Float>([1.0, 1.0, 1.0, 1.0], uniform.location, uniform.format));

			case INT1:

				uniforms.set(uniform.name, new UniformParam<Int>([1], uniform.location, uniform.format));

			case INT2:

				uniforms.set(uniform.name, new UniformParam<Int>([1, 1], uniform.location, uniform.format));

			case INT3:

				uniforms.set(uniform.name, new UniformParam<Int>([1, 1, 1], uniform.location, uniform.format));

			case INT4:

				uniforms.set(uniform.name, new UniformParam<Int>([1, 1, 1, 1], uniform.location, uniform.format));

			case MAT4:

				//uniforms.set(uniform.name, new UniformParam<Matrix>(new Matrix(), uniform.location, uniform.format));

			default: 'Invalid uniform format.';
		}
	}

	// ** Getters and setters.

	override function set_x(value:Float):Float {

		return super.set_x(value);
	}

	override function set_y(value:Float):Float {

		return super.set_y(value);
	}
}