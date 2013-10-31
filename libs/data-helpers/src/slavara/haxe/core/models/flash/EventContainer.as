package slavara.haxe.core.models.flash {
	import flash.events.Event;
	
	/**
	 * @author SlavaRa
	 */
	public final class EventContainer extends Event {
		
		public function EventContainer() {
			super("", true);
			_target = { };
		}
		
		private var _target:Object;
		public override function get target():Object {
			return _target;
		}
		
		public var event:Event;
		public override function clone():Event {
			return event;
		}
	}
}