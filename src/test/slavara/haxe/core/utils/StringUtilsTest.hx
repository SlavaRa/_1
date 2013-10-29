package test.slavara.haxe.core.utils;
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
		var s0:String = "";
		var s1:String = null;
		var s2:String = "abc";
		
		Assert.isTrue(s0.isNullOrEmpty());
		Assert.isTrue(s1.isNullOrEmpty());
		Assert.isFalse(s2.isNullOrEmpty());
	}
	
	@Test
	public function trimTest() {
		var s0 = " abc  abc   ";
		var s1 = "abc  abc";
		
		Assert.areEqual(s0.trim(), s1);
	}
}