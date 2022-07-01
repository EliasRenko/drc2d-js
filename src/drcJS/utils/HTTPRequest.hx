package drcJS.utils;

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

    public function load(func:(Int, Dynamic)->Void, type:XMLHttpRequestResponseType):Void {

        __request = new XMLHttpRequest();

        __request.open("GET", __uri, true);

        __request.overrideMimeType('text/plain; charset=x-user-defined');

        __request.responseType = type;

        __request.onload = function(data) {

            func(__request.status, __request.response);
        }

        __request.send();
    }


}