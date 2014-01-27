package slavara.haxe.core.controllers;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.controllers.BaseController.IBaseController;
import slavara.haxe.core.controllers.BaseController.IController;
import slavara.haxe.core.models.Data;
import slavara.haxe.core.utils.Utils.IDestroyable;
import slavara.haxe.core.utils.Utils.ValidateUtil;

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
		if(ValidateUtil.isNull(container)) throw "container is null";
		if(ValidateUtil.isNull(data)) throw "the data argument must not be null";
		#end
		this.container = container;
		this.data = data;
		baseController = this;
		initialize();
	}
	
	public var baseController(default, null):IController;
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	
	/**virtual*/ public function initialize() { }
	public function destroy() {
		container = null;
		data = null;
		baseController = null;
	}
}

/**
 * @author SlavaRa
 */
class AbstractController implements IController implements IDestroyable {
	
	public function new(controller:IController) {
		#if debug
		if(ValidateUtil.isNull(controller)) throw "the controller argument must not be null";
		#end
		baseController = controller;
		data = controller.data;
		initialize();
	}
	
	public var baseController(default, null):IController;
	public var data(default, null):Data;
	
	/**virtual*/ public function initialize() {}
	public function destroy() {
		baseController = null;
		data = null;
	}
	
}