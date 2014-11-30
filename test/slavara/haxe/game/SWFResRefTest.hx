package slavara.haxe.game;
import massive.munit.Assert;
import slavara.haxe.game.Resource.SWFResRef;

/**
 * @author SlavaRa
 */
class SWFResRefTest {

	public function new() { }
	
	@Test
	public function testDeserialize() {
		var res:SWFResRef = new SWFResRef();
		res.readExternal({"swf":"test_swf", "link":"test_link"});
		Assert.areEqual("test_swf", res.swf);
		Assert.areEqual("test_link", res.link);
	}
	
	@Test
	public function testGetIsEmpty() {
		var res:SWFResRef = new SWFResRef();
		Assert.isTrue(res.getIsEmpty());
		res.readExternal({"swf":"test_swf", "link":"test_link"});
		Assert.isFalse(res.getIsEmpty());
	}
}