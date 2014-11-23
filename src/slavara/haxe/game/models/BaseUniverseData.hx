package slavara.haxe.game.models;
import slavara.haxe.game.models.prototypes.RewardProto;
import slavara.haxe.game.models.prototypes.ScreenProto;
import slavara.haxe.game.models.prototypes.UserProto;
import slavara.haxe.game.models.prototypes.WorldProto;
import slavara.haxe.game.Models.PrototypesCollection;
import slavara.haxe.game.Models.UnknownData;
import slavara.haxe.game.Models.UnknownProto;
import slavara.haxe.game.models.UserData;
import slavara.haxe.game.models.WorldData;
using Reflect;

/**
 * @author SlavaRa
 */
class BaseUniverseData extends UnknownData {
	
	public function new() super(new PrototypesCollectionData());
	
	public var world(default, null):WorldData;
	public var user(default, null):UserData;
	
	override function initialize() {
		super.initialize();
		var prototypes:PrototypesCollectionData = cast(proto, PrototypesCollectionData);
		addChild(world = new WorldData(prototypes.world));
		addChild(user = new UserData(prototypes.user));
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("prototypes")) proto.readExternal(input.getProperty("prototypes"));
		if(input.hasField("global")) deserializeGlobal(input.getProperty("global"));
	}
	
	inline function deserializeGlobal(input:Dynamic) {
		if(input.hasField("world")) world.readExternal(input.getProperty("world"));
		if(input.hasField("user")) user.readExternal(input.getProperty('user'));
	}
}

/**
 * @author SlavaRa
 */
private class PrototypesCollectionData extends UnknownProto {
	
	public function new() super();
	
	public var screens(default, null):PrototypesCollection<ScreenProto>;
	public var world(default, null):WorldProto;
	public var user(default, null):UserProto;
	public var rewards(default, null):PrototypesCollection<RewardProto>;
	
	override function initialize() {
		super.initialize();
		addChild(screens = new PrototypesCollection<ScreenProto>("screens"));
		addChild(world = new WorldProto());
		addChild(user = new UserProto());
		addChild(rewards = new PrototypesCollection<RewardProto>("rewards"));
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("screens")) screens.readExternal(input.getProperty("screens"));
		if(input.hasField("world")) world.readExternal(input.getProperty("world"));
		if(input.hasField("user")) user.readExternal(input.getProperty('user'));
		if(input.hasField("rewards")) rewards.readExternal(input.getProperty("rewards"));
	}
}