package slavara.haxe.core.models {
	import flash.events.Event;
	import flash.events.EventPhase;
	
	/**
	 * @author SlavaRa
	 * //TODO: изменил модификатор досутпа для полей c паблик на неймспейс
	 */
	public class DataBaseNativeEvent extends Event {
		
		public function DataBaseNativeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public var _target:Object;
		public var _stopped:Boolean;
		public var _canceled:Boolean;
		public var _eventPhase:uint;
		
		public override function get target():Object {
			return _target != null ? _target : super.target;
		}
		
		public override function get eventPhase():uint {
			return _eventPhase != 0 ? _eventPhase : super.eventPhase;
		}
		
		public override function stopPropagation():void {
			_stopped = true;
		}
		
		public override function stopImmediatePropagation():void {
			super.stopImmediatePropagation();
			_stopped = true;
		}
		
		public override function preventDefault():void {
			if(cancelable) {
				super.preventDefault();
				_canceled = true;
			}
		}
		
		public override function clone():Event {
			const cls:Class = this["constructor"] as Class;
			return new cls(super.type, super.bubbles, super.cancelable);
		}
		
		public override function formatToString(className:String, ...rest):String {
			if (className != null && className.length > 0) {
				className = "DataBaseNativeEvent";
				(rest as Array).unshift(className);
			}
			return super.formatToString.apply(this, rest);
		}
		
		public override function toString():String {
			return super.formatToString("DataBaseNativeEvent", "type", "bubbles", "cancelable");
		}
	}
}