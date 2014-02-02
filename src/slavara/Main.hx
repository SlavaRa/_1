package slavara;
import flash.Lib;
import slavara.haxe.core.TypeDefs.BaseSprite;

/**
 * @author SlavaRa
 */
class Main extends BaseSprite {

	public static function main() {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	public function new() super();
}