package drc.objects;

import drc.display.Graphic;
import drc.part.Object;
import drc.objects.State;

@:allow(drc.objects.DrcState)
class Entity extends Object
{
	//** Publics.
	
	//public var body:Body;
	
	public var graphic:Graphic;
	
	public var state(get, null):State;
	
	public var x(get, set):Float;
	
	public var y(get, set):Float;
	
	public var name:String = "player";
	
	//** Privates.
	
	private var __state:State;
	
	private var __x:Float = 0;
	
	private var __y:Float = 0;
	
	public function new() 
	{
		//super();
		
		//** Create a new body class.
		
		//body = new Body(type);
		
		//body.userData.entity = this;
	}
	
	public function setHitbox():Void
	{
		//__hitbox = new Polygon(Polygon.rect(0, 0, 26, 37));
		
		//body.shapes.add(__hitbox);
	}
	
	override public function init():Void 
	{
		super.init();
		
		//graphic.__add();
	}
	
	override public function release():Void 
	{
		super.release();
	}
	
	public function moveBy(x:Float, y:Float):Void
	{
		//body.velocity.x += x;
		
		//body.velocity.y += y;
	}
	
	public function collide():Void
	{
		//body.applyImpulse(Vec2.weak(-100, 0));
	}
	
	public function update():Void
	{
		//graphic.x = __x;
		//
		//graphic.y = __y;
		//
		//body.position.x = __x;
		//
		//body.position.y = __y;
		
		//graphic.x = body.position.x;
		
		//graphic.y = body.position.y;
	}
	
	//** Getters and setters.
	
	private function get_state():State
	{
		return __state;
	}
	
	private function get_x():Float
	{
		return 0;
	}
	
	private function get_y():Float
	{
		return 0;
	}
	
	private function set_x(value:Float):Float
	{
		return 0;
	}
	
	private function set_y(value:Float):Float
	{
		return 0;
	}
}