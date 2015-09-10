package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.models.ResChange.ResChangeItem;

/**
 * @author SlavaRa
 */
class ResChangeItemTest {

	public function new() {}
	
	@Test
	public function testPlus() {
		var a = new ResChangeItem();
		a.readExternal({"resId":1, "amount":1});
		var b = new ResChangeItem();
		b.readExternal({"resId":1, "amount":1});
		var c = a + b;
		Assert.areEqual(2, c.amount);
	}
	
	@Test
	public function testMinus() {
		var a = new ResChangeItem();
		a.readExternal({"resId":1, "amount":2});
		var b = new ResChangeItem();
		b.readExternal({"resId":1, "amount":1});
		var c = a - b;
		Assert.areEqual(1, c.amount);
	}
}