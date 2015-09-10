package slavara.haxe.game;
import slavara.haxe.core.Interfaces.IExternalizableObject;
import slavara.haxe.game.Models.UnknownProto;

interface IPrototypesCollection extends IExternalizableObject {
	var inputKey(default, null):String;
	function get(id:Int):UnknownProto;
}

interface IUnknown {
	public var id(default, null):Int;
	public var desc(default, null):String;
}