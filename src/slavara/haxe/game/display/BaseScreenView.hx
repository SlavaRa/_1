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
			render();
		}
		return data;
	}
	
	override function render():Bool {
		if(!super.render()) return false;
		if(data != null) {
			if(container == null && !data.getSWFRef().getIsEmpty()) {
				container = createClipFromSWF(data.getSWFRef());
				return false;
			}
			if(_bkg == null && !data.getBkgRef().getIsEmpty()) {
				_bkg = getBitmap(data.getBkgRef());
				addChild(_bkg);
			}
		}
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
		if(container != null) {
			container.x = (stage.stageWidth - container.width) / 2;
			container.y = (stage.stageHeight - container.height) / 2;
		}
		if(_bkg != null) {
			_bkg.x = (stage.stageWidth - _bkg.width) / 2;
			_bkg.y = (stage.stageHeight - _bkg.height) / 2;
		}
	}
}