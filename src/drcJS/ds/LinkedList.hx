package drc.ds;

import drc.ds.ListIterator;

class LinkedList<T> {

    // ** Publics.

    public var length:Int = 0;

    // ** Privates.

    /** @private **/ private var __first:IListObject<T>;

	/** @private **/ private var __last:IListObject<T>;

    public function new() {
        
    }

    public function add(item:T) {

        var _object = __createNode(item, null, null);

        if (__first == null) {
            
            __first = _object;
        }
        else {
            
            __last.next = _object;

            _object.prev = __last;
        }

        __last = _object;
        
		length ++;
    }

    public function remove(item:T) {
        
		var prev:IListObject<T> = null;

		var l = __first;

		while (l != null) {

			if (l.item == item) {

				if (prev == null) {

					__first = l.next;

                    l.prev = null;
                }
				else {

					prev.next = l.next;
                }

				if (__last == l) {

					__last = prev;

                    prev.next = null;
                }
                else {

                    l.next.prev = prev;
                }

				length--;

				return true;
			}

			prev = l;

			l = l.next;
		}

		return false;
    }

    public function first():Null<T> {

		return if (__first == null) null else __first.item;
	}

    public function last():Null<T> {

		return if (__last == null) null else __last.item;
	}

    public inline function iterator():ListIterator<T> {

		return new ListIterator<T>(__first);
	}

	public function getNode(item:T):IListObject<T> {
		
		var _current = __first;

		while (_current != null) {

			if (_current.item == item) {

				return _current;
			}

			_current = _current.next;
		}

		return null;
	}

	private function __createNode(item:T, prev:IListObject<T>, next:IListObject<T>):IListObject<T> {

		return new __GenericListNode<T>(item, prev, next);
	}
}

private class __GenericListNode<T> implements IListObject<T> {

	// ** Publics.

	public var index:Int;

	public var item:T;

    public var prev:IListObject<T>;

    public var next:IListObject<T>;

	public function new(item:T, prev:IListObject<T>, next:IListObject<T>) {
		
		this.item = item;

		this.prev = prev;

		this.next = next;
	}
}