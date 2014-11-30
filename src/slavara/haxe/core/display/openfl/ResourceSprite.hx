package slavara.haxe.core.display.openfl;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Stage;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Utils.DisposeUtil;
import slavara.haxe.game.Resource.ResRef;
#if swf
import format.SWF;
import format.swf.instance.MovieClip;
import slavara.haxe.game.Resource.SWFResRef;
#end
using Std;

/**
 * @author SlavaRa
 */
class ResourceSprite extends BaseSprite {

	public function new() super();
	
	var container(null, set):DisplayObjectContainer;
	function set_container(value:DisplayObjectContainer):DisplayObjectContainer {
		if(value != container) {
			container = value;
			render();
		}
		return container;
	}
	
	public override function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void {
		if(container == null) super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		else container.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}
	
	public override function removeEventListener(type:String, listener:Dynamic->Void, capture:Bool = false):Void {
		if(container == null) super.removeEventListener(type, listener, capture);
		else container.removeEventListener(type, listener, capture);
	}
	
	public override function hasEventListener(type:String):Bool {
		return container != null ? container.hasEventListener(type) : super.hasEventListener(type);
	}
	
	public override function willTrigger(type:String):Bool {
		return container != null ? container.willTrigger(type) : super.willTrigger(type);
	}
	
	@:final public override function getChildByName(name:String):DisplayObject {
		return container != null ? _getChildByName(container, name) : super.getChildByName(name);
	}
	
	override function render():Bool {
		if(!super.render()) return false;
		if(container != null && container.parent == null) addChild(container);
		return true;
	}
	
	override function clear() {
		container = null;
		super.clear();
	}
	
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
	
	function createClipFromSWF(ref:SWFResRef):MovieClip return hasSWF(ref) ? new SWF(Assets.getBytes(ref.swf)).createMovieClip(ref.link) : null;
	#end
}