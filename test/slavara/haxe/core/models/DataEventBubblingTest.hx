package slavara.haxe.core.models;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.Models.Data;
import slavara.haxe.core.Models.DataContainer;

/**
 * @author SlavaRa
 */
class DataEventBubblingTest {

	public function new() { }
	
	@AsyncTest
	public function dataEventBubblingTest(factory:AsyncFactory) {
		var container0:DataContainer = Type.createInstance(DataContainer, []);
		var container1:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		
		var resultHandler:Dynamic = factory.createHandler(this, function(d1:Data) {
			Assert.areEqual(d1, child);
			Assert.areNotEqual(d1, container0);
			Assert.areNotEqual(d1, container1);
		}, 1000);
		
		container0.addChild(container1);
		
		container0.addEventListener(DataBaseEvent.ADDED, function(event:DataBaseEvent) {
			resultHandler(event.target);
		});
		
		container1.addChild(child);
	}
}