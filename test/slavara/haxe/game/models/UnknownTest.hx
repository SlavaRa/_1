package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.Models.Unknown;

/**
 * @author SlavaRa
 */
class UnknownTest {

	public function new() { }
	
	@Test
	public function testDeserialize() {
		var unknown:Unknown = new Unknown();
		unknown.readExternal({"id":0});
		Assert.areEqual(0, unknown.id);
	}
}