package slavara.haxe.game.controllers;
import massive.munit.Assert;
import openfl.display.Sprite;
import slavara.haxe.game.Controllers.BaseSystemController;
import slavara.haxe.game.models.BaseUniverseData;

/**
 * @author SlavaRa
 */
class BaseSystemControllerTest {

	public function new() {}
	
	@Test
	public function testCreate() {
		var controller:BaseSystemController = new BaseSystemController(new Sprite());
		Assert.isTrue(Std.is(controller.data, BaseUniverseData));
		Assert.isNotNull(controller.server);
		Assert.isNotNull(controller.stat);
		Assert.isNotNull(controller.screen);
	}
}