package slavara.haxe.core;
import openfl.display.DisplayObject;
import slavara.haxe.core.Interfaces.IDisposable;
using Reflect;
using Std;
using StringTools;

/**
 * @author SlavaRa
 */
extern class DisposeUtil {
	public static inline function dispose(d:Dynamic, safe:Bool = true):Dynamic {
		if(d != null) {
			if(d.is(IDisposable)) cast(d, IDisposable).dispose();
			else if(d.hasField("iterator")) {
				var iterator:Iterator<Dynamic> = d.getProperty("iterator");
				for(it in iterator) {
					if(d.hasField("remove")) d.callMethod(d.field("remove"), [it]);
					dispose(it);
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
	public static inline function isNullOrEmpty(s:String):Bool return s == null || s.trim().length == 0;
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