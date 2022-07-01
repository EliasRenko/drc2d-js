package drc.display;

import drc.display.Tile;
import drc.display.TextAlign;

class Text extends Graphic {

	//** Publics.
	
	public var align(get, set):TextAlign;
	
	public var parent(get, set):Charmap;
	
	public var fieldWidth(get, set):Float;

	public var heading(get, set):UInt;

	/**
	 * The space between lines.
	 */
	public var leading:Int = 20;
	
	/**
	 * The number of lines the text has.
	 */
	public var lines(get, null):Int;
	
	/**
	 * The space between words.
	 */
	public var spacing:Int = 6;
	
	/**
	 * The string value of the text.
	 */
	public var text(get, set):String;
	
	public var scale(get, set):Float;

	/**
	 * The space between letters.
	 */
	public var tracking:Int = 1;
	
	/**
	 * Wordwrap.
	 */
	public var wordwrap(get, set):Bool;
	
	// ** Privates.
	
	/** @private **/ private var __align:UInt = 0;
	
	/** @private **/ private var __fieldWidth:Float = 300;

	/** @private **/ private var __font:String;
	
	/** @private **/ private var __lines:Int = 0;
	
	/** @private **/ public var __characters:Array<Character> = new Array<Character>();
	
	/** @private **/ private var __text:String = "";
	
	/** @private **/ private var __parent:Charmap;
	
	/** @private **/ private var __lineBreak:Array<UInt> = new Array<UInt>();
	
	/** @private **/ private var __lineStart:Array<Float> = new Array<Float>();

	/** @private **/ private var __lineSize:Array<Float> = new Array<Float>();
	
	/** @private **/ private var __transition:UInt = 4;

	/** @private **/ private var __wordwrap:Bool = false;

	/** @private **/ private var __heading:UInt = 0;

	public function new(parent:Charmap, value:String, x:Float = 0, y:Float = 0) {

		super(x, y);

		__scaleX = 1;

		__scaleY = 1;

		if (parent == null) {

			__text = value;

			return;
		}

		__parent = parent;
		
		text = value;
		
		tracking = parent.defaultKerning;
	}

	override function init() {

		super.init();

		if (parent == null) {

			text = __text;
		}
	}
	
	public function clear():Void
	{
		var i = __characters.length - 1;

		while(i >= 0) {

			__characters[i].__remove();

			__characters.pop();
		
			i --;
		}

		__text = '';
	}
	
	// ** Getters and setters.
	
	private function get_align():UInt {

		return __align;
	}
	
	private function set_align(value:UInt):UInt {

		__align = value;

		setPosition();

		return value;
	}
	
	private function get_fieldWidth():Float {

		return __fieldWidth;
	}
	
	private function set_fieldWidth(value:Float):Float {

		__fieldWidth = value;
		
		set_text(__text);
		
		return value;
	}
	
	private function get_lines():Int {

		return __lines;
	}
	
	private function get_text():String {

		return __text;
	}
	
	override function setAttribute(name:String, value:Float):Void {

		for (i in 0...__characters.length)
		{
			__characters[i].setAttribute(name, value);
		}
	}

	public function addToParent():Void {

		//__active = true;

		for (i in 0...__characters.length)
		{
			__parent.addTile(__characters[i]);
		}
	}

	public function dispose():Void {
		
		for (i in 0...__characters.length)
		{
			parent.removeTile(__characters[__characters.length - 1]);
			
			__characters.pop();
		}
	}
	
