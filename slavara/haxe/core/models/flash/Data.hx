package slavara.haxe.core.models.flash;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.Models.DataBaseNativeEvent;
import slavara.haxe.core.Models.DataContainer;
import slavara.haxe.core.models.flash.Data.EventContainer;
using Reflect;
using Std;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {
	
	@:noCompletion static var eventContainer:EventContainer = new EventContainer();
	
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
		if(!event.getProperty("_stopped")){
			var target = _bubbleParent;
			while(target != null) {
				if(target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					event.setProperty("_eventPhase", EventPhase.BUBBLING_PHASE);
					event.setProperty("_target", this);
					event.setProperty("_canceled", canceled);
					eventContainer.event = event;
                    target.safeDispatchEvent(eventContainer);
					canceled = event.getProperty("_canceled");
					if(event.getProperty("_stopped")) break;
				}
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
}

@:noCompletion extern class EventContainer extends Event {
	function new();
	var event:Event;
}