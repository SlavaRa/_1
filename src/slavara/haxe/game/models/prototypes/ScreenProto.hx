package slavara.haxe.game.models.prototypes;
import slavara.haxe.game.Models.UnknownProto;
import slavara.haxe.game.Resource.ResRef;
import slavara.haxe.game.Resource.SWFResRef;
using Reflect;

/**
 * @author SlavaRa
 */
class ScreenProto extends UnknownProto {

	public function new() super();
	
	override function initialize() {
		super.initialize();
		bkg = new ResRef();
		swf = new SWFResRef();
	}
	
	public var to(default, null):Array<String>;
	public var via(default, null):Array<String>;
	public var swf(default, null):SWFResRef;
	public var bkg(default, null):ResRef;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("to")) to = input.getProperty("to");
		if(input.hasField("via")) via = input.getProperty("via");
		if(input.hasField("swf")) swf.readExternal(input.getProperty("swf"));
		if(input.hasField("bkg")) bkg.readExternal(input.getProperty("bkg"));
	}
}