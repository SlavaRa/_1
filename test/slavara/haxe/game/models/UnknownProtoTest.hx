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
		proto.readExternal({"ident":"t_ident", "desc":"t_desc"});
		Assert.areEqual("t_ident", proto.ident);
		Assert.areEqual("t_desc", proto.desc);
	}
}