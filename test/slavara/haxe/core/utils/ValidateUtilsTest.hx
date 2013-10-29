package slavara.haxe.core.utils;
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
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isTrue(ValidateUtils.isNull(d0));
		Assert.isFalse(ValidateUtils.isNull(d1));
	}
	
	@Test
	public function isNotNullTest() {
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isFalse(ValidateUtils.isNotNull(d0));
		Assert.isTrue(ValidateUtils.isNotNull(d1));
	}
}