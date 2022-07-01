package drc.data;

@:forward(length, pop, push)
abstract Indices(Array<UInt>) from Array<UInt> to Array<UInt> {

    // ** Publics.

    // ** Privates.

    inline public function new(data:Array<UInt> = null) {

		this = data;
    }

    /**
	 * Dispose of the data.
	 */
	public function dispose():Void {

		for (index in 0...this.length) {
			
			this.pop();
		}
    }
    
    /**
	 * Insert an amount of data.
	 * 
	 * @param	count The amount of data to be uploaded.
	 */
	public function insert(count:UInt, ?value:UInt):Void {

		for (value in 0...count) {

			this.push(1);
		}
	}
}