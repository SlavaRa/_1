package slavara.haxe.game.controllers;
import openfl.display.DisplayObjectContainer;
import slavara.haxe.core.controllers.BaseController;
import slavara.haxe.game.controllers.ServerController;
import slavara.haxe.game.controllers.SoundController;
import slavara.haxe.game.controllers.StatController;
import slavara.haxe.game.controllers.UserController;
import slavara.haxe.game.Enums.ServerCommand;
import slavara.haxe.game.Events.ServerControllerEvent;
import slavara.haxe.game.Factories.ScreenFactory;
import slavara.haxe.game.models.UniverseData;

/**
 * @author SlavaRa
 */
class BaseSystemController extends BaseController {
	
	function new(container:DisplayObjectContainer) super(container, new UniverseData());
	
	public var server(default, null):ServerController;
	public var sound(default, null):SoundController;
	public var stat(default, null):StatController;
	public var user(default, null):UserController;
	public var screen(default, null):ScreenController;
	
	public override function initialize() {
		super.initialize();
		initializeControllers();
		initializeListeners();
	}
	
	public function createScreenFactory():ScreenFactory return new ScreenFactory();
	
	public function reset() server.send(ServerCommand.Reset);
	
	public function start() server.send(ServerCommand.Start);
	
	function initializeControllers() {
		server = new ServerController(this);
		sound = new SoundController(this);
		stat = new StatController(this);
		user = new UserController(this);
		screen = new ScreenController(this);
	}
	
	function initializeListeners() server.addEventListener(ServerControllerEvent.MESSAGE_RECEIVED, onServerMessageReceived);
	
	function onServerMessageReceived(event:ServerControllerEvent) cast(data, UniverseData).readExternal(event.message);
}