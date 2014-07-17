package slavara.haxe.core.display.openfl;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import slavara.haxe.core.Interfaces.IDestroyable;
using slavara.haxe.core.Utils.ValidateUtil;
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
			render();
		}
	}
	
	@:final @:noCompletion function onRemovedFromStageHandler(?_) {
		_addedToStage = false;
        clear();
	}
	
	@:final public override function getChildByName(name:String):DisplayObject return _getChildByName(this, name);
	
	@:final function _getChildByName(container:DisplayObjectContainer, name:String):DisplayObject {
		var child = container.getChildByName(name);
		if(child.isNull() && name.indexOf(".") != -1) {
			return getChildByPath(container, name);
		}
		return child;
	}
	
	@:noCompletion inline function getChildByPath(container:DisplayObjectContainer, path:String):DisplayObject {
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
	
	function render():Bool {
		update();
		return true;
	}
	
	function update() { }
	
	function clear() { }
}