package slavara.haxe.game.display;
import openfl.display.Bitmap;
import slavara.haxe.core.display.openfl.ResourceSprite;
import slavara.haxe.core.Utils.DisposeUtil;
import slavara.haxe.game.models.ScreenData;

/**
 * @author SlavaRa
 */
class BaseScreenView extends ResourceSprite {

	public function new(data:ScreenData) {
		super();
		this.data = data;
	}
	
	var _bkg:Bitmap;
	public var data(null, set):ScreenData;
	
	function set_data(value:ScreenData):ScreenData {
		if(value != data) {
			data = value;
			update();
		}
		return data;
	}
	
	override function render():Bool {
		if(!super.render()) return false;
		update();
		return true;
	}
	
	override function clear() {
		_bkg = DisposeUtil.dispose(_bkg);
		super.clear();
	}
	
	override function update() {
		super.update();
		if(stage == null || data == null) return;
		if(_bkg == null) {
			var resRef = data.getBkgRef();
			if(!resRef.getIsEmpty()) _bkg = getBitmap(resRef);
		}
		if(_bkg != null) {
			_bkg.x = (stage.stageWidth - _bkg.width) / 2;
			_bkg.y = (stage.stageHeight - _bkg.height) / 2;
			addChild(_bkg);
		}
	}
}