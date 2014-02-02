package slavara.haxe.core;
import flash.events.Event;
import slavara.haxe.core.Errors.NullArgumentError;
import slavara.haxe.core.Interfaces.IExternalizableObject;
import slavara.haxe.core.Models.DataContainer;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Lambda;
using Std;

#if (cpp || neko)
typedef Data = slavara.haxe.core.models.native.Data;
#elseif js 
typedef Data = slavara.haxe.core.models.html5.Data;
#elseif flash
typedef Data = slavara.haxe.core.models.flash.Data;
#end

/**
 * @author SlavaRa
 */
class DataValueObjectContainer extends DataContainer implements IExternalizableObject {
	
	function new() super();
	
	@:final public function readExternal(input:Dynamic) deserialize(input);
	@:final public function writeExternal(output:Dynamic) serialize(output);
	
	function deserialize(input:Dynamic) { }
	function serialize(output:Dynamic) { }
}

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
		#if debug
		if(child.isNull()) throw new NullArgumentError("child");
		#end
		if(child.parent == this) {
			setChildIndex(child, index);
			return child;
		}
		if(child.parent != null) {
			child.parent.removeChild(child);
		}
		_list.insert(index, child);
		child.setParent(this);
		return child;
	}
	
	public function removeChild(child:Data):Data {
		#if debug
		if(child.isNull()) throw new NullArgumentError("child");
		#end
		_list.remove(child);
		child.setParent(null);
		return child;
	}
	
	public function removeChildAt(index:Int):Data return removeChild(_list[index]);
	
	public function removeChildren(beginIndex:Int = 0, ?endIndex:Int = -1) {
		if(_list.empty()) {
			return;
		}
		if(endIndex == -1 || endIndex > _list.length) {
			endIndex = _list.length;
		}
		for(child in _list.splice(beginIndex, endIndex - beginIndex)) {
			child.setParent(null);
		}
	}
	
	public function getChildAt(index:Int):Data return _list[index];
	
	public function getChildByName(name:String):Data {
		for(child in _list) {
			if(child.name == name) {
				return child;
			}
		}
		return name.indexOf(".") != -1 ? getChildByPath(this, name) : null;
	}
	
	public function getChildIndex(child:Data):Int {
		#if debug
		if(child.isNull()) throw new NullArgumentError("child");
		#end
		return _list.indexOf(child);
	}
	
	public function setChildIndex(child:Data, index:Int) {
		#if debug
		if(child.isNull()) throw new NullArgumentError("child");
		#end
		_list.remove(child);
		_list.insert(index, child);
	}
	
	public function swapChildren(child1:Data, child2:Data) {
		#if debug
		if(child1.isNull()) throw new NullArgumentError("child1");
		if(child2.isNull()) throw new NullArgumentError("child2");
		#end
		swap(child1, child2, _list.indexOf(child1), _list.indexOf(child2));
	}
	
	public function swapChildrenAt(index1:Int, index2:Int) swap(_list[index1], _list[index2], index1, index2);
	
	public function contains(child:Data):Bool {
		#if debug
		if(child.isNull()) throw new NullArgumentError("child");
		#end
		do {
			if(child == this) {
				return true;
			}
			child = child.parent;
		} while(child != null);
		return false;
	}
	
	public function sort(f : Data -> Data -> Int) _list.sort(f);
	
	@:final @:noCompletion inline function getChildByPath(container:DataContainer, path:String):Data {
		var names = path.split(".");
		var child = container.getChildByName(names.shift());
		if(child.isNotNull() && names.empty()) {
			return child;
		} else if(!child.is(DataContainer)) {
			return null;
		} else {
			return getChildByPath(cast(child, DataContainer), names.join("."));
		}
	}
	
	@:final @:noCompletion inline function swap(child1:Data, child2:Data, index1:Int, index2:Int) {
		_list.remove(child1);
		_list.remove(child2);
		_list.insert(index1, child2);
		_list.insert(index2, child1);
	}
}

#if flash
//XXX: move to events
//TODO: доступ к полям должен быть через неймспейс
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