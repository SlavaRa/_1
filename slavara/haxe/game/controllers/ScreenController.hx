package slavara.haxe.game.controllers;
import slavara.haxe.core.controllers.BaseController.AbstractController;
import slavara.haxe.core.Interfaces.IStateMachineHolder;
import slavara.haxe.game.display.ScreenViewContainer;

/**
 * @author SlavaRa
 */
class ScreenController extends AbstractController {

	public function new(controller:BaseSystemController) super(controller);
	
	public override function initialize() {
		super.initialize();
		var system:BaseSystemController = cast(baseController, BaseSystemController);
		var view = new ScreenViewContainer(system.createScreenFactory());
		system.container.addChild(view);
		view.data = cast(data, IStateMachineHolder);
	}
}