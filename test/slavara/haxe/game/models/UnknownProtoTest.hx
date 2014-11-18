package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
class UnknownProtoTest {

	public function new() {}
	
	@Test
	public function testDeserialize() {
		var proto:UnknownProto = new UnknownProto();
		proto.readExternal({"desc":"some proto"});
		Assert.areEqual("some proto", proto.desc);
	}
}