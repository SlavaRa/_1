package slavara.haxe.game.display;
import flash.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import slavara.haxe.core.display.openfl.ResourceSprite;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Utils.DisposeUtil;
import slavara.haxe.game.Models.UnknownData;
import slavara.haxe.game.Resource.SWFResRef;
using slavara.haxe.core.Utils.DisplayUtils;
using Std;

/**
 * @author SlavaRa
 */
class ScreenView extends ResourceSprite {

	function new(?asset:DisplayObjectContainer) {
		super();
		_asset = asset;
	}
	
	public var data(null, set):UnknownData;
	var _asset(default, null):DisplayObjectContainer;
	
	inline function set_data(value:UnknownData):UnknownData {
		if(value != data) {
			data = value;
			update();
		}
		return data;
	}
	
	public override function dispose() {
		data = null;
		super.dispose();
	}
	
	public function setAsset(ref:SWFResRef) {
		#if debug
		if(ref == null) throw new ArgumentNullError("res");
		#end
		var index = 0;
		if(_asset != null && _asset.parent != null) {
			index = getChildIndex(_asset);
			removeChild(_asset);
		}
		DisposeUtil.dispose(_asset, false);
		#if swf
		_asset = cast(getSWF(ref).createMovieClip(ref.link), DisplayObjectContainer);
		addChildAt(_asset, index);
		#end
	}
	
	public function getContainer(name:String):DisplayObjectContainer {
		if(_asset == null) return null;
		var child = _getChildByName(_asset, name);
		return child != null && child.is(DisplayObjectContainer) ? cast(child, DisplayObjectContainer) : null;
	}
	
	public function addChildWithContainer(child:DisplayObject, container:DisplayObject) {
		var index = _asset.getChildIndex(container);
		if(index >= numChildren) index = numChildren - 1;
		addChildAt(child.setXY(container.x, container.y), index);
	}
}