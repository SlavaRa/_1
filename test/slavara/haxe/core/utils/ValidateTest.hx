package slavara.haxe.core.utils;
import massive.munit.Assert;
import slavara.haxe.core.utils.Validate;

/**
 * @author SlavaRa
 */
class ValidateTest {

	public function new() { }
	
	@Test
	public function isNullTest() {
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isTrue(Validate.isNull(d0));
		Assert.isFalse(Validate.isNull(d1));
	}
	
	@Test
	public function isNotNullTest() {
		var d0:Dynamic = null;
		var d1:Dynamic = { };
		
		Assert.isFalse(Validate.isNotNull(d0));
		Assert.isTrue(Validate.isNotNull(d1));
	}
}