package slavara.haxe.core.controllers;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.controllers.BaseController.IBaseController;
import slavara.haxe.core.controllers.BaseController.IController;
import slavara.haxe.core.models.Data;
import slavara.haxe.core.utils.Destroyable.IDestroyable;
import slavara.haxe.core.utils.Validate;

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
		if(Validate.isNull(container)) throw "container is null";
		if(Validate.isNull(data)) throw "the data argument must not be null";
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
	}
}

/**
 * @author SlavaRa
 */
class AbstractController implements IController {
	
	public function new(controller:IController) {
		#if debug
		if(controller == null) throw "the controller argument must not be null";
		#end
		baseController = controller;
		data = controller.data;
	}
	
	public var baseController(default, null):IController;
	public var data(default, null):Data;
}