package slavara.haxe.core.display.openfl;
import format.SWF;
import openfl.Assets;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.TypeDefs.DisplayObject;
import slavara.haxe.core.TypeDefs.DisplayObjectContainer;
import slavara.haxe.core.Utils.DestroyUtil;
import slavara.haxe.game.Resource.ResRef;
import slavara.haxe.game.Resource.SWFResRef;
using slavara.haxe.core.Utils.DisplayUtils;
using slavara.haxe.core.Utils.ValidateUtil;
using Std;
using StringTools;

/**
 * @author SlavaRa
 */
class ResourceSprite extends BaseSprite {

	public function new(?asset:DisplayObjectContainer) {
		super();
		this.asset = asset;
	}
	
	//TODO: данный функционал должен быть на уровень выше
	var asset(default, null):DisplayObjectContainer;
	
	public override function destroy() {
		super.destroy();
		while(numChildren != 0) DestroyUtil.destroy(removeChildAt(0));
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
		
		var index = 0;
		if(asset.isNotNull() && asset.parent.isNotNull()) {
			index = getChildIndex(asset);
			removeChild(asset);
		}
		DestroyUtil.destroy(asset, false);
		asset = cast(new SWF(Assets.getBytes(resRef.swf)).createMovieClip(resRef.link), DisplayObjectContainer);
		addChildAt(asset, index);
	}
	
	public function getContainer(name:String):DisplayObjectContainer {
		if(asset.isNull()) return null;
		var child = _getChildByName(asset, name);
		return child.isNotNull() && child.is(DisplayObjectContainer) ? cast(child, DisplayObjectContainer) : null;
	}
	
	public function addChildWithContainer(child:DisplayObject, container:DisplayObject) {
		var index = asset.getChildIndex(container);
		if(index >= numChildren) index = numChildren - 1;
		addChildAt(child.setXY(container.x, container.y), index);
	}
}