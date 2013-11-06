package slavara.haxe.core.models.html5;
import flash.events.Event;
import flash.events.EventDispatcher;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data.DataBaseNativeEvent;
import slavara.haxe.core.models.Data.DataContainer;
import slavara.haxe.core.utils.Validate;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {

	function new() super();
	
	public var name:String;
	public var parent(default, null):DataContainer;
	
	@:noCompletion var _bubbleParent:Data;
	
	@:final function setParent(value:DataContainer) {
		if(value == parent) {
			return;
		}
		
		if(Validate.isNotNull(parent)) {
			_bubbleParent = parent;
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		_bubbleParent = value;
		if(Validate.isNotNull(value)) {
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
	
	@:noCompletion public override function willTrigger(type:String):Bool {
		if (hasEventListener(type)) {
			return true;
		}
		
		var target = _bubbleParent;
		while (Validate.isNotNull(target)) {
			if (target.hasEventListener(type)) {
				return true;
			}
			target = target._bubbleParent;
		}
		return false;
	}
	
	@:noCompletion function safeDispatchEvent(event:Event):Bool return super.dispatchEvent(event);
	
	@:noCompletion function dispatchEventFunction(event:DataBaseNativeEvent):Bool {
		var canceled = false;
		if (hasEventListener(event.type)) {
			canceled = !(super.dispatchEvent(event));
		}
		
		if(!Reflect.getProperty(event, "nmeIsCancelled")){
			var target = _bubbleParent;
			while (Validate.isNotNull(target)) {
				if (target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					Reflect.setProperty(event, "target", this);
					target.safeDispatchEvent(event);
					canceled = Reflect.getProperty(event, "nmeIsCancelled");
					if (Reflect.getProperty(event, "nmeIsCancelledNow")) {
						break;
					}
				}
				
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
	
}