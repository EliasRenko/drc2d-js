package drcJS.debug.shapes;

import drcJS.data.Vertices;

class Shape {

    // ** Publics.

    public var vertices(get, null):Vertices;

    // ** Privates.

    private var __vertices:Vertices;

    public function new(vertices:Vertices) {
        
    }

    // ** Getters and setters.

    private function get_vertices():Vertices {
        
        return __vertices;
    }
}