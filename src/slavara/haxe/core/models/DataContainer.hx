package slavara.haxe.core.models;

/**
 * @author SlavaRa
 */
class DataContainer extends Data {

	function new() {
		super();
		_list = [];
	}
	
	public var numChildren(get, null):Int;
	
	public function addChild(child:Data):Data return addChildAt(child, _list.length);
	
	public function addChildAt(child:Data, index:Int):Data {
		if (child.parent == this) {
			setChildIndex(child, index);
			return child;
		}
		
		if (child.parent != null) {
			child.parent.removeChild(child);
		}
		
		_list.insert(index, child);
		child.setParent(this);
		return child;
	}
	
	public function removeChild(child:Data):Data {
		_list.remove(child);
		child.setParent(null);
		return child;
	}
	
	public function removeChildAt(index:Int):Data return removeChild(_list[index]);
	
	public function removeChildren(beginIndex:Int = 0, endIndex:Int = -1) {
		if(_list.length == 0) {
			return;
		}
		
		if(endIndex == -1 || endIndex > _list.length) {
			endIndex = _list.length;
		}
		
		for (child in _list.splice(beginIndex, endIndex - beginIndex)) {
			child.setParent(null);
		}
	}
	
	public function getChildAt(index:Int):Data return _list[index];
	
	public function getChildByName(name:String):Data {
		for (child in _list) {
			if (child.name == name) {
				return child;
			}
		}
		return null;
	}
	
	public function getChildIndex(child:Data):Int return Lambda.indexOf(_list, child);
	
	public function setChildIndex(child:Data, index:Int) {
		_list.remove(child);
		_list.insert(index, child);
	}
	
	public function swapChildren(child1:Data, child2:Data) {
		var index1 = Lambda.indexOf(_list, child1);
		var index2 = Lambda.indexOf(_list, child2);
		
		_list.remove(child1);
		_list.remove(child2);
		_list.insert(index1, child2);
		_list.insert(index2, child1);
	}
	
	public function swapChildrenAt(index1:Int, index2:Int) {
		var child1 = _list[index1];
		var child2 = _list[index2];
		
		_list.remove(child1);
		_list.remove(child2);
		_list.insert(index1, child2);
		_list.insert(index2, child1);
	}
	
	public function contains(child:Data):Bool {
		do {
			if (child == this) {
				return true;
			}
			child = child.parent;
		} while (child != null);
		return false;
	}
	
	public function sort(f : Data -> Data -> Int) return _list.sort(f);
	
	function get_numChildren():Int return _list.length;
	
	var _list:Array<Data>;
	
}