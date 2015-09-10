package slavara.haxe.game;
import slavara.haxe.game.Models.UnknownProto;
import slavara.haxe.game.Resource.ResRef;
using Reflect;

/**
 * @author SlavaRa
 */
class ResRef extends UnknownProto {
	public function new() super();
	
	public var link(default, null):String;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("link")) link = input.getProperty("link");
	}
}

/**
 * @author SlavaRa
 */
class SWFResRef extends ResRef {
	public function new() super();
	
	public var swf(default, null):String;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("swf")) swf = input.getProperty("swf").replace("@", "swf/") + ".swf";//TODO: hardcode
	}
}