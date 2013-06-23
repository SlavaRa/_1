package slavara.haxe.core.utils;

/**
 * @author SlavaRa
 */
interface IDestroyable {
	var isDestroyed(default, null):Bool;
	function destroy():Void;
}