package drc.display;

import drc.utils.Common;
import drc.data.Profile;
import haxe.Json;

class Charmap extends Tilemap {

    public var defaultKerning:Int = 1;
	
	public var useKerningPairs:Bool = false;
	
    public var variants:Array<UInt>;
    
    public var size(get, null):Float;

    public var ascend:Float;

    public var descender:Float;

	// ** Privates.

	private var __ascender:Float;

	private var __descender:Float;

	private var __size:Float = 32;

    public function new(profile:Profile, font:String) {

        var _regions:Array<Region> = new Array<Region>();

        var _rootData:Dynamic = Json.parse(font);

        var _textureName:String = _rootData.name;

        __ascender = _rootData.ascender;

        __descender = _rootData.descender;

        ascend = __ascender + __descender;

        descender = __descender;

        if (Reflect.hasField(_rootData, "regions")) {
            
            var _regionData:Dynamic = Reflect.field(_rootData, "regions");

            for (i in 0..._regionData.length) {

                var id = _regionData[i].id;

                _regions[id] = _regionData[i].dimensions;
            }
        }

        super(profile, [Common.resources.getTexture('res/fonts/' + _textureName)], new Tileset(_regions));
    }

    // ** Getters and setters.

	private function get_size():Float {

		return __size;
	}
}