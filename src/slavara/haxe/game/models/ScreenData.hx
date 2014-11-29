package slavara.haxe.game.models;
import slavara.haxe.core.StateMachine.State;
import slavara.haxe.game.models.prototypes.ScreenProto;
import slavara.haxe.game.Models.UnknownData;
import slavara.haxe.game.Resource.ResRef;

/**
 * @author SlavaRa
 */
class ScreenData extends UnknownData {

	public function new(proto:ScreenProto) super(proto);
	
	public function getFrom():State return State.Some(proto.ident);
	
	public function getTo():Array<State> {
		var proto:ScreenProto = cast(proto, ScreenProto);
		var result = new Array<State>();
		for(it in proto.to) result.push(State.Some(it));
		return result;
	}
	
	public function getBkgRef():ResRef return cast(proto, ScreenProto).bkg;
}