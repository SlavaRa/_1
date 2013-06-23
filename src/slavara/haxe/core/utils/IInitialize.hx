package slavara.haxe.core.utils;

/**
 * @author SlavaRa
 */
interface IInitialize extends IDestroyable {
	var isInitialized(default, null):Bool;
	function initialize():Void;
}