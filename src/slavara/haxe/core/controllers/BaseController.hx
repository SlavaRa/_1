package slavara.haxe.core.controllers;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;

/**
 * @author SlavaRa
 */
interface IController {
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
}

/**
 * @author SlavaRa
 */
class BaseController implements IController {

	public function new(container:DisplayObjectContainer, data:Data) {
		this.container = container;
		this.data = data;
	}
	
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	
	public function dispose():Null<IController> {
		container = null;
		data = null;
		return null;
	}
	
}