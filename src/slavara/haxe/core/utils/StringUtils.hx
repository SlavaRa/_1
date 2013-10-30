package slavara.haxe.core.utils;
import haxe.Log;

/**
 * @author SlavaRa
 */
class StringUtils {
	
	public static inline function isNullOrEmpty(s:String):Bool {
		return s == null || trim(s).length == 0;
	}
	
	static var trim_beginEReg:EReg = ~/^(?:[\s]+)/gm;
	static var trim_endEReg:EReg = ~/(?:[\s]+)$/gm;
	
	public static function trim(s:String):String {
		s = trim_beginEReg.replace(s, "");
		return trim_endEReg.replace(s, "");
	}
}