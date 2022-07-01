package drc.macros;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import sys.FileSystem;

using StringTools;

class AssetPaths {

	macro public static function build(path:String = 'assets/'):Array<Field> {

		var _workingDirectory:String = Sys.getCwd();

		trace('WD: ' + _workingDirectory);

		path = Context.resolvePath(_workingDirectory + Path.addTrailingSlash(path));
		
		var files = readDirectory(path);
		
		var fields:Array<Field> = Context.getBuildFields();

		for (f in files) {

			fields.push({
				name: f.name,
				doc: f.value,
				access: [APublic, AStatic, AInline],
				kind: FVar(macro:String, macro $v{ f.value }),
				pos: Context.currentPos()
			});
		}
		
		fields.push({

			name: "all",
			doc: "A list of all asset paths",
			access: [APublic, AStatic],
			kind: FVar(macro:Array<String>, macro $a{files.map(function(f) return macro $v{f.value})}),
			pos: Context.currentPos(),
		});
		
		return fields;
	}
	
	private static function readDirectory(path:String) {

		path = Path.addTrailingSlash(path);
		
		var result = [];
		
		for(f in FileSystem.readDirectory(path)) {

			var fullpath = path + f;
			if (FileSystem.isDirectory(fullpath)) 
				result = result.concat(readDirectory(fullpath));
			else
				result.push({name:convertPathToVarName('__' + Path.withoutDirectory(fullpath)), value:fullpath});
		}
		
		return result;
	}
	
	private static function convertPathToVarName(path:String) {

		return path.replace("/", "__").replace(".", "_").replace(" ", "_").replace("-", "_");
	}
}