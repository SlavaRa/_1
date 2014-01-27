package slavara.haxe.core.display.openfl;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import slavara.haxe.core.utils.Utils.IDestroyable;
import slavara.haxe.core.utils.Utils.ValidateUtil;

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
	
	@:final @:noCompletion function onRemovedFromStageHandler(_) {
		_addedToStage = false;
        onRemovedFromStage();
	}
	
	function onAddedToStage() { }
	function onRemovedFromStage() { }
	
	public override function getChildByName(name:String):DisplayObject {
		var child = super.getChildByName(name);
		if (ValidateUtil.isNull(child) && name.indexOf(".") != -1) {
			return getChildByPath(this, name);
		}
		return child;
	}
	
	@:final @:noCompletion function getChildByPath(container:DisplayObjectContainer, path:String):DisplayObject {
		var child:DisplayObject = null;
		var names = path.split(".");
		while (names.length > 0) {
			var name = names.shift();
			child = container.getChildByName(name);
			if(names.length == 0) {
				return child;
			}
			if(ValidateUtil.isNull(child) || !Std.is(child, DisplayObjectContainer)) {
				return null;
			}
			container = cast(child, DisplayObjectContainer);
		}
		
		return child;
	}
}