package drc.display;

class Particle extends Tile {

    // ** Publics.
    
    public var duration:Float;
	
	public var velocityX:Float;
	
	public var velocityY:Float;
	
	public var gravity:Float;
	
    public var rotation:Float;

    public var speed:Float;
    
    // ** Privates.

    /** @private **/ private var __time:Float = 0;

    public function new(parent:Tilemap, id:Null<UInt>, ?x:Int = 0, ?y:Int = 0) {
        
        super(parent, id, x, y);
    }

    public function reset() {
        
        __time = 0;
    }

    override function render() {

        __time += 0.0166;
		
		if (__time >= duration)
		{
			//__state.removeEntity(this);
            
            __parentTilemap.recycle(this);

			return;
		}
		
		angle += rotation;
		
		var overall = __time / duration;
		
		//graphic.setAttribute("r", 1 - overall);
		
		//x += velocityX * 2;
		//
		//y += (velocityY * 5) + (gravity * __time);
		
		x += (velocityX * speed);
		
		y += ((velocityY * speed)) + (gravity * __time);

        super.render();
    }
}