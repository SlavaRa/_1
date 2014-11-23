package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.Interfaces.IPrototypesCollection;
import slavara.haxe.game.models.BaseUniverseData;

/**
 * @author SlavaRa
 */
class BaseUniverseDataTest {

	public function new() { }
	
	@Test
	public function testDeserialize_screens() {
		var data:BaseUniverseData = new BaseUniverseData();
		data.readExternal({"prototypes":{"screens":[{"id":0},{"id":1}]}});
		var screens:Dynamic = Reflect.getProperty(data.proto, "screens");
		Assert.isNotNull(cast(screens, IPrototypesCollection).get(0));
		Assert.isNotNull(cast(screens, IPrototypesCollection).get(1));
	}
}