	private function setPosition():Void {

		#if debug // ------
		
		if (__align > 2)
		{
			//** Get the name of the class.
			
			var className = Type.getClassName(Type.getClass(this));
			
			//** Throw error!
			
			//DrcConsole.showTrace("Class: " + className + " with string " + __text + ", cannot be aligned properly.");
		}
		
		#end // ------
		
		if (parent == null) return;

		__lines = 0;
		
		var lineX:Float = 0;
		
		switch (__align) {

			case LEFT:	
			
				lineX = __lineStart[__lines];

			case CENTER:

				lineX = Math.round((__fieldWidth - __lineSize[__lines]) / 2);

				//__lineStart.push(Math.round(((fieldWidth - trueWidth) + spacing) / 2));

			case RIGHT:

			default:
				
		}

		//var lineX:Float = 0;
		
		var lineY:Float = 0;
		
		var lineWidth:Int = 0;
		
		var track:Int = 0;
		
		//trace(__lineStart);
		
		for (i in 0...__characters.length)
		{
			var track:Int = 0;
			
			if (__wordwrap)
			{
				if (i == __lineBreak[__lines])
				{
					__lines ++;
					
					switch (__align) 
					{
						case LEFT:	
						
							lineX = __lineStart[__lines];

						case CENTER:

							lineX = Math.round((__fieldWidth - __lineSize[__lines]) / 2);

							//__lineStart.push(Math.round(((fieldWidth - trueWidth) + spacing) / 2));

						case RIGHT:

						default:
							
					}
					
					//lineX = 0;
					
					lineY += leading;
				}
			}
			
			var tile:Tile = __characters[i];
			
			tile.x = __x;
			
			tile.y = __y;
			
			tile.z = __z;
			
			tile.offsetX = lineX;
			
			//trace(tile.id);

			tile.offsetY += lineY;

			//tile.offsetY = lineY + (parent.tileset.regions[tile.id][5]);

			//tile.offsetY = __y + lineY;
			
			var next:UInt = text.charCodeAt(i + 1);
				
				if (next == 32)
				{
					track = 0;
				}
				else
				{
					if (parent.useKerningPairs)
					{
						//if (parent.kernings[tile.id] != null)
						//{
							//track = parent.kernings[tile.id].getValue(next); //TO-DO:KERNINGS
						//}
						
						//if (track == null)
						//{
							//track = 0;
						//}
						
						track = 0; //** PLACEHOLDER
					}
					
					track += tracking;
					
					//track += tracking;
					
					//track = tracking;
				}
				
			if (tile.id == 32)
			{
				//tile.width = spacing;
				
				//tile.offsetY += 12;
				
				//track = 0;
			}
			
			lineX += (tile.width * __scaleX) + track;
		}
		
		if (!__wordwrap)
		{
			__fieldWidth = lineX;
		}
	}
	
	private function setPositionNew():Void {

		var _length:Int = 0;

		var _positions:Array<Int> = [];

		var _trueWidth:Float;

		var _width:Float = 0;

		var _word:UInt = 0;

		var _y:Int = 0;

		for (i in 0...__characters.length) {

			_width += __characters[i].width;

			if (__characters[i].char == ' ') {

				_trueWidth = _width;

				_word = -1;
			}

			_word ++;

			if (_width > __fieldWidth || i == __characters.length - 1) {

				var _x:Float;

				switch (__align) {

					case LEFT:

						_x = 0;

						for (j in _length...i) {

							__characters[j].x = __x;

							__characters[j].y = __y;

							__characters[j].z = __z;

							__characters[j].offsetX = _x;

							__characters[j].offsetX = _y;

							_x += 30;
						}

					case _:
				}

				_length = i;

				_trueWidth = 0;

				_y += leading;
			}
		}
	}

