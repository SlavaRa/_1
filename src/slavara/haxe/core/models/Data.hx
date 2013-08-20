package slavara.haxe.core.models;

import flash.events.EventDispatcher;
import slavara.haxe.core.events.models.DataBaseEvent;

/**
 * @author SlavaRa
 */
class Data extends EventDispatcher {

	function new() super();
	
	public var name:String;
	public var parent(default, null):DataContainer;
	
	function setParent(value:DataContainer) {
		if(value == parent) {
			return;
		}
		
		if(parent != null) {
			dispatchEvent(new DataBaseEvent(DataBaseEvent.REMOVED, true));
		}
		parent = value;
		if(parent != null) {
			dispatchEvent(new DataBaseEvent(DataBaseEvent.ADDED, true));
		}
	}
	
}