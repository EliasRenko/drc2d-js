package drc.utils;

import haxe.io.Path;
import drc.core.GL;
import drc.core.Promise;
import drc.data.Profile;
import drc.data.Texture;
import drc.debug.Log;
import drc.display.Attribute;
import drc.display.AttributeFormat;
import drc.display.Program;
import drc.display.Uniform;
import drc.display.Vertex;
import haxe.Json;
import drc.core.Buffers;
import drc.format.PNG;
import haxe.io.Input;
import haxe.io.BytesInput;
import haxe.io.Bytes;

#if js

typedef BackendAssets = drcJS.utils.Resources;

#elseif cpp

typedef BackendAssets = drc.backend.native.utils.Resources;

#end

class Resources {

    // ** Privates.

    /** @private **/ private var __resources:Map<String, __Resource> = new Map<String, __Resource>();

    public function new() {

    }

    public static function getBaseDirectory():String {
        
        return BackendAssets.getDirectory();
    }

    public function addTexture(name:String, data:Texture):Void {
        
        if (exists(name)) return;

        __resources.set(name, new __TextureResource(data));
    }

    public function exists(name:String):Bool {
        
        if (__resources.exists(name)) {

            return true;
        }

        return false;
    }

    public function getFont(name:String):String {
        
        if (__resources.exists(name)) {

            var _fontResource:__FontResource = cast(__resources.get(name), __FontResource);

            return _fontResource.data;
        }

        return 'Missing font!';
    }

    public function getDirectory():String {
        
        return BackendAssets.getDirectory();
    }

    public function getText(name:String):String {

        if (__resources.exists(name)) {

            var _textureResource:__TextResource = cast(__resources.get(name), __TextResource);

            return _textureResource.data;
        }

        return 'Missing text!';
    }

    public function getTexture(name:String):Texture {

        if (__resources.exists(name)) {

            var _textureResource:__TextureResource = cast(__resources.get(name), __TextureResource);

            return _textureResource.data;
        }

        var _textureResource:__TextureResource = cast(__resources.get('res/graphics/grid_mt.png'), __TextureResource);

        return _textureResource.data;
    }

    public function getProfile(name:String):Profile {

        if (__resources.exists(name)) {

            var _textureResource:__ProfileResource = cast(__resources.get(name), __ProfileResource);

            return _textureResource.data;
        }

        var _textureResource:__ProfileResource = cast(__resources.get('res/profiles/default.json'), __ProfileResource);

        return _textureResource.data;
    }

    public function loadBytes(path:String, cache:Bool = true):Promise<UInt8Array> {

        return new Promise(function(resolve, reject, advance) {

            BackendAssets.loadBytes(path, function(status, response) {

                if (status == 200 || status == 0) { 

                    if (cache) {

                        //__resources.set(path, new __TextResource(response));
                    }

                    var res:UInt8Array = response;

                    resolve(res);
                }
                else {
    
                    reject();
                }
            });
        });
    }

    public function loadFont(path:String, cache:Bool = true):Promise<String> {
        
        return new Promise(function(resolve, reject, advance) {
            
            BackendAssets.loadText(path, function(status, response) {

                if (status == 200 || status == 0) { 

                    var _name:String = Path.withoutDirectory(path);

                    var _promise:Promise<Texture> = loadTexture('res/fonts/' + Path.withoutExtension(_name) + '.png');

                    _promise.onComplete(function(promise:Promise<Texture>, type:Int) {

                        if (cache) {

                            __resources.set(path, new __FontResource(response));
                        }
    
                        resolve(response);
                    });
                }
                else {
    
                    Log.print(status);

                    reject();
                }
            });
        });
    }

    public function loadText(path:String, cache:Bool = true):Promise<String> {

        return new Promise(function(resolve, reject, advance) {
            
            BackendAssets.loadText(path, function(status, response) {

                if (status == 200 || status == 0) { 

                    if (cache) {

                        __resources.set(path, new __TextResource(response));
                    }

                    resolve(response);
                }
                else {
    
                    Log.print(status);

                    reject();
                }
            });
        });
    }

