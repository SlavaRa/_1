package slavara.haxe.core;
import flash.errors.ArgumentError;
import msignal.Signal.Signal0;
using Lambda;

/**
 * @author SlavaRa
 */
class StateMachine {

	public function new() {
		currentState = null;
		previousState = null;
		onChange = new Signal0();
		_transitions = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, StateTransition>>();
		_transitionListeners = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, Array<Void -> Void>>>();
	}
	
	public var currentState(default, null):EnumValue;
	public var previousState(default, null):EnumValue;
	public var onChange(default, null):Signal0;
	
	public function clear() {
		onChange.removeAll();
		currentState = null;
		previousState = null;
		_transitions = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, StateTransition>>();
		_queuedState = null;
		_statesQueue = null;
		_transitionListeners = new EnumValueHash<EnumValue, EnumValueHash<EnumValue, Array<Void -> Void>>>();
		_inTransition = false;
	}
	
	public function add(from:EnumValue, to:EnumValue, ?via:Array<EnumValue>) {
		#if debug
		if(from == null) throw new ArgumentError("the from argument must not be null");
		if(to == null) throw new ArgumentError("the to argument must not be null");
		#end
		if(from == to) {
			return;
		}
		if(!_transitions.exists(from)) {
			_transitions.set(from, new EnumValueHash<EnumValue, StateTransition>());
		}
		if(!_transitions.exists(to)) {
			_transitions.set(to, new EnumValueHash<EnumValue, StateTransition>());
		}
		_transitions.get(from).set(to, new StateTransition(from, to, via));
	}
	
	public function addToMany(from:EnumValue, to:Array<EnumValue>, ?via:Array<EnumValue>) {
		#if debug
		if(from == null) throw new ArgumentError("the from argument must not be null");
		if(to == null) throw new ArgumentError("the to argument must not be null");
		#end
		for(toState in to) {
			add(from, toState);
		}
	}
	
	public function addAllToAll(all:Array<EnumValue>, ?via:Array<EnumValue>) {
		#if debug
		if(all == null) throw new ArgumentError("the all argument must not be null");
		#end
		for(from in all) {
			for(to in all) {
				addTwoWay(from, to, via);
			}
		}
	}
	
	public function addTwoWay(from:EnumValue, to:EnumValue, ?via:Array<EnumValue>) {
		#if debug
		if(from == null) throw new ArgumentError("the from argument must not be null");
		if(to == null) throw new ArgumentError("the to argument must not be null");
		#end
		add(from, to, via);
		add(to, from, via);
	}
	
	public function setState(state:EnumValue) {
		#if debug
		if(state == null) throw new ArgumentError("the state argument must not be null");
		#end
		if(currentState == null) {
			currentState = state;
			broadcastStateChange(null, currentState);
		}
		if(state == currentState) {
			return;
		}
		if(_inTransition) {
			_queuedState = state;
			return;
		} else {
			_queuedState = null;
		}
		if(!_transitions.exists(currentState)) {
			return;
		}
		var state2Transition = _transitions.get(currentState);
		var transition = state2Transition.get(state);
		if(transition == null) {
			return;
		}
		previousState = currentState;
		if(transition.simple) {
			currentState = transition.to;
			broadcastStateChange(transition.from, transition.to);
		} else {
			_inTransition = true;
			_statesQueue = transition.queue;
			setNextQueuedState();
		}
	}
	
	public function release() setNextQueuedState();
	
	public function addTransitionListener(from:EnumValue, to:EnumValue, listener:Void -> Void) {
		#if debug
		if(from == null) throw new ArgumentError("the from argument must not be null");
		if(to == null) throw new ArgumentError("the to argument must not be null");
		if(listener == null) throw new ArgumentError("the listener argument must not be null");
		#end
		if(!_transitionListeners.exists(from)) {
			_transitionListeners.set(from, new EnumValueHash<EnumValue, Array<Void -> Void>>());
		}
		var to2Listeners = _transitionListeners.get(from);
		if(!to2Listeners.exists(to)) {
			to2Listeners.set(to, []);
		}
		var listeners = to2Listeners.get(to);
		if(listeners.has(listener)) {
			return;
		}
		listeners.push(listener);
	}
	
	public function removeTransitionListener(from:EnumValue, to:EnumValue, listener:Void -> Void) {
		#if debug
		if(from == null) throw new ArgumentError("the from argument must not be null");
		if(to == null) throw new ArgumentError("the to argument must not be null");
		if(listener == null) throw new ArgumentError("the listener argument must not be null");
		#end
		if(!_transitionListeners.exists(from)) {
			return;
		}
		var to2Listeners = _transitionListeners.get(from);
		if(!to2Listeners.exists(to)) {
			return;
		}
		var listerens = to2Listeners.get(to);
		listerens.remove(listener);
		if(listerens.length == 0) {
			to2Listeners.remove(to);
		}
		if(to2Listeners.isEmpty()) {
			_transitionListeners.remove(from);
		}
	}
	
	var _transitions:EnumValueHash<EnumValue, EnumValueHash<EnumValue, StateTransition>>;
	var _queuedState:EnumValue;
	var _statesQueue:Array<EnumValue>;
	var _transitionListeners:EnumValueHash<EnumValue, EnumValueHash<EnumValue, Array<Void -> Void>>>;
	var _inTransition:Bool;
	
	inline function setNextQueuedState() {
		previousState = currentState;
		currentState = _statesQueue[0];
		_statesQueue.remove(currentState);
		broadcastStateChange(previousState, currentState);
		_inTransition = _statesQueue.length > 0;
		var state2transition = _transitions.get(currentState);
		if(state2transition != null && _inTransition) {
			if(_queuedState != null) {
				var transition = state2transition.get(_queuedState);
				if(transition != null) {
					_inTransition = false;
					_statesQueue = null;
					setState(_queuedState);
				}
			} else if(_inTransition) {
				setNextQueuedState();
			}
		}
	}
	
	inline function broadcastStateChange(from:EnumValue, to:EnumValue) {
		onChange.dispatch();
		if(_transitionListeners.exists(from)) {
			var to2Listeners = _transitionListeners.get(from);
			if(to2Listeners.exists(to)) {
				for(handler in to2Listeners.get(to)) {
					handler();
				}
			}
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
			_queue = [];
			for(state in via) {
				_queue.push(state);
			}
			_queue.push(to);
		}
	}
	
	public var from(default, null):EnumValue;
	public var to(default, null):EnumValue;
	public var queue(get, null):Array<EnumValue>;
	public var simple(get, null):Bool;
	
	var _queue:Array<EnumValue>;
	
	function get_queue():Array<EnumValue> return _queue != null ? _queue.copy() : [];
	
	function get_simple():Bool return _queue == null;
}

/**
 * @author SlavaRa
 */
private class EnumValueHash<K, V>{
	
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
		if(index == -1) {
			return false;
		} else {
			_values.remove(_values[index]);
			return _keys.remove(k);
		}
	}
	
	public function isEmpty():Bool return _keys != null || _keys.empty();
}