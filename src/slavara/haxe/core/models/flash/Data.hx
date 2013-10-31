package slavara.haxe.core.models.flash;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.EventPhase;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data.DataBaseNativeEvent;
import slavara.haxe.core.models.Data.DataContainer;
import slavara.haxe.core.models.flash.Data.EventContainer;
import slavara.haxe.core.utils.ValidateUtils;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {
	
	static var eventContainer:EventContainer = new EventContainer();
	
	function new() {
		super();
	}
	
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
		
		if(!Reflect.getProperty(event, "_stopped")){
			var target = _bubbleParent;
			while (ValidateUtils.isNotNull(target)) {
				if (target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					Reflect.setProperty(event, "_eventPhase", EventPhase.BUBBLING_PHASE);
					Reflect.setProperty(event, "_target", this);
					Reflect.setProperty(event, "_canceled", canceled);
					eventContainer.event = event;
                    target.safeDispatchEvent(eventContainer);
					canceled = Reflect.getProperty(event, "_canceled");
					if (Reflect.getProperty(event, "_stopped")) {
						break;
					}
				}
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
}

extern class EventContainer extends Event {
	function new();
	var event:Event;
}