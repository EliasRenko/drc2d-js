package drc.objects;

import drc.input.Mouse;
import drc.core.App;
import drc.types.WindowEventType;
import drc.system.Window;
import drc.display.Drawable;
import drc.part.Object;
import drc.utils.Common;
import drc.part.RecycleList;
import drc.input.Control;

class State extends Object {

	// ** Publics.

	public var camera:Camera = new Camera();

	public var entities:RecycleList<Entity> = new RecycleList<Entity>();

	public var graphics:RecycleList<Drawable> = new RecycleList<Drawable>();

	/**
	 * The x position of the mouse in the state. Cannot be set.
	 */
	public var mouseX(get, null):Int;

	/**
	 * The y position of the mouse in the state. Cannot be set.
	 */
	public var mouseY(get, null):Int;

	public var z:Float;

	// ** Privates.

	private var __parent:App;

	private var __perpspective:Bool = false;

	private var __z:Float;

	public function new() {}

	override public function init():Void {

		Common.input.mouse.addEventListener(__onMouseMovement, 3);
	}

	override public function release():Void {

		__parent.removeState(this);
	}

	public function addEntity(entity:Entity):Entity {

		@:privateAccess entity.__state = this;

		return entities.add(entity);
	}

	public function addGraphic(graphic:Drawable):Void {

		@:privateAccess graphic.__state = this;

		graphics.add(graphic);
	}

	public function removeGraphic(graphic:Drawable):Void {

		graphics.remove(graphic);
	}

	public function render():Void {

		graphics.forEachActive(__renderGraphic);
	}

	public function update():Void {

		// if (Common.input.getGamepad(0).pressed(Control.BACK)) {

		// 	if (__perpspective) {

		// 		__perpspective = false;
		// 	}
		// 	else {

		// 		__perpspective = true;
		// 	}
		// }

		// if (Common.input.getGamepad(0).check(Control.A)) {

        //     //trace(__image.angle);
        // }

        // if (Common.input.getGamepad(0).check(Control.Y)) {

        //     camera.z += 5;
        // }
        
        // if (Common.input.getGamepad(0).check(Control.X)) {

        //     camera.z -= 5;
		// }

        // if (Common.input.getGamepad(0).check(Control.LEFT_SHOULDER)) {

        //     camera.yaw -= 1;
        // }
        
        // if (Common.input.getGamepad(0).check(Control.RIGHT_SHOULDER)) {

        //     camera.yaw += 1;
		// }

        // if (Common.input.getGamepad(0).check(Control.DPAD_UP)) {

        //     camera.y += 2;
		// }

		// if (Common.input.getGamepad(0).check(Control.DPAD_DOWN)) {

        //     camera.y -= 2;
		// }

		// if (Common.input.getGamepad(0).check(Control.DPAD_LEFT)) {

        //     camera.x += 2;
		// }

		// if (Common.input.getGamepad(0).check(Control.DPAD_RIGHT)) {

        //     camera.x += 2;
        // }

		if (Common.input.keyboard.check(26)) {

			// ** UP

			camera.y += 2;
		}

		if (Common.input.keyboard.check(22)) {

			// ** DOWN

			camera.y -= 2;
		}

		if (Common.input.keyboard.check(4)) {

			// ** LEFT

			camera.x += 2;
		}

		if (Common.input.keyboard.check(7)) {

			// ** RIGHT

			camera.x -= 2;
		}

		if (Common.input.keyboard.released(53)) {

			// ** USE

			if (__perpspective) {

			 	__perpspective = false;
			}
			else {
	
				__perpspective = true;
			}
		}

		if (Common.input.keyboard.check(80)) {

			// ** ARROW LEFT

			camera.yaw -= 3;
		}

		if (Common.input.keyboard.check(79)) {

			// ** ARROW RIGHT

			camera.yaw += 3;
		}

		if (Common.input.keyboard.check(82)) {

			// ** ARROW TOP

			camera.z -= 4;
		}

		if (Common.input.keyboard.check(81)) {

			// ** ARROW BOTTOM

			camera.z += 4;
		}

		entities.forEachActive(__updateEntity);
	}

	public function onWindowEvent(window:Window, type:WindowEventType):Void {

	}

	public function __renderGraphic(drawable:Drawable):Void {
		
		if (drawable.visible) {

			drawable.render();

			if (__perpspective) {

				//drawable.uniforms.get('matrix').value = camera.render2(drawable.uniforms.get('matrix').value);

				__parent.stage.draw(drawable, camera.render2(drawable.matrix));
			}
			else {

				//drawable.uniforms.get('matrix').value = camera.render(drawable.uniforms.get('matrix').value);

				__parent.stage.draw(drawable, camera.render(drawable.matrix));
			}
		}
	}

	private function __updateEntity(entity:Entity):Void {

		entity.update();
	}

	private function __onMouseMovement(mouse:Mouse, type:UInt) {

		//mouseX = mouse.x;

		//mouseY = mouse.y;
	}

	// ** Getters and setters.

	private function get_mouseX():Int {

		return Common.input.mouse.x;
	}

	private function get_mouseY():Int {

		return Common.input.mouse.y;
	}

	private function get_z():Float {
		
		return __z;
	}
}

private class __GraphicManager {

	public function new() {
		
	}
}
