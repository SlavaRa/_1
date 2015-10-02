package slavara.haxe.game;
import flash.events.Event;

/**
 * @author SlavaRa
 */
class ServerControllerEvent extends ControllerEvent {
	
	public static inline var MESSAGE_RECEIVED = "messageReceived";
	
	public function new(type:String, message:Dynamic) {
		super(type);
		this.message = message;
	}
	
	public var message(default, null):Dynamic;
	
	public override function clone():Event return new ServerControllerEvent(type, message);
}

/**
 * @author SlavaRa
 */
class ControllerEvent extends Event {
	
	public function new(type:String) super(type);
	
	public override function clone():Event return new ControllerEvent(type);
}