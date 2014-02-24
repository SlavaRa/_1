package slavara.haxe.core;
import slavara.haxe.core.Interfaces.IDestroyable;
import slavara.haxe.core.TypeDefs.DisplayObject;
using slavara.haxe.core.Utils.ValidateUtil;
using Reflect;
using Std;
using StringTools;

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

/**
 * @author SlavaRa
 */
extern class DisplayUtils {
	public static inline function setXY(display:DisplayObject, x:Float, y:Float):DisplayObject {
		display.x = x;
		display.y = y;
		return display;
	}
}