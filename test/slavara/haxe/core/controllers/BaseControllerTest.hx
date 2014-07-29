package slavara.haxe.core.controllers;
import openfl.display.Sprite;
import massive.munit.Assert;
import slavara.haxe.core.controllers.BaseController;
import slavara.haxe.core.Models.Data;
import slavara.haxe.core.Utils.DestroyUtil;

/**
 * @author SlavaRa
 */
class BaseControllerTest {

	public function new() { }
	
	var _data:Data;
	var _baseController:BaseController;
	
	@Before
	public function initialize() {
		_data = Type.createEmptyInstance(Data);
		_baseController = new BaseController(new Sprite(), _data);
	}
	
	@Test
	public function initializeBaseControllerTest() {
		Assert.isNotNull(_baseController.container);
		Assert.isNotNull(_baseController.data);
		Assert.isTrue(_baseController.baseController == _baseController);
	}
	
	@Test
	public function destroyBaseControllerTest() {
		DestroyUtil.destroy(_baseController);
		Assert.isNull(_baseController.container);
		Assert.isNull(_baseController.data);
		Assert.isNull(_baseController.baseController);
	}
	
	@Test
	public function initializeAbstractControllerTest() {
		var controller = new AbstractController(_baseController);
		
		Assert.isTrue(controller.data == _baseController.data);
		Assert.isTrue(controller.baseController == _baseController);
	}
	
	@Test
	public function destroyAbstractControllerTest() {
		var controller = new AbstractController(_baseController);
		
		DestroyUtil.destroy(controller);
		Assert.isNull(controller.data);
		Assert.isNull(controller.baseController);
	}
}