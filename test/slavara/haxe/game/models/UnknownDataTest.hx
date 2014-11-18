package slavara.haxe.game.models;
import massive.munit.Assert;
import openfl.errors.Error;
import slavara.haxe.game.Models.UnknownData;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
class UnknownDataTest {

	public function new() { }
	
	@Test
	public function testCreateWithoutProto() {
		try {
			new UnknownData(null);
		} catch (error:Error) {
			Assert.areEqual("the proto argument must not be null", error.message);
		}
	}
	
	@Test
	public function testCreateWithProto() {
		var data:UnknownData = new UnknownData(new UnknownProto());
		Assert.isNotNull(data.proto);
		Assert.isNotNull(data.stateMachine);
	}
}