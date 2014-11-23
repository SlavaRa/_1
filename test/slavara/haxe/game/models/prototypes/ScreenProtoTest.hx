package slavara.haxe.game.models.prototypes;
import massive.munit.Assert;
import slavara.haxe.game.models.prototypes.ScreenProto;

/**
 * @author SlavaRa
 */
class ScreenProtoTest {

	public function new() {}
	
	@Test
	public function testDeserialize() {
		var proto:ScreenProto = new ScreenProto();
		proto.readExternal({"to":["to_0", "to_1"], "via":["via_0", "via_1"]});
		Assert.areEqual("to_0", proto.to[0]);
		Assert.areEqual("to_1", proto.to[1]);
		Assert.areEqual("via_0", proto.via[0]);
		Assert.areEqual("via_1", proto.via[1]);
	}
}