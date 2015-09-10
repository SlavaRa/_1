package slavara.haxe.game.models;
import slavara.haxe.core.Models.DataValueObjectContainer;
import slavara.haxe.game.models.ResChange.ResChangeItem;
using Reflect;

class ResChange extends DataValueObjectContainer {
	
	public function new() super();
	
	public function toList():Array<ResChangeItem> {
		return [for(it in _list) cast(it, ResChangeItem)];
	}
	
	public function isEmpty():Bool return numChildren == 0;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		var rawItems:Array<Dynamic> = cast input;
		for(i in 0...rawItems.length) {
			trace(rawItems[i]);
			var item = new ResChangeItem();
			item.readExternal(rawItems[i]);
			addChild(item);
		}
	}
}

class ResChangeItemImpl extends DataValueObjectContainer {
	public function new() super();
	
	public var resourceId(default, null):Int;
	@:allow(slavara.haxe.game.models) public var amount(default, null):Int;
	
	public function clone():ResChangeItem {
		var result = new ResChangeItem();
		result.resourceId = resourceId;
		result.amount = amount;
		return result;
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		resourceId = input.getProperty("resourceId");
		amount = input.getProperty("amount");
	}
}

@:forward abstract ResChangeItem(ResChangeItemImpl) from ResChangeItemImpl to ResChangeItemImpl {
	
	public inline function new() this = new ResChangeItemImpl();
	
	@:op(A+B)
	public function plus(item:ResChangeItem):ResChangeItem {
		var result = this.clone();
		result.amount += item.amount;
		return result;
	}
	
	@:op(A-B)
	public function minus(item:ResChangeItem):ResChangeItem {
		var result = this.clone();
		result.amount -= item.amount;
		return result;
	}
}
