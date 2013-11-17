package slavara.haxe.core.utils;

/**
 * @author SlavaRa
 */
interface IDestroyable {
	function initialize():Void;
	function destroy():Void;
}

/**
 * @author SlavaRa
 */
extern class DestroyUtils {
	
	public static inline function destroy(d:Dynamic, safe:Bool = true):Dynamic {
		if(Validate.isNotNull(d)) {
			if(Std.is(d, IDestroyable)) {
				cast(d, IDestroyable).destroy();
			}
		}
		return null;
	}
}