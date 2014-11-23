package slavara.haxe.game.models.prototypes;
import slavara.haxe.game.Models.UnknownProto;
using Reflect;

/**
 * @author SlavaRa
 */
class ScreenProto extends UnknownProto {

	public function new() super();
	
	public var to(default, null):Array<String>;
	public var via(default, null):Array<String>;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("to")) to = input.getProperty("to");
		if(input.hasField("via")) via = input.getProperty("via");
	}
}