package drcJS.utils;

import haxe.io.ArrayBufferView;
import haxe.io.UInt8Array;
import js.html.URL;
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

    // public static function loadTextureOld(path:String, func:(Int, UInt8Array)->Void):Void {

    //     var __request:HTTPRequest = new HTTPRequest(path, '');

    //     __request.load(function(status, response) {



    //         func(status, new UInt8Array(response));

    //     }, XMLHttpRequestResponseType.ARRAYBUFFER);
    // }

    public static function loadTexture(path:String, func:(Int, UInt8Array)->Void):Void {

        var __request:HTTPRequest = new HTTPRequest(path, '');

        __request.load(function(status, response) {

            var _arrayBuffer:UInt8Array = new haxe.io.UInt8Array(response);

            func(status, _arrayBuffer);

        }, XMLHttpRequestResponseType.ARRAYBUFFER, true);
    }

    public static function loadProfile(path:String, func:(Int, Dynamic)->Void):Void {

        var __request:HTTPRequest = new HTTPRequest(path, '');

        __request.load(func, XMLHttpRequestResponseType.TEXT);
    }
}