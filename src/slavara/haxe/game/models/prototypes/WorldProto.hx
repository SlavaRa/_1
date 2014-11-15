package slavara.haxe.game.models.prototypes;
import slavara.haxe.game.Models.PrototypesCollection;

/**
 * @author SlavaRa
 */
class WorldProto extends LocationProto {
	
	public function new() super();
	
	public var locations(default, null):PrototypesCollection<LocationProto>;
	
	override function initialize() {
		super.initialize();
		locations = new PrototypesCollection<LocationProto>("locations");
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		locations.readExternal(input);
	}
}