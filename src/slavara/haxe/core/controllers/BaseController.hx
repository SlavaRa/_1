package slavara.haxe.core.controllers;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;
import slavara.haxe.core.utils.IDestroyable;

/**
 * @author SlavaRa
 */
class BaseController implements IController {

	public function new(container:DisplayObjectContainer, data:Data) {
		this.container = container;
		this.data = data;
		initialize();
	}
	
	public function initialize():Void {
		initializeView();
		addListeners();
	}
	
	public function destroy():Void {
		removeListeners();
		view = null;
		data = null;
		container = null;
	}
	
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	public var view(default, null):DisplayObject;
	
	
	function initializeView() {
	}
	
	function addListeners() {
	}
	
	function removeListeners() {
	}
}