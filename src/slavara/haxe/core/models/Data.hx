package slavara.haxe.core.models;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventPhase;
import haxe.Log;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data.DataBaseNativeEvent;
import slavara.haxe.core.models.Data.DataContainer;
import slavara.haxe.core.utils.StringUtils;
import slavara.haxe.core.utils.ValidateUtils;

/**
 * @author SlavaRa
 * TODO: сделать обертку для баблинга
 * TODO: добавить валидацию параметров паблик методов
 */
class Data extends EventDispatcher {
	
	#if flash
	//@:noCompletion
	//static var eventContainer = new EventContainer();
	#end
	
	function new() super();
	
	public var name:String;
	public var parent(default, null):DataContainer;
	
	@:noCompletion
	var _bubbleParent:Data;
	
	function setParent(value:DataContainer) {
		if(value == parent) {
			return;
		}
		
		if(ValidateUtils.isNotNull(parent)) {
			_bubbleParent = parent;
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		_bubbleParent = value;
		if(ValidateUtils.isNotNull(value)) {
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.ADDED, true));
		}
	}
	
	public override function dispatchEvent(event:Event):Bool {
		if (event.bubbles) {
			if (Std.is(event, DataBaseEvent)) {
				return dispatchEventFunction(cast(event, DataBaseEvent));
			}
			throw "bubbling поддерживается только у событий наследованных от DataBaseEvent";
		}
		return super.dispatchEvent(event);
	}
	
	@:noCompletion
	public override function willTrigger(type:String):Bool {
		if (hasEventListener(type)) {
			return true;
		}
		
		var target = _bubbleParent;
		while (ValidateUtils.isNotNull(target)) {
			if (target.hasEventListener(type)) {
				return true;
			}
			target = target._bubbleParent;
		}
		return false;
	}
	
	@:noCompletion
	function safeDispatchEvent(event:Event):Bool return super.dispatchEvent(event);
	
	@:noCompletion
	function dispatchEventFunction(event:DataBaseNativeEvent):Bool {
		var canceled = false;
		if (hasEventListener(event.type)) {
			canceled = !(super.dispatchEvent(event));
		}
		
		#if (cpp || neko)
		var stopped = Reflect.getProperty(event, "__isCancelledNow");
		#elseif js
		var stopped = Reflect.getProperty(event, "nmeIsCancelled");
		#elseif flash
		//TODO: implement me
		#end
		
		if(!stopped){
			var target = _bubbleParent;
			while (ValidateUtils.isNotNull(target)) {
				if (target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					#if (cpp || neko)
					event.target = this;
					target.safeDispatchEvent(event);
					canceled = Reflect.getProperty(event, "__isCancelled");
					if(Reflect.getProperty(event, "__isCancelledNow")) {
						break;
					}
					#elseif js
					Reflect.setProperty(event, "target", this);
					target.safeDispatchEvent(event);
					canceled = Reflect.getProperty(event, "nmeIsCancelled");
					if (Reflect.getProperty(event, "nmeIsCancelledNow")) {
						break;
					}
					#elseif flash
					//TODO:
					#end
				}
				
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
}

/**
 * @author SlavaRa
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
/**
 * @author SlavaRa
 * @private
 */
private class EventContainer extends Event {
	
	public function new() super("", true);
	
	@:getter(target)
	function get_target():Dynamic return { };
	
	public var event:Event;
	public override function clone():Event return event;
}
#end

/**
 * @author SlavaRa
 */
class DataBaseNativeEvent extends Event {
	
	function new(type:String, ?bubbles:Bool, ?cancelable:Bool) {
		super(type, bubbles, cancelable);
	}
	
	#if flash
	var _target:Dynamic;
	var _stopped:Bool;
	var _canceled:Bool;
	var _eventPhase:EventPhase;
	
	@:getter(target)
	private function get_target():Dynamic {
		return ValidateUtils.isNotNull(_target) ? _target : target;
	}
	
	@:getter(eventPhase)
	private function get_eventPhase():EventPhase {
		return ValidateUtils.isNotNull(_eventPhase) ? _eventPhase : eventPhase;
	}
	
	public override function stopPropagation() _stopped = true;
	
	public override function isDefaultPrevented():Bool return _canceled;
	
	public override function preventDefault() {
		if (cancelable) {
			super.preventDefault();
			_canceled = true;
		}
	}
	
	public override function stopImmediatePropagation() {
		super.stopImmediatePropagation();
		_stopped = true;
	}
	
	public override function formatToString(className:String, ?p1 : Dynamic, ?p2 : Dynamic, ?p3 : Dynamic, ?p4 : Dynamic, ?p5 : Dynamic):String {
		if(!StringUtils.isNullOrEmpty(className)) {
			className = "DataBaseNativeEvent";
		}
		return super.formatToString(className, p1, p2, p3, p4, p5);
	}
	#end
	
	public override function toString():String {
		#if flash
		return super.formatToString("DataBaseNativeEvent", "type", "bubbles", "cancelable");
		#else
		return "[Event type=DataBaseNativeEvent bubbles=" + bubbles + " cancelable=" + cancelable + "]";
		#end
	}
	
	public override function clone():Event {
		return Type.createInstance(DataBaseNativeEvent, [type, bubbles, cancelable]);
	}
}