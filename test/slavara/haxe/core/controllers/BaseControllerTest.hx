package slavara.haxe.core.controllers;
import openfl.display.Sprite;
import massive.munit.Assert;
import slavara.haxe.core.controllers.BaseController;
import slavara.haxe.core.Models.Data;
#if !cpp
import slavara.haxe.core.Utils.DisposeUtil;
#end

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
		Assert.areEqual(_baseController.baseController, _baseController);
	}
	
	#if !cpp
	@Test
	public function destroyBaseControllerTest() {
		DisposeUtil.dispose(_baseController);
		Assert.isNull(_baseController.container);
		Assert.isNull(_baseController.data);
		Assert.isNull(_baseController.baseController);
	}
	#end
	
	@Test
	public function initializeAbstractControllerTest() {
		var controller = new AbstractController(_baseController);
		
		Assert.areEqual(controller.data, _baseController.data);
		Assert.areEqual(controller.baseController, _baseController);
	}
	
	#if !cpp
	@Test
	public function destroyAbstractControllerTest() {
		var controller = new AbstractController(_baseController);
		
		DisposeUtil.dispose(controller);
		Assert.isNull(controller.data);
		Assert.isNull(controller.baseController);
	}
	#end
}