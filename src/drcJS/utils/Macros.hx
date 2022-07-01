package drc.utils;

import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import Type as RunTimeType;

private class ExtensionsInit {}

class Macros {

    //macro static function getMain():Expr return macro $v{snow.types.Config.app_main};

    public static var extensions : Array<String>;

    macro public static function ext():Array<Field> {

        var fields = Context.getBuildFields();

        for (f in fields) {

            trace(f);
        }

        return Context.getBuildFields();
    }

    macro public static function getMain():Expr {

        var cls:Class<Dynamic> = RunTimeType.resolveClass('drc.core.App');

        trace(RunTimeType.getClassName(cls));

        //trace(RunTimeType.getClassName(RunTimeType.getClass(this)));

        //var inst:Dynamic = RunTimeType.createInstance(cls, []);

        //trace(inst.getNum());

        return macro null;
    }
}