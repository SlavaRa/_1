package slavara.haxe.core.models.flash;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventPhase;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data.DataBaseNativeEvent;
import slavara.haxe.core.models.Data.DataContainer;
import slavara.haxe.core.models.flash.Data.EventContainer;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Reflect;
using Std;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {
	
	@:noCompletion static var eventContainer:EventContainer = new EventContainer();
	
	function new() {
		super();
	}
	
	public var name:String;
	public var parent(default, null):DataContainer;
	
	@:noCompletion var _bubbleParent:Data;
	
	@:final function setParent(value:DataContainer) {
		if(value == parent) {
			return;
		}
		if(parent.isNotNull()) {
			_bubbleParent = parent;
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		_bubbleParent = value;
		if(parent.isNotNull()) {
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.ADDED, true));
		}
	}
	
	public override function dispatchEvent(event:Event):Bool {
		if(event.bubbles) {
			if(event.is(DataBaseEvent)) {
				return dispatchEventFunction(cast(event, DataBaseEvent));
			}
			throw "bubbling поддерживается только у событий наследованных от DataBaseEvent";
		}
		return super.dispatchEvent(event);
	}
	
	@:noCompletion public override function willTrigger(type:String):Bool {
		if(hasEventListener(type)) {
			return true;
		}
		var target = _bubbleParent;
		while(target.isNotNull()) {
			if(target.hasEventListener(type)) {
				return true;
			}
			target = target._bubbleParent;
		}
		return false;
	}
	
	@:final @:noCompletion function safeDispatchEvent(event:Event):Bool return super.dispatchEvent(event);
	
	@:final @:noCompletion function dispatchEventFunction(event:DataBaseNativeEvent):Bool {
		var canceled = false;
		if (hasEventListener(event.type)) {
			canceled = !(super.dispatchEvent(event));
		}
		if(!event.getProperty("_stopped")){
			var target = _bubbleParent;
			while(target.isNotNull()) {
				if(target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					event.setProperty("_eventPhase", EventPhase.BUBBLING_PHASE);
					event.setProperty("_target", this);
					event.setProperty("_canceled", canceled);
					eventContainer.event = event;
                    target.safeDispatchEvent(eventContainer);
					canceled = event.getProperty("_canceled");
					if (event.getProperty("_stopped")) {
						break;
					}
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