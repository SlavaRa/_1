package slavara.haxe.core.events.models;
import flash.events.Event;
import slavara.haxe.core.Models.DataBaseNativeEvent;

/**
 * @author SlavaRa
 */
class DataBaseEvent extends DataBaseNativeEvent {

	public static inline var ADDED = "added";
	public static inline var REMOVED = "removed";
	public static inline var CHANGE = "change";
	
	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false) {
		super(type, bubbles, cancelable);
	}
}