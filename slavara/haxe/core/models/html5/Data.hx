package slavara.haxe.core.models.html5;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.Models.DataBaseNativeEvent;
import slavara.haxe.core.Models.DataContainer;
using Reflect;
using Std;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {

	public var name:String;
	public var parent(default, null):DataContainer;
	
	@:noCompletion var _bubbleParent:Data;
	
	@:final function setParent(value:DataContainer) {
		if(value == parent) return;
		if(parent != null) {
			_bubbleParent = parent;
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		_bubbleParent = value;
		if(parent != null) dispatchEventFunction(new DataBaseEvent(DataBaseEvent.ADDED, true));
	}
	
	public override function dispatchEvent(event:Event):Bool {
		if(event.bubbles) {
			if(event.is(DataBaseEvent)) return dispatchEventFunction(cast(event, DataBaseEvent));
			throw "bubbling поддерживается только у событий наследованных от DataBaseEvent";
		}
		return super.dispatchEvent(event);
	}
	
	@:noCompletion public override function willTrigger(type:String):Bool {
		if(hasEventListener(type)) return true;
		var target = _bubbleParent;
		while(target != null) {
			if(target.hasEventListener(type)) return true;
			target = target._bubbleParent;
		}
		return false;
	}
	
	@:final @:noCompletion function safeDispatchEvent(event:Event):Bool return super.dispatchEvent(event);
	
	@:final @:noCompletion function dispatchEventFunction(event:DataBaseNativeEvent):Bool {
		var canceled = false;
		if(hasEventListener(event.type)) canceled = !(super.dispatchEvent(event));
		if(!event.getProperty("nmeIsCancelled")){
			var target = _bubbleParent;
			while(target != null) {
				if(target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					event.setProperty("target", this);
					target.safeDispatchEvent(event);
					canceled = event.getProperty("nmeIsCancelled");
					if(event.getProperty("nmeIsCancelledNow")) break;
				}
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
}