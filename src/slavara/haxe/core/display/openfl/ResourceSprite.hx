package slavara.haxe.core.display.openfl;
import openfl.Assets;
import openfl.display.Bitmap;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.game.Resource.ResRef;
#if swf
import format.SWF;
import slavara.haxe.game.Resource.SWFResRef;
#end
using Std;

/**
 * @author SlavaRa
 */
class ResourceSprite extends BaseSprite {

	public function new() super();
	
	function hasResource(ref:ResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		#if swf
		if(ref.is(SWFResRef)) return hasSWF(cast(ref, SWFResRef));
		#end
		return Assets.exists(ref.link);
	}
	
	function getBitmap(ref:ResRef, useCache:Bool = true):Bitmap {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		return new Bitmap(Assets.getBitmapData(ref.link, useCache));
	}
	
	#if swf
	function hasSWF(ref:SWFResRef):Bool {
		#if debug
		if(ref == null) throw new ArgumentNullError("ref");
		#end
		return Assets.exists(ref.swf);
	}
	
	function getSWF(ref:SWFResRef):SWF {
		return hasSWF(ref) ? new SWF(Assets.getBytes(ref.swf)) : null;
	}
	#end
}