package slavara.haxe.core.controllers;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;

/**
 * @author SlavaRa
 */
class BaseController implements IController {

	public function new(container:DisplayObjectContainer, data:Data) {
		isInitialized = false;
		this.container = container;
		this.data = data;
		initialize();
	}
	
	public function initialize():Void {
		initializeView();
		addListeners();
		isInitialized = true;
	}
	
	public function destroy():Void {
		removeListeners();
		destroyView();
		view = null;
		data = null;
		container = null;
		isInitialized = false;
		isDestroyed = true;
	}
	
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	public var view(default, null):DisplayObject;
	public var isInitialized(default, null):Bool;
	public var isDestroyed(default, null):Bool;
	
	function initializeView() {
	}
	
	function destroyView() {
	}
	
	function addListeners() {
	}
	
	function removeListeners() {
	}
}