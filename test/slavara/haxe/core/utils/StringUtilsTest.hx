package slavara.haxe.core.utils;
import massive.munit.Assert;

using slavara.haxe.core.utils.StringUtils;

/**
 * @author SlavaRa
 */
class StringUtilsTest {

	public function new() {
	}
	
	@Test
	public function stringIsNullOrEmptyTest() {
		var s0 = "";
		var s1:String = null;
		var s2 = "abc";
		
		Assert.isTrue(s0.isNullOrEmpty());
		Assert.isTrue(s1.isNullOrEmpty());
		Assert.isFalse(s2.isNullOrEmpty());
	}
}