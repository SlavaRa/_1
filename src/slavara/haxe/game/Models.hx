package slavara.haxe.game;
import openfl.errors.ArgumentError;
import openfl.events.Event;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Interfaces.IStateMachineHolder;
import slavara.haxe.core.Models.Data;
import slavara.haxe.core.Models.DataValueObjectContainer;
import slavara.haxe.core.StateMachine;
import slavara.haxe.game.Interfaces.IPrototypesCollection;
import slavara.haxe.game.Interfaces.IUnknown;
using slavara.haxe.core.Utils.StringUtil;
using Reflect;
using Std;
using Lambda;

/**
 * @author SlavaRa
 */
class Unknown extends DataValueObjectContainer implements IUnknown {
	public function new() {
		super();
		initialize();
	}
	
	public var id(default, null):Int;
	
	function initialize() { }
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("id")) id = input.getProperty("id");
	}
}

/**
 * @author SlavaRa
 */
class UnknownProto extends Unknown {

	public function new() super();
	
	public var ident(default, null):String;
	public var desc(default, null):String;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("ident")) ident = input.getProperty("ident");
		if(input.hasField("desc")) desc = input.getProperty("desc");
	}
}

/**
 * @author SlavaRa
 */
class UnknownData extends Unknown implements IStateMachineHolder {

	public function new(proto:UnknownProto) {
		#if debug
		if(proto == null) throw new ArgumentNullError("proto");
		#end
		this.proto = proto;
		super();
	}
	
	public var proto(default, null):UnknownProto;
	public var stateMachine(default, null):StateMachine;
	
	override function initialize() stateMachine = new StateMachine();
}

/**
 * @author SlavaRa
 */
@:generic class PrototypesCollection<T:({public function new():Void;},UnknownProto)> extends UnknownProto implements IPrototypesCollection {
	
	public function new(key:String) {
		#if debug
		if(key.isNullOrEmpty()) throw new ArgumentNullError("key");
		#end
		super();
		_t = Type.getClass(new T());
		_id2t = new Map();
		_key = key;
		_addKey = "+" + key;
	}
	
	var _t:Class<T>;
	var _id2t:Map<Int, T>;
	var _key:String;
	var _addKey:String;
	
	public function get(id:Int):T return _id2t.exists(id) ? _id2t.get(id) : null;
	
	public function getItems():Array<T> return _id2t.array();
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		var changed = false;
		if(input.hasField(_key)) {
			_id2t = new Map();
			removeChildren();
			input.setProperty(_addKey, input.getProperty(_key));
			changed = true;
		}
		if(input.hasField(_addKey)) {
			var list:Array<Dynamic> = input.getProperty(_addKey);
			for(it in list) {
				var proto:UnknownProto = new T();
				proto.readExternal(it);
				addChild(proto);
			}
			changed = true;
		}
		if(changed && hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
	}
	
	override function addChildBefore(child:Data) {
		super.addChildBefore(child);
		if(child.is(_t)) {
			var proto:T = cast child;
			var id = proto.id;
			if(_id2t.exists(id)) throw new ArgumentError("A " + Type.typeof(proto) + " with id = " + id + " already exists.");
			_id2t.set(id, proto);
			return;
		}
	}
}

/**
 * @author SlavaRa
 */
@:generic class DataCollection<T:({public function new(proto:UnknownProto):Void;},UnknownData)> extends DataValueObjectContainer {

	public function new(prototypes:IPrototypesCollection, key:String) {
		#if debug
		if(key.isNullOrEmpty()) throw new ArgumentNullError("key");
		#end
		super();
		_t = Type.getClass(new T(Type.createEmptyInstance(UnknownProto)));
		_id2t = new Map();
		_prototypes = prototypes;
		_addKey = "+" + key;
		_removeKey = "-" + key;
		_updateKey = "=" + key;
	}
	
	var _t:Class<T>;
	var _id2t:Map<Int, T>;
	var _prototypes:IPrototypesCollection;
	var _addKey:String;
	var _removeKey:String;
	var _updateKey:String;
	
	public function get(id:Int):T return _id2t.exists(id) ? _id2t.get(id) : null;
	
	public function getItems():Array<T> return _id2t.array();
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField(_addKey)) {
			var protoIdKey = "proto_id";
			var list:Array<Dynamic> = input.getProperty(_addKey);
			for(it in list) {
				if(it.hasField(protoIdKey)) {
					var child:UnknownData = new T(_prototypes.get(it.getProperty(protoIdKey)));
					child.readExternal(it);
					addChild(child);
				} else {
					//throw error
				}
			}
		}
		var idKey = "id";
		if(input.hasField(_removeKey)) {
			var list:Array<Dynamic> = input.getProperty(_removeKey);
			for(it in list) {
				if(it.hasField(idKey)) {
					var id:Int = it.getProperty(idKey);
					if(_id2t.exists(id)) removeChild(_id2t.get(id));
				} else {
					//TODO: throw error
				}
			}
		}
		if(input.hasField(_updateKey)) {
			var list:Array<Dynamic> = input.getProperty(_updateKey);
			for(it in list) {
				if(it.hasField(idKey)) {
					var id:Int = it.getProperty(idKey);
					if(_id2t.exists(id)) _id2t.get(id).readExternal(it);
				} else {
					//TODO: throw error
				}
			}
		}
	}
	
	override function addChildBefore(child:Data) {
		super.addChildBefore(child);
		if(child.is(_t)) {
			var data:T = cast child;
			var id = data.id;
			if(_id2t.exists(id)) throw new ArgumentError("A " + Type.typeof(data) + " with id = " + id + " already exists.");
			_id2t.set(id, data);
		}
	}
	
	override function removeChildBefore(child:Data) {
		super.removeChildBefore(child);
		if(child.is(_t)) {
			var data:T = cast child;
			var id = data.id;
			if(_id2t.exists(id)) _id2t.remove(id);
		}
	}
}