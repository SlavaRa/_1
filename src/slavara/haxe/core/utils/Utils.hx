package slavara.haxe.core.utils;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using Reflect;
using Std;
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
		if(d.isNotNull()) {
			if(d.is(IDestroyable)) {
				cast(d, IDestroyable).destroy();
			} else if(d.hasField("iterator")) {
				var iterator:Iterator<Dynamic> = d.getProperty("iterator");
				for(it in iterator) {
					if(d.hasField("remove")) {
						d.callMethod("remove", [it]);
					}
					destroy(it);
				}
			}
		}
		return null;
	}
}

/**
 * @author SlavaRa
 */
extern class StringUtil {
	public static inline function isNullOrEmpty(s:String):Bool return s.isNull() || s.trim().length == 0;
}

/**
 * @author SlavaRa
 */
extern class ValidateUtil {
	public static inline function isNull(d:Dynamic):Bool return d == null;
	
	public static inline function isNotNull(d:Dynamic):Bool return d != null;
}