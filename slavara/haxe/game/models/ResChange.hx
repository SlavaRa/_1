package slavara.haxe.game.models;
import slavara.haxe.core.Models.DataValueObjectContainer;
import slavara.haxe.game.models.ResChange.ResChangeItem;
using Reflect;

class ResChange extends DataValueObjectContainer {
	
	public function toList():Array<ResChangeItem> {
		return [for(it in _list) cast(it, ResChangeItem)];
	}
	
	public function isEmpty():Bool return numChildren == 0;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		var rawItems:Array<Dynamic> = cast input;
		for(i in 0...rawItems.length) {
			var item = new ResChangeItem();
			item.readExternal(rawItems[i]);
			addChild(item);
		}
	}
}

class ResChangeItemImpl extends DataValueObjectContainer {
	
	public var resId(default, null):Int;
	
	@:allow(slavara.haxe.game.models)
	public var amount(default, null):Int;
	
	public function clone():ResChangeItem {
		var result = new ResChangeItem();
		result.resId = resId;
		result.amount = amount;
		return result;
	}
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		resId = input.getProperty("resId");
		amount = input.getProperty("amount");
	}
}

@:forward
abstract ResChangeItem(ResChangeItemImpl) from ResChangeItemImpl to ResChangeItemImpl {
	
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