package drc.display;

@:enum abstract BlendFactor(Null<Int>) from Int to Int
{
	var NONE = -1;

	var ZERO = 0;
	
	var ONE = 1;
	
	var SRC_COLOR = 0x0300;
	
	var ONE_MINUS_SRC_COLOR = 0x0301;
	
	var SRC_ALPHA = 0x0302;
	
	var ONE_MINUS_SRC_ALPHA = 0x0303;

	var DST_ALPHA = 0x0304;

	var ONE_MINUS_DST_ALPHA = 0x0305;

	var DST_COLOR = 0x0306;

	var ONE_MINUS_DST_COLOR = 0x0307;
	
    var SRC_ALPHA_SATURATE = 0x0308;

	@:from private static function fromString(value:String):BlendFactor
	{
		return switch (value)
		{
			case "none": NONE;

			case "zero": ZERO;
			
			case "one": ONE;
			
			case "src_color": SRC_COLOR;
			
			case "one_minus_src_color": ONE_MINUS_SRC_COLOR;
			
			case "src_alpha": SRC_ALPHA;
			
			case "one_minus_src_alpha": ONE_MINUS_SRC_ALPHA;

			case "dst_alpha": DST_ALPHA;

			case "one_minus_dst_alpha": ONE_MINUS_DST_ALPHA;

			case "dst_color": DST_COLOR;

			case "one_minus_dst_color": ONE_MINUS_DST_COLOR;

			case "src_alpha_saturate": SRC_ALPHA_SATURATE;
			
			default: null;
		}
	}
	
	@:to private function toString():String
	{
		return switch (cast this: BlendFactor)
		{
			case BlendFactor.NONE: "none";

			case BlendFactor.ZERO: "zero";
			
			case BlendFactor.ONE: "one";
			
			case BlendFactor.SRC_COLOR: "src_color";
			
			case BlendFactor.ONE_MINUS_SRC_COLOR: "one_minus_src_color";
			
			case BlendFactor.SRC_ALPHA: "src_alpha";
			
			case BlendFactor.ONE_MINUS_SRC_ALPHA: "one_minus_src_alpha";

			case BlendFactor.DST_ALPHA: "dst_alpha";

			case BlendFactor.ONE_MINUS_DST_ALPHA: "one_minus_dst_alpha";

			case BlendFactor.DST_COLOR: "dst_color";

			case BlendFactor.ONE_MINUS_DST_COLOR: "one_minus_dst_color";

			case BlendFactor.SRC_ALPHA_SATURATE: "src_alpha_saturate";
			
			default: null;
		}
	}
}