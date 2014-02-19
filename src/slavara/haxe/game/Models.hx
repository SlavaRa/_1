package slavara.haxe.game;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.Models.DataValueObjectContainer;
import slavara.haxe.core.StateMachine;
import slavara.haxe.game.Interfaces.IUnknown;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Reflect;
using Std;

class UnknownProto extends DataValueObjectContainer implements IUnknown {

	public function new() {
		super();
		initialize();
	}
	
	public var id(get, null):Int;
	public var desc(get, null):String;
	
	@:noCompletion var _id:Int;
	@:noCompletion var _desc:String;
	
	@:noCompletion inline function get_id():Int return _id;
	@:noCompletion inline function get_desc():String return _desc;
	
	function initialize() { }
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		
		if(input.hasField("id")) {
			_id = input.getProperty("id");
		}
		if(input.hasField("desc")) {
			_desc = input.getProperty("desc");
		}
	}
}

/**
 * @author SlavaRa
 */
class UnknownData extends DataValueObjectContainer implements IUnknown {

	function new(proto:UnknownProto) {
		#if debug
		if(proto.isNull()) throw new ArgumentNullError("proto");
		#end
		super();
		_proto = proto;
		initialize();
	}
	
	public var stateMachine(default, null):StateMachine;
	public var id(get, null):Int;
	public var desc(get, null):String;
	
	var _id:Int;
	var _desc:String;
	var _proto:UnknownProto;
	
	@:noCompletion inline function get_id():Int return _id;
	@:noCompletion inline function get_desc():String return _desc;
	
	function initialize() {
		stateMachine = new StateMachine();
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		
		if(input.hasField("id")) {
			_id = input.getProperty("id");
		}
		if(input.hasField("desc")) {
			_desc = input.getProperty("desc");
		}
	}
}