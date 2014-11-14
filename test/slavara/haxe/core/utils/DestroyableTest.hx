package slavara.haxe.core.utils;
import massive.munit.Assert;
import slavara.haxe.core.display.openfl.BaseSprite;
import slavara.haxe.core.Utils.DisposeUtil;

/**
 * @author SlavaRa
 */
class DestroyableTest {

	public function new() { }
	
	@Test
	public function destroyTest() {
		var array:Array<BaseSprite> = [];
		array.push(new BaseSprite());
		array.push(new BaseSprite());
		
		//DestroyUtil.destroy(array);
		//Assert.areEqual(array.length, 0);
	}
}