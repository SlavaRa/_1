package slavara.haxe.core.models;
import massive.munit.Assert;
import slavara.haxe.core.Models.Data;
import slavara.haxe.core.Models.DataContainer;

/**
 * @author SlavaRa
 */
class DataContainerTest {

	public function new() { }
	
	@Test
	public function testAddChild() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		Assert.areEqual(container.numChildren, 0);
		var child:Data = Type.createEmptyInstance(Data);
		var returnChild = container.addChild(child);
		Assert.areEqual(container.numChildren, 1);
		Assert.areEqual(child.parent, container);
		Assert.areEqual(child, returnChild);
	}
	
	@Test
	public function testRemoveChild() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		container.addChild(child);
		var returnChild = container.removeChild(child);
		Assert.areEqual(container.numChildren, 0);
		Assert.areEqual(child, returnChild);
		Assert.isNull(child.parent);
	}
	
	@Test
	public function testRemoveChildren() {
		var container:DataContainer = Type.createInstance(DataContainer, []);
		var children:Array<Data> = [for(i in 0...10) Type.createEmptyInstance(Data)];
		for(it in children) container.addChild(it);
		container.removeChildren();
		Assert.areEqual(container.numChildren, 0);
	}
	
	@Test
	public function testGetChildByName() {
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
	public function testGetChildByPath() {
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
	public function testGetChildAt() {
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
	public function testSwapChildren() {
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
	public function testSwapChildrenAt() {
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
	public function testContains() {
		var container0:DataContainer = Type.createInstance(DataContainer, []);
		var container1:DataContainer = Type.createInstance(DataContainer, []);
		var child:Data = Type.createEmptyInstance(Data);
		container0.addChild(container1);
		container1.addChild(child);
		Assert.isTrue(container0.contains(child));
	}
}