package slavara.haxe.core;

/**
 * @author SlavaRa
 */
interface IExternalizableObject {
	function readExternal(input:Dynamic):Void;
	function writeExternal(output:Dynamic):Void;
}