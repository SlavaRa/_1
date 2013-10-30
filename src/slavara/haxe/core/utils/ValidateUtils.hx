package slavara.haxe.core.utils;

/**
 * @author SlavaRa
 */
class ValidateUtils {
	
	public static inline function isNull(d:Dynamic):Bool {
		return d == null;
	}
	
	public static inline function isNotNull(d:Dynamic):Bool {
		return d != null;
	}
	
}