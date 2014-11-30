package slavara.haxe.game;
import slavara.haxe.game.Models.Unknown;
import slavara.haxe.game.Resource.ResRef;
using Reflect;
using slavara.haxe.core.Utils.StringUtil;

/**
 * @author SlavaRa
 */
class ResRef extends Unknown {
	public function new() super();
	
	public var link(default, null):String;
	
	public function getIsEmpty() return link.isNullOrEmpty();
	
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
	
	public override function getIsEmpty() return swf.isNullOrEmpty() && super.getIsEmpty();
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("swf")) swf = input.getProperty("swf");
	}
}