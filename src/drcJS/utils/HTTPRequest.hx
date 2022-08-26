package drcJS.utils;

import haxe.io.UInt8Array;
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;

class HTTPRequest {

    // ** Privates.

    /** @private **/ private var __request:XMLHttpRequest;

    /** @private **/ private var __uri:String;

    public function new(uri:String, requestMethod:String) {
        
        __uri = uri;
    }

    public function cancel():Void {
        
        // ** If request is null... return.

        if (__request == null) return;
      
        // ** Abort the request.

        __request.abort();
    }

    public function load(func:(Int, Dynamic)->Void, type:XMLHttpRequestResponseType, isBinary:Bool = false):Void {

        var _async = true;

        var _binary = isBinary;

        __request = new XMLHttpRequest();

        __request.open("GET", __uri, true);

        if(_binary) {

            __request.overrideMimeType('text/plain; charset=x-user-defined');

        } else {

            __request.overrideMimeType('text/plain; charset=UTF-8');
        }

        __request.responseType = type;

        __request.onload = function(data) {

            if(__request.status == 200) {

                func(__request.status, __request.response);

            } else {

                throw 'request status was ${__request.status} / ${__request.statusText}';
            }
        }

        __request.send();
    }


}