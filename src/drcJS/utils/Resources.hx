package drcJS.utils;

//import js.lib.Uint8Array;
//import haxe.io.UInt8Array;
import js.html.URL;
#if js

import drcJS.utils.HTTPRequest;
import js.html.File;
import js.html.XMLHttpRequestResponseType;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;
import haxe.io.UInt8Array;

class Resources {

    public static function getDirectory():String {
        
        return '';
    }

    public static function loadBytes(path:String, func:(Int, Dynamic)->Void):Void {
        
    }

    public static function loadText(path:String, func:(Int, Dynamic)->Void):Void {

        // if 

        // if ((new URL(url, window.location.href)).origin !== window.location.origin) {
            
        // }

        //var url:URL = new URL(path);

        //url.origin = "";

        var __request:HTTPRequest = new HTTPRequest(path, '');

        __request.load(func, XMLHttpRequestResponseType.TEXT);
    }

    public static function loadTexture(path:String, func:(Int, Dynamic)->Void):Void {

        var __request:HTTPRequest = new HTTPRequest(path, '');

        __request.load(function(status, response) {

            func(status, new UInt8Array(response));

        }, XMLHttpRequestResponseType.ARRAYBUFFER);
    }

    public static function loadProfile(path:String, func:(Int, Dynamic)->Void):Void {

        var __request:HTTPRequest = new HTTPRequest(path, '');

        __request.load(func, XMLHttpRequestResponseType.TEXT);
    }
}

#end