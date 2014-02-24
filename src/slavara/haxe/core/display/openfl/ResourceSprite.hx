package slavara.haxe.core.display.openfl;
import format.SWF;
import openfl.Assets;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.TypeDefs.DisplayObjectContainer;
import slavara.haxe.core.utils.Utils.DestroyUtil;
import slavara.haxe.game.Resource.ResRef;
import slavara.haxe.game.Resource.SWFResRef;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Std;
using StringTools;

/**
 * @author SlavaRa
 */
class ResourceSprite extends BaseSprite {

	public function new() super();
	
	public var asset(default, null):DisplayObjectContainer;
	
	public override function destroy() {
		super.destroy();
		asset = DestroyUtil.destroy(asset);
	}
	
	public function hasResource(resRef:ResRef):Bool {
		#if debug
		if(resRef.isNull()) throw new ArgumentNullError("resRef");
		#end
		
		if(resRef.is(SWFResRef)) return hasSWF(cast(resRef, SWFResRef));
		return Assets.exists(resRef.link);
	}
	
	public function hasSWF(resRef:SWFResRef):Bool {
		#if debug
		if(resRef.isNull()) throw new ArgumentNullError("resRef");
		#end
		
		return Assets.exists(resRef.swf);
	}
	
	public function setAsset(resRef:SWFResRef) {
		#if debug
		if(resRef.isNull()) throw new ArgumentNullError("resRef");
		#end
		
		DestroyUtil.destroy(asset, false);
		addChild(asset = cast(new SWF(Assets.getBytes(resRef.swf)).createMovieClip(resRef.link), DisplayObjectContainer));
	}
	
	public function getContainer(name:String):DisplayObjectContainer {
		if(asset.isNull()) return null;
		var child = _getChildByName(asset, name);
		return child.isNotNull() && child.is(DisplayObjectContainer) ? cast(child, DisplayObjectContainer) : null;
	}
}