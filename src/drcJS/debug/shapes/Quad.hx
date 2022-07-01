package drc.debug.shapes;

import drc.debug.shapes.Shape;

class Quad extends Shape {
    
    public function new() {
        
        super([0, 0, 0, 
            0, 32, 0,  
            32, 32, 0,
            32, 0, 0]);
    }
}