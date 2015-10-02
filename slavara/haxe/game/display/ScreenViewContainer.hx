package slavara.haxe.game.display;
import openfl.display.DisplayObject;
import slavara.haxe.core.display.openfl.ResourceSprite;
import slavara.haxe.core.Interfaces.IStateMachineHolder;
import slavara.haxe.core.Utils.DisposeUtil;
import slavara.haxe.game.Factories.ScreenFactory;

/**
 * @author SlavaRa
 */
class ScreenViewContainer extends ResourceSprite {

	public function new(factory:ScreenFactory) {
		super();
		_factory = factory;
	}
	
	public var data(null, set):IStateMachineHolder;
	
	inline function set_data(value:IStateMachineHolder) {
		if(value != data) {
			if(data != null) data.stateMachine.onChange.remove(updateState);
			data = value;
			if(data != null) {
				_states = _factory.getScreens();
				data.stateMachine.onChange.add(updateState);
				updateState();
			}
		}
		return data;
	}
	
	var _factory:ScreenFactory;
	var _states:Map<EnumValue, DisplayObject>;
	
	public override function dispose() {
		_factory = null;
		_states = DisposeUtil.dispose(_states);
		data = null;
		super.dispose();
	}
	
	inline function updateState() {
		var smachine = data.stateMachine;
		if(smachine.previousState != null) removeChild(_states.get(smachine.previousState));
		if(smachine.currentState != null) addChild(_states.get(smachine.currentState));
	}
}