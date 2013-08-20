package slavara.haxe.core.controllers;
import slavara.haxe.core.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;

/**
 * @author SlavaRa
 */
class BaseController {

	public function new(container:DisplayObjectContainer, data:Data) {
		this.container = container;
		this.data = data;
	}
	
	public function destroy():Void {
		container = null;
		data = null;
	}
	
}