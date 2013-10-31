package slavara.haxe.core.display.openfl;
import flash.display.Sprite;
import flash.events.Event;

/**
 * @author SlavaRa
 */
class BaseSprite extends Sprite {

	public function new() {
		super();
		mouseEnabled = false;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler, false, 0, true);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler, false, 0, true);
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
}