package slavara.haxe.core.utils;
using StringTools;

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
extern class DestroyUtil {
	
	public static inline function destroy(d:Dynamic, safe:Bool = true):Dynamic {
		if(ValidateUtil.isNotNull(d)) {
			if(Std.is(d, IDestroyable)) {
				cast(d, IDestroyable).destroy();
			}
		}
		return null;
	}
}

/**
 * @author SlavaRa
 */
extern class StringUtil {
	
	public static inline function isNullOrEmpty(s:String):Bool {
		return s == null || s.trim().length == 0;
	}
}

/**
 * @author SlavaRa
 */
extern class ValidateUtil {
	public static inline function isNull(d:Dynamic):Bool return d == null;
	
	public static inline function isNotNull(d:Dynamic):Bool return d != null;
}