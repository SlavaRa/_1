package slavara.haxe.core.display;
#if (!flash11 || !starling)
import flash.display.DisplayObjectContainer;
#elseif (starling)
import starling.display.DisplayObjectContainer;
#end

/**
 * @author SlavaRa
 */
#if (!flash11 || !starling)
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
#elseif (starling)
typedef DisplayObjectContainer = starling.display.DisplayObjectContainer;
#end
