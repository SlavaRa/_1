package slavara.haxe.game.controllers;
import slavara.haxe.core.controllers.BaseController.AbstractController;
import slavara.haxe.core.Errors.NotImplementedError;
import slavara.haxe.game.Enums.ServerCommand;

/**
 * @author SlavaRa
 */
class ServerController extends AbstractController {

	public function new(controller:BaseSystemController) super(controller);
	
	public function send(command:ServerCommand, ?data:Dynamic, ?onResponseReceived:Dynamic->Void, ?onResponseSavedData:Dynamic) {
		throw new NotImplementedError();
	}
}