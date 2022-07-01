package drc.system;

import drc.input.Mouse;
import drc.input.Keyboard;
import drc.core.Runtime;
import drc.types.GamepadEvent;
import drc.core.EventDispacher;
import drc.input.Gamepad;
import drc.types.GamepadInputEvent;

class Input {

    // ** Publics.

    public var event:EventDispacher<GamepadEvent>;

    public var gamepads(get, null):Gamepads;

    public var keyboard(get, null):Keyboard;

    public var mouse(get, null):Mouse;

    // ** Privates.

    private var __gamepads:Gamepads;

    private var __keyboard:Keyboard;

    private var __mouse:Mouse;

    public function new(runtime:Runtime) {

        __keyboard = runtime.keyboard;

        __mouse = runtime.mouse;

        event = new EventDispacher<GamepadEvent>();

        event.addEventListener(__onGamepadAdd, 1);

        event.addEventListener(__onGamepadRemove, 2);

        //event.add(__onGamepadButtonDown, 2);

        //event.add(__onGamepadButtonUp, 3);

        __gamepads = new Gamepads(4);
    }

    public function postUpdate():Void {
        
        __mouse.postUpdate();

        __keyboard.postUpdate();
    }

    private function __onGamepadAdd(event:GamepadEvent, type:UInt):Void {
        
        __gamepads[event.index].open(event.gamepad);
    }

    private function __onGamepadRemove(event:GamepadEvent, type:UInt):Void {
        
        __gamepads[event.index].close();
    }

    // ** Getters and setters.

    private function get_gamepads():Gamepads {
        
        return __gamepads;
    }

    private function get_keyboard():Keyboard {
        
        return __keyboard;
    }

    private function get_mouse():Mouse {
        
        return __mouse;
    }
}

private abstract Gamepads(Array<GamepadHandler>) {

    public inline function new(count:UInt) {
        
        this = new Array<GamepadHandler>();

        for (i in 0...4) {

            this[i] = new GamepadHandler(i);
        }
    }

    // ** Getters and setters.

    @:dox(hide)
    @:noCompletion
    @:arrayAccess
    public function get(index:Int):GamepadHandler {

        return this[index];
    }
    
    @:dox(hide)
    @:noCompletion
    @:arrayAccess
    public function set(index:Int, value:GamepadHandler):GamepadHandler {

        this[index] = value;
        
        return value;
    }
}

private class GamepadHandler {

    // ** Privates.

    private var __index:UInt;

    private var __gamepad:Gamepad;

    public function new(index:UInt) {

        __index = index;
    }

    public function open(gamepad:Gamepad):Void {
        
        __gamepad = gamepad;

        __gamepad.addEventListener(__onButtonDown, 1);

        __gamepad.addEventListener(__onButtonUp, 2);

        __gamepad.addEventListener(__onAxisMotion, 3);
    }

    public function close():Void {
        
        __gamepad.removeEventListener(__onButtonDown);

        __gamepad.removeEventListener(__onButtonUp);

        __gamepad.removeEventListener(__onAxisMotion);

        __gamepad.close();
    }

    private function __onAxisMotion(event:GamepadInputEvent, type:UInt):Void {
        
    }

    private function __onButtonDown(event:GamepadInputEvent, type:UInt):Void {
        
    }

    private function __onButtonUp(event:GamepadInputEvent, type:UInt):Void {
        
    }
}