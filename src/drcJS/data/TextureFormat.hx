package drc.data;

@:enum abstract TextureFormat(Null<Int>) from Int to Int {

	var NONE = -1;

    var RED = 0x1903;

    var GREEN = 0x1904;

    var BLUE = 0x1905;

	var ALPHA = 0x1906;
	
	var RGB = 0x1907;
	
	var RGBA = 0x1908;
	
	var LUMINANCE = 0x1909;
	
	var LUMINANCE_ALPHA = 0x190A;

	@:from private static function fromString(value:String):TextureFormat {

		return switch (value) {

			case "none": NONE;

			case "red": RED;
			
			case "green": GREEN;
			
			case "blue": BLUE;
			
			case "alpha": ALPHA;
			
			case "rgb": RGB;
			
			case "rgba": RGBA;

			case "luminance": LUMINANCE;

			case "luminance_alpha": LUMINANCE_ALPHA;
			
			default: null;
		}
	}
	
	@:to private function toString():String {

		return switch (cast this: TextureFormat) {
			
			case TextureFormat.NONE: "none";

			case TextureFormat.RED: "red";
			
			case TextureFormat.GREEN: "green";
			
			case TextureFormat.BLUE: "blue";
			
			case TextureFormat.ALPHA: "alpha";
			
			case TextureFormat.RGB: "rgb";
			
			case TextureFormat.RGBA: "rgba";

			case TextureFormat.LUMINANCE: "luminance";

			case TextureFormat.LUMINANCE_ALPHA: "luminance_alpha";
			
			default: null;
		}
	}
}