    public function loadTexture(path:String, cache:Bool = true):Promise<Texture> {

        return new Promise(function(resolve, reject, advance) {

            BackendAssets.loadTexture(path, function(status, response) {

                if (status == 200 || status == 0) { 

                    var i:Input = new BytesInput(response.view.buffer);

                    var png:PNG = new PNG(i);

                    var _bytes:Bytes = png.extract();

                    var header = PNG.getHeader(png.data);
                
                    var _texture:Texture = new Texture(UInt8Array.fromBytes(_bytes), 4, header.width, header.height);

                    if (cache) {

                        __resources.set(path, new __TextureResource(_texture));
                    }

                    resolve(_texture);
                }
                else {
    
                    reject();
                }
            });
        });
    }

    public function loadProfile(path:String, cache:Bool = true):Promise<Profile> {

        return new Promise(function(resolve, reject, advance) {
            
            BackendAssets.loadText(path, function(status, response) {

                if (status == 200 || status == 0) { 

                    var _rootData:Dynamic = Json.parse(response);

                    var _promises:Array<Promise<String>> = [];

                    trace('Vert: ' + _rootData.vertexShader);
                    trace('Frag: ' + _rootData.fragmentShader);

                    if (Reflect.hasField(_rootData, "vertexShader")) {	

                        _promises.push(loadText('res/shaders/' + _rootData.vertexShader));
                    }
                    else {

                        _promises.push(null);
                    }

                    if (Reflect.hasField(_rootData, "fragmentShader")) {	
                        
                        _promises.push(loadText('res/shaders/' + _rootData.fragmentShader));
                    }
                    else {

                        _promises.push(null);
                    }

                    var _promise:Promise<Array<String>> = Promise.all(_promises);

                    _promise.onComplete(function(promise:Promise<Array<String>>, type:Int) {
                        
                        var _profile:Profile = new Profile(_rootData.name);

                        var _vertexShaderSource:String = '';

                        var _fragmentShaderSource:String = '';

                        var dataPerVertex:Int = 0;

                        if (Reflect.hasField(_rootData, "attributes")) {

                            var _attributeData:Dynamic = Reflect.field(_rootData, "attributes");

                            for (i in 0..._attributeData.length) {

                                var _attributeFormat:AttributeFormat = AttributeFormat.VEC4;
            
                                switch (_attributeData[i].format) {
            
                                    case "float":
                        
                                        _attributeFormat = AttributeFormat.FLOAT;

                                    case "vec2":
                        
                                        _attributeFormat = AttributeFormat.VEC2;
                                        
                                    case "vec3":
                                        
                                        _attributeFormat = AttributeFormat.VEC3;
                                        
                                    case "vec4":
                                        
                                        _attributeFormat = AttributeFormat.VEC4;
                                        
                                    default:
                                        
                                        Log.print('Unknown attribute format.');
            
                                        reject();
                                }
            
                                var struct:Array<Vertex> = new Array<Vertex>();
                
                                var structData:Dynamic = Reflect.field(_attributeData[i], "struct");
            
                                for (j in 0...structData.length) {
            
                                    var _vertex:Vertex = {

                                        name: structData[j].name,
            
                                        position: dataPerVertex
                                    }
            
                                    struct.push(_vertex);

                                    dataPerVertex ++;
                                }

                                _profile.addAttribute(new Attribute(_attributeData[i].name, _attributeFormat, 0, struct));
                            }
                        }

                        #if debug

                        else {

                            throw "Profile: " + _profile.name + " has no field with name `attributes`.";
                        }

                        #end

                        _profile.dataPerVertex = dataPerVertex;

                        if (Reflect.hasField(_rootData, "uniforms")) {

                            var _uniformData:Dynamic = Reflect.field(_rootData, "uniforms");

                            for (i in 0..._uniformData.length) {

                                _profile.addUniform(new Uniform(_uniformData[i].name, _uniformData[i].format));
                            }
                        }

                        #if debug

                        else {

                            throw "Profile: " + _profile.name + " has no field with name `uniforms`.";
                        }

                        #end

                        // ** ---

                        var textures:Array<String> = new Array<String>();

                        if (Reflect.hasField(_rootData, "textures")) {

                            var textureData:Dynamic = Reflect.field(_rootData, "textures");

                            for (textureCount in 0...textureData.length) {

                                _profile.textures[textureCount] = {

                                    name: textureData[textureCount].name,

                                    format: textureData[textureCount].format
                                }
                            }
                        }

                        #if debug

                        else {

                            throw "Profile: " + _profile.name + " has no field with name `textures`.";
                        }

                        #end

                        // ** ---

                        if (promise.result[0] == null) {

                        }
                        else {

                            _vertexShaderSource = promise.result[0];
                        }

                        var _vertexShader:GLShader = GL.createShader(GL.VERTEX_SHADER);
		
                        GL.shaderSource(_vertexShader, _vertexShaderSource);
                        
                        GL.compileShader(_vertexShader);

                        if (promise.result[1] == null) {

                        }
                        else {

                            _fragmentShaderSource = promise.result[1];
                        }
                        
                        var _fragmentShader:GLShader = GL.createShader(GL.FRAGMENT_SHADER);
		
                        GL.shaderSource(_fragmentShader, _fragmentShaderSource);
                        
                        GL.compileShader(_fragmentShader);

                        // ** ---

                        var _program:Program = new Program(GL.createProgram());
                        
                        var _location:Int = 0;

                        for (i in 0..._profile.attributes.length) {

                            GL.bindAttribLocation(_program.innerData, _location, _profile.attributes[i].name);
                            
                            _profile.attributes[i].assignLocation(_location);
                            
                            _location ++;
                        }

                        // ** Attach the vertex shader.

                        GL.attachShader(_program.innerData, _vertexShader);
        
                        // ** Attach the fragment shader.

                        GL.attachShader(_program.innerData, _fragmentShader);
                        
                        // ** Link the program.

                        GL.linkProgram(_program.innerData);

                        if (GL.getProgramParameter(_program.innerData, GL.LINK_STATUS) == 0) {

                            var _error:String = GL.getProgramInfoLog(_program.innerData);

                            throw "Unable to link the shader program: " + _error;
                        }

                        for (i in 0..._profile.uniforms.length) {
                            
                            var _location:GLUniformLocation = GL.getUniformLocation(_program.innerData, _profile.uniforms[i].name);
                
                            _profile.uniforms[i].assignLocation(_location);
                            
                            #if debug // ------
                            
                            #end // ------
                        }

                        for (i in 0..._profile.textures.length) {

                            var _loc:GLUniformLocation = GL.getUniformLocation(_program.innerData, _profile.textures[i].name);

                            _profile.textures[i].location = _loc;

                            trace('Tex loc: ' + _loc);
                        }
                
                        _profile.program = _program;
                
                        if (cache) {

                            __resources.set(path, new __ProfileResource(_profile));
                        }

                        resolve(_profile);
                    });
                }
                else {
    
                    reject();
                }
            });
        });
    }
}

private class __Resource {

    public function new() {

    }
}

private class __FontResource extends __Resource {

    public var data:String;

    public function new(data:String) {

        super();

        this.data = data;
    }
}

private class __TextResource extends __Resource {

    public var data:String;

    public function new(data:String) {

        super();

        this.data = data;
    }
}

private class __TextureResource extends __Resource {

    public var data:Texture;

    public function new(data:Texture) {

        super();

        this.data = data;
    }
}

private class __ProfileResource extends __Resource {

    public var data:Profile;

    public function new(data:Profile) {

        super();

        this.data = data;
    }
}