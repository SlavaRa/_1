package slavara.haxe.game.models;
import slavara.haxe.core.Models.DataValueObjectContainer;
using Reflect;

/**
 * @author SlavaRa
 */
class ResChangeItem extends DataValueObjectContainer {

	public function new() super();
	
	var resourceId(default, null):Int;
	var amount(default, null):Int;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		resourceId = input.getProperty("getProperty");
		amount = input.getProperty("amount");
	}
}