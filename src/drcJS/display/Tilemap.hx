package drc.display;

import drc.data.Texture;
import drc.data.Profile;
import drc.display.Drawable;
import drc.display.Tile;
import drc.part.RecycleList;

class Tilemap extends Drawable {

	// ** Publics.

	public var tiles:RecycleList<Tile> = new RecycleList<Tile>();

	public var tileset:Tileset;

	// ** Privates.

	/** @private **/ private var __activeVertices:Int;

	// **

    public function new(profile:Profile, textures:Array<Texture>, ?tileset:Tileset) {

        super(profile);

		if (textures == null) {

		}
		else {

			if (textures.length == profile.textureCount) {

				this.textures = textures;
			}
			else {

				for (i in 0...textures.length) {

					this.textures[i] = textures[i];
				}
			}
		}

		if (tileset == null) {

			this.tileset = new Tileset();
		}
		else {

			this.tileset = tileset;
		}
	}
	
	public function addTile(tile:Tile):Tile {

		if (tiles.add(tile) == null) {

			return null;
		}
		
		__updateIndices();
		
		// ** Return.
		
		return tile;
	}

	public function getTile(index:Int):Tile {

		return tiles.getMember(index);
	}
		
	public function insert(tile:Tile):Tile {

		return tiles.insert(tile);
	}
		
	public function restore(tile:Tile):Tile {

		var _tile:Tile = tiles.restore(tile);

		if (_tile == null) return null;
		
		__updateIndices();

		return _tile;
	}
		
	public function restoreAt(index:Int):Tile {

		var _tile:Tile = tiles.restoreAt(index);

		if (_tile == null) return null;
		
		__updateIndices();

		return _tile;
	}
		
	public function recycle(tile:Tile):Bool {

		if (tiles.recycle(tile)) {

			for (i in 0...6) {
		
				indices.pop();
			}
			
			return true;
		}
		
		return false;
	}
		
	public function removeTile(tile:Tile):Void {

		//trace(tile.index);
		
		tiles.remove(tile);
		
		for (i in 0...6) {
		
			indices.pop();
		}
	}
	
	public function removeTileAt(index:Int):Void {

		tiles.removeAt(index);
		
		for (i in 0...6) {
		
			indices.pop();
		}
	}

	override public function render():Void {
		
		__activeVertices = 0;

		__verticesToRender = 0;

		__indicesToRender = 0;

		tiles.forEachActive(__renderTile);
	}

	private function __renderTile(tile:Tile):Void {

		if (tile.visible) {

			tile.render();

			for (vertexData in 0...tile.vertices.length) {
				
				// ** Push the vertex data in the tilemap.
				
				vertices[__activeVertices] = tile.vertices[vertexData];

				__activeVertices ++;
			}
			
			__verticesToRender += 4;
			
			__indicesToRender += 6;
		}
	}

	private function __updateIndices():Void {

		var position:Int = 4 * (tiles.activeCount - 1);
		
		indices.push(position);
		
		indices.push(position + 1);
		
		indices.push(position + 2);
		
		indices.push(position);
		
		indices.push(position + 2);
		
		indices.push(position + 3);
	}
}