package slavara.haxe.core.display;
#if (!flash11 || !starling)
import flash.display.MovieCLip;
#elseif (starling)
import starling.display.MovieCLip;
#end

/**
 * @author SlavaRa
 */
#if (!flash11 || !starling)
typedef MovieCLip = flash.display.MovieCLip;
#elseif (starling)
typedef MovieCLip = starling.display.MovieCLip;
#end
