package slavara.haxe.core.display;
#if (!flash11 || !starling)
import flash.display.DisplayObject;
#elseif (starling)
import starling.display.DisplayObject;
#end

/**
 * @author SlavaRa
 */
#if (!flash11 || !starling)
typedef DisplayObject = flash.display.DisplayObject;
#elseif (starling)
typedef DisplayObject = starling.display.DisplayObject;
#end
