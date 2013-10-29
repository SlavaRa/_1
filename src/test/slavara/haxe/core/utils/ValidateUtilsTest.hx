package slavara.haxe.core.utils;
import flash.display.Sprite;
import massive.munit.Assert;
import slavara.haxe.core.utils.ValidateUtils;

/**
 * @author SlavaRa
 */
class ValidateUtilsTest {

	public function new() {
	}
	
	@Test
	public function isNullTest() {
		var s0:Sprite = null;
		var s1:Sprite = new Sprite();
		
		Assert.isTrue(ValidateUtils.isNull(s0));
		Assert.isFalse(ValidateUtils.isNull(s1));
	}
	
	@Test
	public function isNotNullTest() {
		var s0:Sprite = null;
		var s1:Sprite = new Sprite();
		
		Assert.isFalse(ValidateUtils.isNotNull(s0));
		Assert.isTrue(ValidateUtils.isNotNull(s1));
	}
}