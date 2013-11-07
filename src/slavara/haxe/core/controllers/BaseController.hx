package slavara.haxe.core.controllers;
import flash.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;
import slavara.haxe.core.utils.Destroyable.IDestroyable;
import slavara.haxe.core.utils.Validate;

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
class BaseController implements IController implements IDestroyable {

	public function new(container:DisplayObjectContainer, data:Data) {
		#if debug
		if(Validate.isNull(container)) throw "container is null";
		if(Validate.isNull(data)) throw "the data argument must not be null";
		#end
		this.container = container;
		this.data = data;
	}
	
	public var container(default, null):DisplayObjectContainer;
	public var data(default, null):Data;
	
	public function destroy() {
		container = null;
		data = null;
	}
}