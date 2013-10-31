package slavara;
import flash.events.Event;
import flash.Lib;
import slavara.haxe.core.display.BaseSprite;

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
	
	override function onAddedToStage() {
		#if ios
		haxe.Timer.delay(initialize, 100); // iOS 6
		#else
		initialize();
		#end
	}
	
	function initialize() {
	}
}