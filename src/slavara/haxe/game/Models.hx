package slavara.haxe.game;
import flash.errors.ArgumentError;
import slavara.haxe.core.Errors.ArgumentNullError;
import slavara.haxe.core.Interfaces.IStateMachineHolder;
import slavara.haxe.core.Models.Data;
import slavara.haxe.core.Models.DataValueObjectContainer;
import slavara.haxe.core.StateMachine;
import slavara.haxe.game.Interfaces.IPrototypesCollection;
import slavara.haxe.game.Interfaces.IUnknown;
using slavara.haxe.core.utils.Utils.ValidateUtil;
using slavara.haxe.core.utils.Utils.StringUtil;
using Reflect;
using Std;

/**
 * @author SlavaRa
 */
class UnknownProto extends DataValueObjectContainer implements IUnknown {

	public function new() {
		super();
		initialize();
	}
	
	public var id(default, null):Int;
	public var desc(default, null):String;
	
	function initialize() { }
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		if(input.hasField("id")) id = input.getProperty("id");
		if(input.hasField("desc")) desc = input.getProperty("desc");
	}
}

/**
 * @author SlavaRa
 */
class UnknownData extends UnknownProto implements IStateMachineHolder {

	function new(proto:UnknownProto) {
		#if debug
		if(proto.isNull()) throw new ArgumentNullError("proto");
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
@:generic class PrototypesCollection<T:({public function new():Void;},UnknownProto)> extends DataValueObjectContainer implements IPrototypesCollection {
	
	public function new(inputKey:String) {
		#if debug
		if(inputKey.isNullOrEmpty()) throw new ArgumentNullError("inputKey");
		#end
		super();
		_t = Type.getClass(new T());
		_id2t = new Map();
		_addKey = "+" + inputKey;
	}
	
	var _t:Class<T>;
	var _id2t:Map<Int, T>;
	var _addKey:String;
	
	public function get(id:Int):T return _id2t.exists(id) ? _id2t.get(id) : null;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		
		if(input.hasField(_addKey)) {
			var list:Array<Dynamic> = input.getProperty(_addKey);
			for(it in list) {
				var proto:UnknownProto = new T();
				proto.readExternal(it);
				addChild(proto);
			}
		}
	}
	
	override function addChildBefore(child:Data) {
		super.addChildBefore(child);
		
		if(child.is(_t)) {
			var proto:T = cast child;
			var id = proto.id;
			if(_id2t.exists(id)) {
				throw new ArgumentError("A " + Type.typeof(proto) + " with id = " + id + " already exists.");
			}
			_id2t.set(id, proto);
			return;
		}
	}
}

/**
 * @author SlavaRa
 */
@:generic class DataCollection<T:({public function new(proto:UnknownProto):Void;},UnknownData)> extends DataValueObjectContainer {

	public function new(prototypes:IPrototypesCollection, inputKey:String) {
		#if debug
		if(inputKey.isNullOrEmpty()) throw new ArgumentNullError("inputKey");
		#end
		super();
		_t = Type.getClass(new T(Type.createEmptyInstance(UnknownProto)));
		_id2t = new Map();
		_prototypes = prototypes;
		_addKey = "+" + inputKey;
		_removeKey = "-" + inputKey;
		_updateKey = "=" + inputKey;
	}
	
	var _t:Class<T>;
	var _id2t:Map<Int, T>;
	var _prototypes:IPrototypesCollection;
	var _addKey:String;
	var _removeKey:String;
	var _updateKey:String;
	
	public function get(id:Int):T return _id2t.exists(id) ? _id2t.get(id) : null;
	
	override function deserialize(input:Dynamic) {
		super.deserialize(input);
		
		var protoIdKey = "proto_id";
		var idKey = "id";
		
		if(input.hasField(_addKey)) {
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
		if(input.hasField(_removeKey)) {
			var list:Array<Dynamic> = input.getProperty(_removeKey);
			for(it in list) {
				if(it.hasField(idKey)) {
					var id:Int = it.getProperty(idKey);
					if(_id2t.exists(id)) {
						removeChild(_id2t.get(id));
					}
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
					if(_id2t.exists(id)) {
						_id2t.get(id).readExternal(it);
					}
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
			if(_id2t.exists(id)) {
				throw new ArgumentError("A " + Type.typeof(data) + " with id = " + id + " already exists.");
			}
			_id2t.set(id, data);
		}
	}
	
	override function removeChildBefore(child:Data) {
		super.removeChildBefore(child);
		
		if(child.is(_t)) {
			var data:T = cast child;
			var id = data.id;
			if(_id2t.exists(id)) {
				_id2t.remove(id);
			}
		}
	}
}