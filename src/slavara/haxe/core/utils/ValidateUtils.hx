package slavara.haxe.core.utils;

/**
 * @author SlavaRa
 * TODO: утилита предназначена в первую очередь для написания кода, который легко портировать.
 */
class ValidateUtils {
	
	public static inline function isNull(d:Dynamic):Bool {
		return d == null;
	}
	
	public static inline function isNotNull(d:Dynamic):Bool {
		return d != null;
	}
	
}