package drc.display;

abstract Region(Array<Int>) from Array<Int> to Array<Int> {
    
    public inline function new(values:Array<Int>) {
        
        this = values;
    }

    // ** Getters and setters.

    @:noCompletion
    @:arrayAccess
    public function get(index:Int):Float {

        return this[index];
    }
    
    @:noCompletion
    @:arrayAccess
    public function set(index:Int, value:Float):Float {

        return this[index];
    }
}