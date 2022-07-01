package drc.ds;

import drc.ds.Object;

interface IListObject<T> {

    public var item:T;

    public var prev:IListObject<T>;

    public var next:IListObject<T>;
}