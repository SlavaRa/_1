package slavara.haxe.core.utils;
import massive.munit.Assert;
import slavara.haxe.core.utils.Utils.ValidateUtil;

/**
 * @author SlavaRa
 */
class ValidateTest {

	public function new() { }
	
	@Test
	public function isNullTest() {
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isTrue(ValidateUtil.isNull(d0));
		Assert.isFalse(ValidateUtil.isNull(d1));
	}
	
	@Test
	public function isNotNullTest() {
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isFalse(ValidateUtil.isNotNull(d0));
		Assert.isTrue(ValidateUtil.isNotNull(d1));
	}
}