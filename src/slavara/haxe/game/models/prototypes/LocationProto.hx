package slavara.haxe.game.models.prototypes;
import slavara.haxe.game.Models.UnknownProto;
import slavara.haxe.game.Resource.SWFResRef;
using Reflect;

/**
 * @author SlavaRa
 */
class LocationProto extends UnknownProto {

	public function new() super();
	
	public var asset(default, null):SWFResRef;
	
	override function initialize() {
		super.initialize();
		asset = new SWFResRef();
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("asset")) asset.readExternal(input.getProperty("asset"));
	}
}