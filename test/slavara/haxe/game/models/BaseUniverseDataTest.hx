package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.models.BaseUniverseData;

/**
 * @author SlavaRa
 */
class BaseUniverseDataTest {

	public function new() { }
	
	@Test
	public function testDeserialize_screens() {
		var data:BaseUniverseData = new BaseUniverseData();
		data.readExternal({
			"prototypes":{
				"screens":[
					{
						"id":0,
						"ident":"Main",
						"to":["menu"]
					},
					{
						"id":1,
						"ident":"Menu",
						"to":["new game", "settings"]
					}
				]
			}
		});
		Assert.areEqual(2, data.numChildren);
	}
}