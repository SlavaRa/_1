package slavara.haxe.game;
import openfl.events.IEventDispatcher;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
interface IPrototypesCollection extends IEventDispatcher {
	function get(id:Int):UnknownProto;
	function getItems():Array<Dynamic>;
}

/**
 * @author SlavaRa
 */
interface IUnknown {
	public var id(default, null):Int;
}