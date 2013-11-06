package slavara.haxe.core.display.openfl;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import slavara.haxe.core.utils.Validate;

/**
 * @author SlavaRa
 */
@:noCompletion class BaseSprite extends Sprite {

	public function new() {
		super();
		mouseEnabled = false;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
	}
	
	@:noCompletion
	var _addedToStage:Bool;
	
	@:noCompletion
	@:final function onAddedToStageHandler(event:Event) {
		if(_addedToStage) {
			event.stopImmediatePropagation();
		} else {
			_addedToStage = true;
			onAddedToStage();
		}
	}
	
	@:noCompletion
	@:final function onRemovedFromStageHandler(_) {
		_addedToStage = false;
        onRemovedFromStage();
	}
	
	function onAddedToStage() { };
	function onRemovedFromStage() { };
	
	public override function getChildByName(name:String):DisplayObject {
		var child = super.getChildByName(name);
		if (Validate.isNull(child) && name.indexOf(".") != -1) {
			return getChildByPath(this, name);
		}
		return child;
	}
	
	@:noCompletion
	@:final function getChildByPath(container:DisplayObjectContainer, path:String):DisplayObject {
		var child:DisplayObject = null;
		var names = path.split(".");
		while (names.length > 0) {
			var name = names.shift();
			child = container.getChildByName(name);
			if(names.length == 0) {
				return child;
			}
			if(Validate.isNull(child) || !Std.is(child, DisplayObjectContainer)) {
				return null;
			}
			container = cast(child, DisplayObjectContainer);
		}
		
		return child;
	}
}