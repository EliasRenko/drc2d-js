package drc.ds;

class ListIterator<T> {

    // ** Publics.

	var head:IListObject<T>;

	public inline function new(head:IListObject<T>) {

		this.head = head;
	}

	public inline function hasNext():Bool {

		return head != null;
	}

	public inline function next():T {

		var _val = head.item;

		head = head.next;

		return _val;
	}
}