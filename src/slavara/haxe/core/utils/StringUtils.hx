package slavara.haxe.core.utils;
using StringTools;

/**
 * @author SlavaRa
 */
class StringUtils {
	
	public static inline function isNullOrEmpty(s:String):Bool {
		return s == null || s.trim().length == 0;
	}
}