package slavara.haxe.core.display.openfl;
import format.SWF;
import openfl.Assets;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.game.Resource.ResRef;
import slavara.haxe.game.Resource.SWFResRef;
using Std;
using StringTools;

/**
 * @author SlavaRa
 */
class ResourceSprite extends BaseSprite {

	public function new() super();
	
	public function hasResource(ref:ResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		if(ref.is(SWFResRef)) return hasSWF(cast(ref, SWFResRef));
		return Assets.exists(ref.link);
	}
	
	public function hasSWF(ref:SWFResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		return Assets.exists(ref.swf);
	}
	
	public function getSWF(ref:SWFResRef):SWF {
		return hasSWF(ref) ? new SWF(Assets.getBytes(ref.swf)) : null;
	}
}