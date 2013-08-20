package slavara;

import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import slavara.haxe.tests.ModelTest;

/**
 * @author SlavaRa
 */
class Main extends Sprite {

	public static function main() {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	function onAddedToStage(_) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onResize);
		#if ios
		haxe.Timer.delay(initialize, 100); // iOS 6
		#else
		initialize();
		#end
		
	}
	
	function onResize(_) {
		
	}
	
	function initialize() {
		new ModelTest();
	}

}
