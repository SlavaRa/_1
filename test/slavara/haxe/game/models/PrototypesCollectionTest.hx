package slavara.haxe.game.models;
import massive.munit.Assert;
import slavara.haxe.game.Models.PrototypesCollection;
import slavara.haxe.game.Models.UnknownProto;

/**
 * @author SlavaRa
 */
class PrototypesCollectionTest {

	public function new() {}
	
	@Test
	public function testCreateChildren() {
		var collection:PrototypesCollection<UnknownProto> = new PrototypesCollection<UnknownProto>("tests");
		collection.readExternal({"tests":[{"id":0},{"id":1}]});
		Assert.areEqual(2, collection.numChildren);
	}
	
	@Test
	public function testAddChildren() {
		var collection:PrototypesCollection<UnknownProto> = new PrototypesCollection<UnknownProto>("tests");
		collection.readExternal({"+tests":[{"id":0},{"id":1}]});
		Assert.areEqual(2, collection.numChildren);
	}
	
	@Test
	public function testGetItems() {
		var collection:PrototypesCollection<UnknownProto> = new PrototypesCollection<UnknownProto>("tests");
		collection.readExternal({"+tests":[{"id":0},{"id":1}]});
		var items = collection.getItems();
		Assert.isNotNull(items);
		Assert.areEqual(2, items.length);
	}
}