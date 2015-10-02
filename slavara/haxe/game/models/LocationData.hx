package slavara.haxe.game.models;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.game.Models.UnknownData;
import slavara.haxe.game.Models.UnknownProto;
using Reflect;

/**
 * @author SlavaRa
 */
class LocationData extends UnknownData {

	public function new(proto:UnknownProto) super(proto);
	
	public var isAvailable(default, null):Bool;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		
		var changed = false;
		if(input.hasField("is_available")) {
			isAvailable = input.getProperty("is_available") == 1;
			changed = true;
		}
		
		if(changed && willTrigger(DataBaseEvent.CHANGE)) {
			super.dispatchEvent(new DataBaseEvent(DataBaseEvent.CHANGE, true));
		}
	}
}