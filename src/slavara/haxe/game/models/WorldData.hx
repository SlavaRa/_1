package slavara.haxe.game.models;
import slavara.haxe.game.Models.DataCollection;
import slavara.haxe.game.models.LocationData;
import slavara.haxe.game.models.prototypes.WorldProto;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
class WorldData extends LocationData {

	public function new(proto:UnknownProto) super(proto);
	
	public var locations(default, null):DataCollection<LocationData>;
	public var currentLocation:LocationData;
	
	override function initialize() {
		super.initialize();
		var proto:WorldProto = cast(proto, WorldProto);
		locations = new DataCollection<LocationData>(proto.locations, "locations");
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		locations.readExternal(input);
	}
}