package slavara.haxe.game;
import openfl.display.DisplayObjectContainer;
import slavara.haxe.core.controllers.BaseController;
import slavara.haxe.game.Enumerators.ServerCommand;
import slavara.haxe.game.models.BaseUniverseData;

/**
 * @author SlavaRa
 */
class BaseSystemController extends BaseController {

	public function new(container:DisplayObjectContainer) super(container, Type.createInstance(getUniverseDataType(), []));

	public var server(default, null):BaseServerController;
	public var stat(default, null):BaseStatController;
	public var screen(default, null):BaseScreenController;
	
	function getUniverseDataType():Class<Dynamic> return BaseUniverseData;
	function getServerType():Class<Dynamic> return BaseServerController;
	function getStatType():Class<Dynamic> return BaseStatController;
	function getScreenType():Class<Dynamic> return BaseScreenController;
	
	public override function initialize() {
		server = Type.createInstance(getServerType(), [this]);
		stat = Type.createInstance(getStatType(), [this]);
		screen = Type.createInstance(getScreenType(), [this]);
	}
	
	public function start() server.send(ServerCommand.START);
}

class BaseServerController extends AbstractController {
	public function new(controller:BaseController) super(controller);
	
	public function send(command:String, ?data:Dynamic, ?onResponseReceived:Dynamic->Void, ?onResponseSavedData:Dynamic) {
	}
}

class BaseStatController extends AbstractController {
	public function new(controller:BaseController) super(controller);
}

class BaseScreenController extends AbstractController {
	public function new(controller:BaseController) super(controller);
}