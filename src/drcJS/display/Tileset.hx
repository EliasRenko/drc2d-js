package drc.display;

import drc.display.Region;

class Tileset {

    // ** Publics.

    public var regions:Array<Region>;

    public var names:Map<String, Int> = new Map<String, Int>();

    public function new(?regions:Array<Region>) {
        
        if (regions == null) {

            this.regions = new Array<Region>();

            return;
        }

        this.regions = regions;
    }

    public function addRegion(region:Region, ?name:String):Void {

        var index:Int = regions.push(region) - 1;

        if (name == null) return;

        names.set(name, index);
    }

    public function upload(regions:Array<Region>):Void {
        
        this.regions = regions;
    }
}