package drc.display;

import drc.display.Graphic;
import drc.display.Tilemap;
import drc.display.Region;

class Tile extends Graphic {

    // ** Publics.

    public var id(get, set):Null<UInt>;

    public var parentTilemap(get, set):Tilemap;

    // ** Privates.

    /** @private **/ private var __id:Null<UInt>;

    /** @private **/ private var __parentTilemap:Tilemap;

    public function new(parent:Tilemap, id:Null<UInt>, ?x:Int = 0, ?y:Int = 0) {

        super(x, y);

        // ** TODO: FIX __parentTilemap = parent; & this.id = id;

        if (parent != null) {

            __parentTilemap = parent;
        }
       
        if (id == null) {

            return;
        }

        this.id = id;
    }

    public function add():Void {

        __add();
    }

    override function __add():Void {

        //** Add itself to the parent tilemap.
        
        __parentTilemap.addTile(this);
    }
        
    public function centerOrigin():Void {

        originX = __width / 2;
        
        originY = __height / 2;
    }

    override function __remove():Void {

        //** Remove itself from the parent tilemap.
        
        __parentTilemap.removeTile(this);
    }

    override function render() {
        
        if (__shouldTransform) {

            var radian = angle * (Math.PI / -180);
		
            var cosT = Math.cos(radian);
            
            var sinT = Math.sin(radian);
            
            var scaledWidth:Float = width * scaleX;
            var scaledHeight:Float = height * scaleY;
            
            var centerX:Float = originX * scaleX;
            var centerY:Float = originY * scaleY;
            
            vertices[parentTilemap.shadings["x"].positions[0]] = (__x + __offsetX) - (cosT * centerX) - (sinT * centerY);
            
            vertices[parentTilemap.shadings["x"].positions[1]] = (__x + __offsetX) - (cosT * centerX) + (sinT * (scaledHeight - centerY)); 
            
            vertices[parentTilemap.shadings["x"].positions[2]] = (__x + __offsetX) + (cosT * (scaledWidth - centerX)) + (sinT * (scaledHeight - centerY));
            
            vertices[parentTilemap.shadings["x"].positions[3]] =  (__x + __offsetX) + (cosT * (scaledWidth - centerX)) - (sinT * centerY);
            
            vertices[parentTilemap.shadings["y"].positions[0]] = (__y + __offsetY) + (sinT * centerX) - (cosT * centerY);
            
            vertices[parentTilemap.shadings["y"].positions[1]] = (__y + __offsetY) + (sinT * centerX) + (cosT * (scaledHeight - centerY));
            
            vertices[parentTilemap.shadings["y"].positions[2]] = (__y + __offsetY) - (sinT * (scaledWidth - centerX)) + (cosT * (scaledHeight - centerY));
            
            vertices[parentTilemap.shadings["y"].positions[3]] = (__y + __offsetY) - (sinT * (scaledWidth - centerX)) - (cosT * centerY);
            
            //** ---
            
            vertices[parentTilemap.shadings["z"].positions[0]] = __z;

            vertices[parentTilemap.shadings["z"].positions[1]] = __z;

            vertices[parentTilemap.shadings["z"].positions[2]] = __z;

            vertices[parentTilemap.shadings["z"].positions[3]] = __z;

            __shouldTransform = false;
        }
    }

    override function setAttribute(name:String, value:Float) {

		#if debug // ------
		
		if (!parentTilemap.shadings.exists(name)) {

			throw "Attribute: " + name + " does not exist.";
		}
		
		#end // ------
		
		for (i in 0...4) {

			vertices[parentTilemap.shadings[name].positions[i]] = value;
		}
	}

    // ** Getters and setters.

    private function get_id():UInt {
        
        return __id;
    }

    private function set_id(value:UInt):UInt {

        //if (value == __id) return value;

        __id = value;

        if (parentTilemap == null) {

            //** Get the name of the class.
            
            var className = Type.getClassName(Type.getClass(this));
            
            //** Throw error!
            
            //DrcConsole.showTrace("Class: " + className + " has not been assigned a tilemap parent.");
            
            //** Return.
            
            return 0;
        }

        var rect:Region = parentTilemap.tileset.regions[value];

        if (rect == null) {

            rect = parentTilemap.tileset.regions[64];
        }

        vertices[parentTilemap.shadings["u"].positions[0]] = rect[0] / parentTilemap.textures[0].width;
		vertices[parentTilemap.shadings["v"].positions[0]] = rect[1] / parentTilemap.textures[0].height; //y
		
		vertices[parentTilemap.shadings["u"].positions[1]] = rect[0] / parentTilemap.textures[0].width;	//down
		vertices[parentTilemap.shadings["v"].positions[1]] = (rect[1] + rect[3]) / parentTilemap.textures[0].height;
		
		vertices[parentTilemap.shadings["u"].positions[2]] = (rect[0] + rect[2]) / parentTilemap.textures[0].width; //Width
		vertices[parentTilemap.shadings["v"].positions[2]] = (rect[1] + rect[3]) / parentTilemap.textures[0].height; //Height
		
		vertices[parentTilemap.shadings["u"].positions[3]] = (rect[0] + rect[2]) / parentTilemap.textures[0].width; //up
		vertices[parentTilemap.shadings["v"].positions[3]] = rect[1] / parentTilemap.textures[0].height;

        width = rect[2];
		
		//** Set the height of the tile.
		
		height = rect[3];

        return __id;
    }

    private function get_parentTilemap():Tilemap {

        //** Return.
        
        return __parentTilemap;
    }
        
    private function set_parentTilemap(tilemap:Tilemap):Tilemap {

        var active:Bool = active;
        
        if (__parentTilemap != null) {

            __parentTilemap.removeTile(this);
            
            vertices.dispose();
        }

        vertices.insert(tilemap.profile.dataPerVertex * 4);
        
        __parentTilemap = tilemap;
        
        id = __id;
        
        if (active) {
            
            __add();
        }
        
        //** Return.
        
        return __parentTilemap;
    }
}