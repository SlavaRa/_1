package slavara.haxe.game;
import massive.munit.Assert;
import slavara.haxe.game.Resource.ResRef;

/**
 * @author SlavaRa
 */
class ResRefTest {

	public function new() { }
	
	@Test
	public function testDeserialize() {
		var res:ResRef = new ResRef();
		res.readExternal({"link":"test"});
		Assert.areEqual("test", res.link);
	}
	
	@Test
	public function testGetIsEmpty() {
		var res:ResRef = new ResRef();
		Assert.isTrue(res.getIsEmpty());
		res.readExternal({"link":"test"});
		Assert.isFalse(res.getIsEmpty());
	}
}