package drc.display;

@:enum abstract UniformFormat(Null<String>) {

	var FLOAT1 = "float1";
	
	var FLOAT2 = "float2";
	
	var FLOAT3 = "float3";
	
	var FLOAT4 = "float4";
	
	var INT1 = "int1";
	
	var INT2 = "int2";
	
	var INT3 = "int3";
	
	var INT4 = "int4";
	
	var MAT2 = "mat2";

	var MAT3 = "mat2";

	var MAT4 = "mat4";
	
	@:from private static function fromString(value:String):UniformFormat {

		return switch (value) {

			case "float1": FLOAT1;
			
			case "float2": FLOAT2;
			
			case "float3": FLOAT3;
			
			case "float4": FLOAT4;
			
			case "int1": INT1;
			
			case "int2": INT2;
			
			case "int3": INT3;
			
			case "int4": INT4;

			case "mat2": MAT2;

			case "mat3": MAT3;
			
			case "mat4": MAT4;
			
			default: null;
		}
	}
	
	@:to private function toString():String {

		return switch (cast this : UniformFormat) {
			
			case UniformFormat.FLOAT1: "float1";
			
			case UniformFormat.FLOAT2: "float2";
			
			case UniformFormat.FLOAT3: "float3";
			
			case UniformFormat.FLOAT4: "float4";
			
			case UniformFormat.INT1: "int1";
			
			case UniformFormat.INT2: "int2";
			
			case UniformFormat.INT3: "int3";
			
			case UniformFormat.INT4: "int4";
			
			case UniformFormat.MAT2: "mat2";

			case UniformFormat.MAT3: "mat3";

			case UniformFormat.MAT4: "mat4";
			
			default: null;
		}
	}
}
	