package slavara.haxe.core.models;
import flash.events.Event;
import slavara.haxe.core.utils.ValidateUtils;

#if (cpp || neko)
typedef Data = slavara.haxe.core.models.native.Data;
#elseif js 
typedef Data = slavara.haxe.core.models.html5.Data;
#elseif flash
typedef Data = slavara.haxe.core.models.flash.Data;
#end

/**
 * @author SlavaRa
 * TODO: добавить валидацию параметров паблик методов
 */
class DataContainer extends Data {

	function new() {
		super();
		_list = [];
	}
	
	var _list:Array<Data>;
	
	public var numChildren(get, null):Int;
	
	function get_numChildren():Int return _list.length;
	
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
	
	public function removeChildren(beginIndex:Int = 0, ?endIndex:Int = -1) {
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
		
		if(name.indexOf(".") != -1) {
			return getChildByPath(this, name);
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
	
	public function sort(f : Data -> Data -> Int) _list.sort(f);
	
	@:noComplete
	function getChildByPath(container:DataContainer, path:String):Data {
		var names = path.split(".");
		var child = container.getChildByName(names.shift());
		if(ValidateUtils.isNotNull(child) && names.length == 0) {
			return child;
		} else if(!Std.is(child, DataContainer)) {
			return null;
		}
		
		return getChildByPath(cast(child, DataContainer), names.join("."));
	}
}

#if flash
extern class DataBaseNativeEvent extends Event {
	function new(type:String, ?bubbles:Bool, ?cancelable:Bool);
	var _target:Dynamic;
	var _stopped:Bool;
	var _canceled:Bool;
	var _eventPhase:UInt;
}
#else
class DataBaseNativeEvent extends Event {
	
	function new(type:String, ?bubbles:Bool, ?cancelable:Bool) super(type, bubbles, cancelable);
	
	public override function toString():String {
		return "[Event type=DataBaseNativeEvent bubbles=" + bubbles + " cancelable=" + cancelable + "]";
	}
	
	public override function clone():Event {
		return Type.createInstance(Type.getClass(this), [type, bubbles, cancelable]);
	}
}
#end