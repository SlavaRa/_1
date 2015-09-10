package slavara.haxe.core;
import msignal.Signal.Signal0;
import slavara.haxe.core.Errors.ArgumentNullError;
using Lambda;

/**
 * @author SlavaRa
 */
class StateMachine {

	public function new() {
		onChange = new Signal0();
		reset();
	}
	
	public var currentState(default, null):EnumValue;
	public var previousState(default, null):EnumValue;
	public var onChange(default, null):Signal0;
	
	var _transitions:EnumValueHash<EnumValue, EnumValueHash<EnumValue, StateTransition>>;
	var _queuedState:EnumValue;
	var _statesQueue:Array<EnumValue>;
	var _transitionListeners:EnumValueHash<EnumValue, EnumValueHash<EnumValue, Array<Void -> Void>>>;
	var _inTransition:Bool;
	
	public function reset():StateMachine {
		onChange.removeAll();
		currentState = null;
		previousState = null;
		_transitions = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, StateTransition>>();
		_queuedState = null;
		_statesQueue = null;
		_transitionListeners = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, Array<Void -> Void>>>();
		_inTransition = false;
		return this;
	}
	
	public function add(from:EnumValue, to:EnumValue, ?via:Array<EnumValue>):StateMachine {
		#if debug
		if(from == null) throw new ArgumentNullError("from");
		if(to == null) throw new ArgumentNullError("to");
		#end
		if(from == to) return this;
		if(!_transitions.exists(from)) _transitions.set(from, new EnumValueHash<EnumValue, StateTransition>());
		if(!_transitions.exists(to)) _transitions.set(to, new EnumValueHash<EnumValue, StateTransition>());
		_transitions.get(from).set(to, new StateTransition(from, to, via));
		return this;
	}
	
	public function addOneToAll(from:EnumValue, to:Array<EnumValue>, ?via:Array<EnumValue>):StateMachine {
		#if debug
		if(from == null) throw new ArgumentNullError("from");
		if(to == null) throw new ArgumentNullError("to");
		#end
		for(toState in to) add(from, toState);
		return this;
	}
	
	public function addAllToAll(all:Array<EnumValue>, ?via:Array<EnumValue>):StateMachine {
		#if debug
		if(all == null) throw new ArgumentNullError("all");
		#end
		for(from in all) for(to in all) addTwoWay(from, to, via);
		return this;
	}
	
	public function addTwoWay(from:EnumValue, to:EnumValue, ?via:Array<EnumValue>):StateMachine {
		#if debug
		if(from == null) throw new ArgumentNullError("from");
		if(to == null) throw new ArgumentNullError("to");
		#end
		add(from, to, via);
		add(to, from, via);
		return this;
	}
	
	public function setState(state:EnumValue):StateMachine {
		#if debug
		if(state == null) throw new ArgumentNullError("state");
		#end
		if(currentState == null) {
			currentState = state;
			broadcastStateChange(null, currentState);
		}
		if(state == currentState) return this;
		if(_inTransition) {
			_queuedState = state;
			return this;
		}
		_queuedState = null;
		if(!_transitions.exists(currentState)) return this;
		var transition = _transitions.get(currentState).get(state);
		if(transition == null) return this;
		previousState = currentState;
		if(transition.simple) {
			currentState = transition.to;
			broadcastStateChange(transition.from, transition.to);
		} else {
			_inTransition = true;
			_statesQueue = transition.queue;
			setNextQueuedState();
		}
		return this;
	}
	
	public function release():StateMachine {
		setNextQueuedState();
		return this;
	}
	
	public function addTransitionListener(from:EnumValue, to:EnumValue, listener:Void -> Void):StateMachine {
		#if debug
		if(from == null) throw new ArgumentNullError("from");
		if(to == null) throw new ArgumentNullError("to");
		if(listener == null) throw new ArgumentNullError("listener");
		#end
		if(!_transitionListeners.exists(from)) _transitionListeners.set(from, new EnumValueHash<EnumValue, Array<Void -> Void>>());
		var to2listeners = _transitionListeners.get(from);
		if(!to2listeners.exists(to)) to2listeners.set(to, []);
		var listeners = to2listeners.get(to);
		if(!listeners.has(listener)) listeners.push(listener);
		return this;
	}
	
	public function removeTransitionListener(from:EnumValue, to:EnumValue, listener:Void -> Void):StateMachine {
		#if debug
		if(from == null) throw new ArgumentNullError("from");
		if(to == null) throw new ArgumentNullError("to");
		if(listener == null) throw new ArgumentNullError("listener");
		#end
		if(!_transitionListeners.exists(from)) return this;
		var to2listeners = _transitionListeners.get(from);
		if(!to2listeners.exists(to)) return this;
		var listerens = to2listeners.get(to);
		listerens.remove(listener);
		if(listerens.empty()) to2listeners.remove(to);
		if(to2listeners.empty()) _transitionListeners.remove(from);
		return this;
	}
	
	@:noCompletion inline function setNextQueuedState() {
		previousState = currentState;
		currentState = _statesQueue[0];
		_statesQueue.remove(currentState);
		broadcastStateChange(previousState, currentState);
		_inTransition = !_statesQueue.empty();
		var state2transition = _transitions.get(currentState);
		if(state2transition != null && _inTransition) {
			if(_queuedState != null) {
				var transition = state2transition.get(_queuedState);
				if(transition != null) {
					_inTransition = false;
					_statesQueue = null;
					setState(_queuedState);
				}
			} else if(_inTransition) setNextQueuedState();
		}
	}
	
	@:noCompletion inline function broadcastStateChange(from:EnumValue, to:EnumValue) {
		onChange.dispatch();
		if(_transitionListeners.exists(from)) {
			var listeners = _transitionListeners.get(from);
			if(listeners.exists(to)) for(it in listeners.get(to)) it();
		}
	}
}

/**
 * @author SlavaRa
 */
private class StateTransition {
	
	public function new(from:EnumValue, to:EnumValue, ?via:Array<EnumValue>) {
		this.from = from;
		this.to = to;
		if(via != null) {
			_queue = via.copy();
			_queue.push(to);
		}
	}
	
	public var from(default, null):EnumValue;
	public var to(default, null):EnumValue;
	public var queue(get, null):Array<EnumValue>;
	public var simple(get, null):Bool;
	
	var _queue:Array<EnumValue>;
	
	inline function get_queue():Array<EnumValue> return _queue != null ? _queue.copy() : [];
	
	inline function get_simple():Bool return _queue == null;
}

/**
 * @author SlavaRa
 */
private class EnumValueHash<K, V> {
	
	public function new() {
		_keys = [];
		_values = [];
	}
	
	var _keys:Array<K>;
	var _values:Array<V>;
	
	public function set(k:K, v:V) {
		var index = _keys.length;
		_keys[index] = k;
		_values[index] = v;
	}
	
	public function get(k:K):V {
		var index = _keys.indexOf(k);
		return index != -1 ? _values[index] : null;
	}
	
	public function exists(k:K):Bool {
		var index = _keys.indexOf(k);
		return index != -1 ? _values[index] != null : false;
	}
	
	public function remove(k:K):Bool {
		var index = _keys.indexOf(k);
		if(index == -1) return false;
		_values.remove(_values[index]);
		return _keys.remove(k);
	}
	
	public function empty():Bool return _keys != null || _keys.empty();
}