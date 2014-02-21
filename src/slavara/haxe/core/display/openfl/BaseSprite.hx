package slavara.haxe.core.display.openfl;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import slavara.haxe.core.utils.Utils.IDestroyable;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Lambda;
using Std;

/**
 * @author SlavaRa
 */
@:noCompletion class BaseSprite extends Sprite implements IDestroyable {

	public function new() {
		super();
		mouseEnabled = false;
		_addedToStage = false;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
		initialize();
	}
	
	public function initialize() { }
	public function destroy() { }
	
	@:noCompletion var _addedToStage:Bool;
	
	@:final @:noCompletion function onAddedToStageHandler(event:Event) {
		if(_addedToStage) {
			event.stopImmediatePropagation();
		} else {
			_addedToStage = true;
			onAddedToStage();
		}
	}
	
	@:final @:noCompletion function onRemovedFromStageHandler(?_) {
		_addedToStage = false;
        onRemovedFromStage();
	}
	
	public override function getChildByName(name:String):DisplayObject {
		var child = super.getChildByName(name);
		if(child.isNull() && name.indexOf(".") != -1) {
			return getChildByPath(this, name);
		}
		return child;
	}
	
	@:final @:noCompletion inline function getChildByPath(container:DisplayObjectContainer, path:String):DisplayObject {
		var child:DisplayObject = null;
		var names = path.split(".");
		while(!names.empty()) {
			child = container.getChildByName(names.shift());
			if(names.empty()) {
				break;
			}
			if(child.isNull() || !child.is(DisplayObjectContainer)) {
				child = null;
				break;
			}
			container = cast(child, DisplayObjectContainer);
		}
		return child;
	}
	
	@:final @:noCompletion function onAddedToStage() render();
	
	@:final @:noCompletion function onRemovedFromStage() clear();
	
	function render():Bool {
		update();
		return true;
	}
	
	function clear() { }
	
	function update() { }
}