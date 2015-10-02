package slavara.haxe.core.display.openfl;
#if swf
import format.SWF;
#end
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

	public function hasResource(ref:ResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		#if swf
		if(ref.is(SWFResRef)) return hasSWF(cast(ref, SWFResRef));
		#end
		return Assets.exists(ref.link);
	}
	
	#if swf
	public function hasSWF(ref:SWFResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		return Assets.exists(ref.swf);
	}
	
	public function getSWF(ref:SWFResRef):SWF {
		return hasSWF(ref) ? new SWF(Assets.getBytes(ref.swf)) : null;
	}
	#end
}