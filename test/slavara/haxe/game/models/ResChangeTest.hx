package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.models.ResChange;

/**
 * @author SlavaRa
 */
class ResChangeTest {

	public function new() {}
	
	@Test
	public function testDeserialize() {
		var change:ResChange = new ResChange();
		change.readExternal([{"resId":1, "amount":10}]);
		var items:Array<ResChangeItem> = change.toList();
		Assert.areEqual(1, items.length);
		Assert.areEqual(1, items[0].resId);
		Assert.areEqual(10, items[0].amount);
	}
}