package slavara.haxe.core.models.native;
import flash.events.Event;
import flash.events.EventDispatcher;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data.DataBaseNativeEvent;
import slavara.haxe.core.models.Data.DataContainer;
import slavara.haxe.core.utils.Utils.ValidateUtil;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {

	public function new() super();
	
	public var name:String;
	public var parent(default, null):DataContainer;
	
	@:noCompletion var _bubbleParent:Data;
	
	@:final function setParent(value:DataContainer) {
		if(value == parent) {
			return;
		}
		if(ValidateUtil.isNotNull(parent)) {
			_bubbleParent = parent;
			dispatchEventFunction(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		_bubbleParent = value;
		if(ValidateUtil.isNotNull(value)) {
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
		while (ValidateUtil.isNotNull(target)) {
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
		if(!Reflect.getProperty(event, "__isCancelledNow")){
			var target = _bubbleParent;
			while (ValidateUtil.isNotNull(target)) {
				if (target.hasEventListener(event.type)) {
					event = cast(event.clone(), DataBaseNativeEvent);
					event.target = this;
					target.safeDispatchEvent(event);
					canceled = Reflect.getProperty(event, "__isCancelled");
					if(Reflect.getProperty(event, "__isCancelledNow")) {
						break;
					}
				}
				target = target._bubbleParent;
			}
		}
		return !canceled;
	}
}