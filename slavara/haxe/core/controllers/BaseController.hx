package slavara.haxe.core.controllers;
import openfl.display.DisplayObjectContainer;
import openfl.events.EventDispatcher;
import slavara.haxe.core.controllers.BaseController.IBaseController;
import slavara.haxe.core.controllers.BaseController.IController;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Interfaces.IDisposable;
import slavara.haxe.core.Models.Data;

/**
 * @author SlavaRa
 */
interface IController {
	public var baseController(default,  null):IController;
	public var data(default, null):Data;
}

/**
 * @author SlavaRa
 */
interface IBaseController extends IController {
	public var container(default, null):DisplayObjectContainer;
}

/**
 * @author SlavaRa
 */
class BaseController implements IBaseController implements IDisposable {

	public function new(container:DisplayObjectContainer, data:Data) {
		#if debug
		if(container == null) throw new ArgumentNullError("container");
		if(data == null) throw new ArgumentNullError("data");
		#end
		this.container = container;
		this.data = data;
		baseController = this;
		initialize();
	}
	
	public var baseController(default, null):IController;
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	
	public function initialize() { }
	
	public function dispose() {
		container = null;
		data = null;
		baseController = null;
	}
}

/**
 * @author SlavaRa
 */
@:generic class AbstractController extends EventDispatcher implements IController implements IDisposable {
	
	public function new(controller:IController) {
		super();
		#if debug
		if(controller == null) throw new ArgumentNullError("controller");
		#end
		baseController = controller;
		data = controller.data;
		initialize();
	}
	
	public var baseController(default, null):IController;
	public var data(default, null):Data;
	
	public function initialize() { }
	
	public function dispose() {
		baseController = null;
		data = null;
	}
}