package slavara.haxe.core.models;
import haxe.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import slavara.haxe.core.events.models.DataBaseEvent;
import slavara.haxe.core.models.Data;

/**
 * @author SlavaRa
 */
class DataTest extends Data {

	public function new() {
		super();
	}
	
	@Test
	public function containerAddChildTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		
		Assert.areEqual(container.numChildren, 0);
		
		var child:Data = Type.createEmptyInstance(Data);
		var returnChild = container.addChild(child);
		
		Assert.areEqual(container.numChildren, 1);
		Assert.areEqual(child.parent, container);
		Assert.areEqual(child, returnChild);
	}
	
	@Test
	public function containerRemoveChildTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		container.addChild(child);
		
		var returnChild = container.removeChild(child);
		
		Assert.areEqual(container.numChildren, 0);
		Assert.areEqual(child, returnChild);
		Assert.isNull(child.parent);
	}
	
	@Test
	public function containerRemoveChildrenTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var children:Array<Data> = [for(i in 0...10) Type.createEmptyInstance(Data)];
		for(it in children) container.addChild(it);
		
		Assert.areEqual(container.numChildren, 10);
		
		container.removeChildren();
		
		Assert.areEqual(container.numChildren, 0);
	}
	
	@Test
	public function containerGetChildByNameTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child0:Data = Type.createEmptyInstance(Data);
		var child1:Data = Type.createEmptyInstance(Data);
		
		child0.name = "child0";
		child1.name = "child1";
		
		container.addChild(child0);
		container.addChild(child1);
		
		Assert.areEqual(child0, container.getChildByName("child0"));
		Assert.areEqual(child1, container.getChildByName("child1"));
		Assert.areNotEqual(child1, container.getChildByName("child0"));
		Assert.areNotEqual(child0, container.getChildByName("child1"));
	}
	
	@Test
	public function containerGetChildByPathTest() {
		var container0:DataContainer = Type.createInstance(DataContainer, []);
		var container1:DataContainer = Type.createInstance(DataContainer, []);
		var container2:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		
		container1.name = "container1";
		container2.name = "container2";
		child.name = "child0";
		
		container0.addChild(container1);
		container1.addChild(container2);
		container2.addChild(child);
		
		Assert.areEqual(child, container0.getChildByName("container1.container2.child0"));
	}
	
	@Test
	public function containerGetChildAtTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child0:Data = Type.createEmptyInstance(Data);
		var child1:Data = Type.createEmptyInstance(Data);
		
		container.addChild(child0);
		container.addChild(child1);
		
		Assert.areEqual(child0, container.getChildAt(0));
		Assert.areEqual(child1, container.getChildAt(1));
		Assert.areNotEqual(child1, container.getChildAt(0));
		Assert.areNotEqual(child0, container.getChildAt(1));
	}
	
	@Test
	public function containerSwapChildrenTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child0:Data = Type.createEmptyInstance(Data);
		var child1:Data = Type.createEmptyInstance(Data);
		
		container.addChild(child0);
		container.addChild(child1);
		
		container.swapChildren(child0, child1);
		
		Assert.areEqual(child0, container.getChildAt(1));
		Assert.areEqual(child1, container.getChildAt(0));
	}
	
	@Test
	public function containerSwapChildrenAtTest() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child0:Data = Type.createEmptyInstance(Data);
		var child1:Data = Type.createEmptyInstance(Data);
		
		container.addChild(child0);
		container.addChild(child1);
		
		container.swapChildrenAt(0, 1);
		
		Assert.areEqual(child0, container.getChildAt(1));
		Assert.areEqual(child1, container.getChildAt(0));
	}
	
	@Test
	public function containerContainsTest() {
		var container0:DataContainer = Type.createInstance(DataContainer, []);
		var container1:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		
		container0.addChild(container1);
		container1.addChild(child);
		
		Assert.isTrue(container0.contains(child));
	}
}