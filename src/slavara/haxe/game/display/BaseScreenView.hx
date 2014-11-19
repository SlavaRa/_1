package slavara.haxe.game.display;
import openfl.text.TextField;
import slavara.haxe.core.display.openfl.ResourceSprite;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
class BaseScreenView extends ResourceSprite {

	public function new() super();
	
	var data(null, set):UnknownProto;
	
	function set_data(value:UnknownProto):UnknownProto {
		if(value != data) {
			data = value;
			update();
		}
		return data;
	}
	
	override function render():Bool {
		if(!super.render()) return false;
		var field = getFieldByName("title");
		if(field == null) {
			//TODO slavara: create title field
		}
		update();
		return true;
	}
	
	override function clear() {
		data = null;
		super.clear();
	}
	
	override function update() {
		super.update();
		if(stage == null || data == null) return;
		var field = getFieldByName("title");
		field.text = data.ident;
	}
}