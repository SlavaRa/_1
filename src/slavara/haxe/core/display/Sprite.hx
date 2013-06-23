package slavara.haxe.core.display;
#if (!flash11 || !starling)
import flash.display.Sprite;
#elseif (starling)
import starling.display.Sprite;
#end

/**
 * @author SlavaRa
 */
#if (!flash11 || !starling)
typedef Sprite = flash.display.Sprite;
#elseif (starling)
typedef Sprite = starling.display.Sprite;
#end
