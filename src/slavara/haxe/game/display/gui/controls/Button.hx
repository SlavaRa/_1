package slavara.haxe.game.display.gui.controls;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import slavara.haxe.core.display.openfl.ResourceSprite;
using Std;

/**
 * @author SlavaRa
 */
class Button extends ResourceSprite {

	public function new(container:DisplayObjectContainer = null) {
		super();
		enabled = true;
		super.container = container;
	}
	
	public var enabled(default, set):Bool;
	function set_enabled(v:Bool):Bool {
		if(v != enabled) {
			enabled = v;
			update();
		}
		return enabled;
	}
	
	public var title(default, set):String;
	function set_title(v:String):String {
		if(v != title) {
			title = v;
			updateTitle();
		}
		return title;
	}
	
	var state(default, set):String;
	function set_state(v:String):String {
		if(v != state) {
			if(container != null && container.is(MovieClip)) cast(container, MovieClip).gotoAndStop(v);
			state = v;
		}
		return state;
	}
	
	var _mouseDown:Bool;
	var _mouseOver:Bool;
	
	override function render():Bool {
		if(!super.render()) return false;
		if(container != null && container.is(MovieClip)) cast(container, MovieClip).stop();
		var field = getFieldByName("text");
		if(field != null) field.mouseEnabled = false;
		addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.CLICK, onClick, false);
		update();
		return true;
	}
	
	override function clear() {
		removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
		removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.CLICK, onClick);
		if(stage != null) stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		super.clear();
	}
	
	override function update() {
		super.update();
		mouseEnabled = enabled;
		buttonMode = enabled;
		state = enabled ? "up" : "disabled";
	}
	
	function updateTitle() {
		var field = getFieldByName("text");
		if(field != null) field.text = title != null ? title : "";
	}
	
	function onRollOver(_) {
		if(!enabled) return;
		_mouseOver = true;
		state = _mouseDown ? "down" : "over";
	}
	
	function onRollOut(_) {
		if(!enabled) return;
		_mouseOver = false;
		state = "up";
	}
	
	function onMouseDown(_) {
		if(!enabled) return;
		_mouseDown = true;
		var stage = container != null ? container.stage : stage;
		stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		state = "down";
	}
	
	function onStageMouseUp(_) {
		if(!enabled) return;
		var stage = container != null ? container.stage : stage;
		stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, true);
		_mouseDown = false;
	}
	
	function onClick(event:MouseEvent) {
		if(!enabled) event.stopImmediatePropagation();
	}
}