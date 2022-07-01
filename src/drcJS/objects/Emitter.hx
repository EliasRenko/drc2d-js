package drc.objects;

import drc.display.Tilemap;
import drc.display.Particle;
import drc.part.Object;

class Emitter extends Object {

    // ** Publics.

    public var parent:Tilemap;

    public var interval:Float = 0.1;

    public var lifespan:Float = 1;

    public var speed:Float = 1;

    public var gravity:Float = 1;

    // ** Privates.

    private var __time:Float = 0;

    public function new(tilemap:Tilemap) {

        parent = tilemap;
    }

    public function emit(x:Int, y:Int, angle:Float, angleRange:Float):Void {

        //parent.restore

        //var particle:Particle = new Particle(parent, 0, x, y);

		if (__time <= interval)
		{
            __time += 0.0166;
            
            return;
        }
        
        __time = 0;

        var particle:Particle = cast(parent.restore(null), Particle);
        
        if (particle == null) particle = new Particle(parent, 0, x, y);

        var radian = angle * (Math.PI / -180);
        
        var radianRage = angleRange * (Math.PI / -180);
        
        particle.duration = lifespan;
        
        particle.gravity = gravity;
        
        particle.rotation = 1 + (2 * Math.random());
        
        particle.reset();

        particle.x = x;
        
        particle.y = y;

        particle.speed = speed;
        
        particle.velocityX = Math.cos(radian);
        
        particle.velocityY = Math.sin(radian);

        parent.addTile(particle);
        
        particle.centerOrigin();
        
        //particles.push(__scene.addEntity(particle).index);
    }
}