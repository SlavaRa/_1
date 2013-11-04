package slavara;
import flash.display.BitmapData;
import flash.Lib;
import haxe.Log;
import openfl.Assets;
import slavara.haxe.core.display.DisplayObject.BaseSprite;

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