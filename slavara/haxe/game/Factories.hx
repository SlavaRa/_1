package slavara.haxe.game;
import openfl.display.DisplayObject;
import slavara.haxe.core.Errors.NotImplementedError;

/**
 * @author SlavaRa
 */
class ScreenFactory {
	public function new() {}
	
	public function getScreens():Map<EnumValue, DisplayObject> {
		throw new NotImplementedError();
		return null;
	}
}