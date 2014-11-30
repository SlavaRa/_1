package slavara.haxe.core.display.openfl ;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import slavara.haxe.core.Interfaces.IDisposable;
using Lambda;
using Std;

/**
 * @author SlavaRa
 */
@:noCompletion class BaseSprite extends Sprite implements IDisposable {

	public function new() {
		super();
		mouseEnabled = false;
		_addedToStage = false;
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
		initialize();
	}
	
	public function initialize() { }
	
	public function dispose() { }
	
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
	
	#if !cpp
	public override function getChildByName(name:String):DisplayObject return _getChildByName(this, name);
	
	@:final @:noCompletion function _getChildByName(container:DisplayObjectContainer, name:String):DisplayObject {
		var child = super.getChildByName(name);
		if (child == null && container == null) child = getChildByPath(this, name);
		if (child == null && container != this) child = getChildByPath(container, name);
		return child;
	}
	
	@:final @:noCompletion function getChildByPath(container:DisplayObjectContainer, path:String):DisplayObject {
		var child:DisplayObject = null;
		var names = path.split(".");
		while(!names.empty()) {
			child = container.getChildByName(names.shift());
			if(names.empty()) {
				break;
			}
			if(child == null || !child.is(DisplayObjectContainer)) {
				child = null;
				break;
			}
			container = cast(child, DisplayObjectContainer);
		}
		return child;
	}
	#end
	
	function getContainerByName(name:String):DisplayObjectContainer {
		var child = getChildByName(name);
		return child != null && child.is(DisplayObjectContainer) ? cast(child, DisplayObjectContainer) : null;
	}
	
	function getFieldByName(name:String):TextField {
		var child = getChildByName(name);
		return child != null && child.is(TextField) ? cast(child, TextField) : null;
	}
	
	function render():Bool {
		update();
		return true;
	}
	
	function update() { }
	
	function clear() { }
}