	private function set_text(value:String):String
	{
		if (value == '' || value == null) {

			__fieldWidth = 0;

			clear();

			return __text = '';
		}

		__text = value;

		if (parent == null) {

			return value;
		}

		if (__characters.length > value.length)
		{
			var num = __characters.length - value.length;

			var i = __characters.length - 1;

			var count = __characters.length - num;

			while (i >= count) {

				__characters[i].__remove();

				__characters.pop();
			
				i --;
			}
		}
		
		for (k in 0...__lineBreak.length)
		{
			__lineBreak.pop();
		}
		
		for (o in 0...__lineStart.length)
		{
			__lineStart.pop();
		}
		
		// ** ---
		
		var lineWidth:Float = 0;
		
		var track:Int;
		
		var trueWidth:Float = 0;
		
		var word:Int = -1;
		
		//__lineBreak.push(0);

		for (i in 0...__text.length)
		{
			var id:UInt = __text.charCodeAt(i);
			
			var char:Character;
			
			if (i > __characters.length - 1) {
				
				char = new Character(parent, id);
				
				char.char = __text.charAt(i);

				//char.offsetY = (__parent.ascend - char.height) * scale;

				//char.scaleX = __scaleX;

				//char.scaleY = __scaleY;

				parent.addTile(char);

				__characters.push(char);
			}
			else {

				char = __characters[i];
				
				char.id = id;
			}

			char.offsetY = __parent.tileset.regions[id][5];

			char.scaleX = __scaleX;

			char.scaleY = __scaleY;

			//char.setAttribute('s', scaleX);

			char.visible = __visible;
			
			track = 0;
			
			word ++;
			
			//track = tracking;
			
			var next:UInt = __text.charCodeAt(i + 1);
			
			if (id == 32) {

				word = -1;
				
				char.width = spacing;
				
				char.height = 0;
				
				//tile.setAttribute("r", 0.2);
				//tile.setAttribute("g", 0.2); // DEBUG!!
				
				trueWidth = lineWidth;
				//trueWidth = lineWidth;
			}
			else {

				if (parent != null) {

					if (parent.useKerningPairs)
					{
						//if (parent.kernings[id] != null)
						//{
							//track = parent.kernings[id].getValue(next);
						//}
						//
						//if (track == null)
						//{
							//track = 0;
						//}
						//
						//trace("Kerning Pairs"); //TO-DO:KERNINGS
					}
				}

				track += tracking;
			}
			
			lineWidth += char.width + track;
			
			if (lineWidth > __fieldWidth)
			{
				__lineBreak.push((i - word));
				
				__lineStart.push(0);
				//__lineStart.push((fieldWidth - trueWidth) + spacing);
				//__lineStart.push(Math.round(((fieldWidth - trueWidth) + spacing) / 2));
				
				__lineSize.push(trueWidth);

				lineWidth = lineWidth - (trueWidth + spacing + tracking);
				
				var start:Int = 0;
				
				var tileBreak:Tile = __characters[i - word];
				
				//tileBreak.setAttribute("r", 0.2);
				//tileBreak.setAttribute("b", 0.2); // DEBUG!!
				
				//tile.setAttribute("r", 0.2);
				//tile.setAttribute("b", 0.2); // DEBUG!!
				
				//
				//if (text.charCodeAt((i - word)) == 32)
				//{
					//trace(text.charAt((i - word)));
					//
					//start -= spacing;
					//
					//lineWidth = start;
				//}
				
				//__lineStart.push(start);
			}
		}
		
		__lineStart.push(0);
		//__lineStart.push((fieldWidth - lineWidth));
		//__lineStart.push(Math.round(((fieldWidth - lineWidth)) / 2));
		
		__lineSize.push(lineWidth);

		setPosition();

		return __text;
	}

	private function get_heading():UInt {
		
		return __heading;
	}

	private function set_heading(value:UInt):UInt {
		
		__heading = value;

		text = __text;

		return __heading;
	}

	override function get_height():Float {

		return 24;
	}

	private function get_size():UInt {

		return __parent.variants[__heading];
	}

	private function get_parent():Charmap {

		return __parent;
	}
	
	private function set_parent(parent:Charmap):Charmap {

		if (__parent != null) {

			clear();
			
			tracking = parent.defaultKerning;
		}
		
		__parent = parent;

		text = __text;
		
		//** Return.
		
		return __parent;
	}
	
	private function get_scale():Float {
		
		return __scaleX;
	}

	private function set_scale(value:Float):Float {

		__scaleX = value / parent.size;

		__scaleY = value / parent.size;

		text = __text;

		return __scaleX;
	}

	override private function set_visible(value:Bool):Bool {

		for (i in 0...__characters.length) {

			__characters[i].visible = value;
		}
		
		return __visible = value;
	}

	override function get_width():Float {
		
		//return __width;

		return __fieldWidth;
	}

	private function get_wordwrap():Bool {

		return __wordwrap;
	}

	private function set_wordwrap(value:Bool):Bool {
		
		__wordwrap = value;

		setPosition();

		return value;
	}
	
	override private function set_x(value:Float):Float {

		for (i in 0...__characters.length) {

			__characters[i].x = value;
		}

		return __x = value;
	}
	
	override private function set_y(value:Float):Float {

		for (i in 0...__characters.length) {

			__characters[i].y = value;
		}
		
		return __y = value;
	}
	
	override private function set_z(value:Float):Float {

		for (i in 0...__characters.length) {

			__characters[i].z = value;
		}
		
		return __z = value;
	}
}

private class Character extends Tile {
	
	// ** Publics.

	public var char:String;

	public function new(parent:Charmap, id:Int) {

		super(parent, id);
	}

	override function set_id(value:UInt):UInt {

		super.set_id(value);

		if (value == 0) return value;

		var rect:Region = parentTilemap.tileset.regions[value];

		//y = rect.values[5];

		return value;
	}

	override function get_width():Float {

		return __width;
	}

	override function get_height():Float {

		return __height;
	}
}