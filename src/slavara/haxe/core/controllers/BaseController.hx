package slavara.haxe.core.controllers;
import flash.display.DisplayObjectContainer;
import flash.events.EventDispatcher;
import slavara.haxe.core.controllers.BaseController.IBaseController;
import slavara.haxe.core.controllers.BaseController.IController;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Interfaces.IDestroyable;
import slavara.haxe.core.Models.Data;
using slavara.haxe.core.Utils.ValidateUtil;

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
class BaseController implements IBaseController implements IDestroyable {

	public function new(container:DisplayObjectContainer, data:Data) {
		#if debug
		if(container.isNull()) throw new ArgumentNullError("container");
		if(data.isNull()) throw new ArgumentNullError("data");
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
	
	public function destroy() {
		container = null;
		data = null;
		baseController = null;
	}
}

/**
 * @author SlavaRa
 */
class AbstractController extends EventDispatcher implements IController implements IDestroyable {
	
	public function new(controller:IController) {
		super();
		#if debug
		if(controller.isNull()) throw new ArgumentNullError("controller");
		#end
		baseController = controller;
		data = controller.data;
		initialize();
	}
	
	public var baseController(default, null):IController;
	public var data(default, null):Data;
	
	public function initialize() { }
	
	public function destroy() {
		baseController = null;
		data = null;
	}
}