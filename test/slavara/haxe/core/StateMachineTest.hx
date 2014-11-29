package slavara.haxe.core;
import massive.munit.Assert;
import slavara.haxe.core.StateMachine;

/**
 * @author SlavaRa
 */
class StateMachineTest {

	public function new() { }
	
	@Test
	public function testHas() {
		var smachine = new StateMachine()
			.add(State.Some("a"), State.Some("b"))
			.add(State.Some("a"), State.Some("c"));
		Assert.isTrue(smachine.has(State.Some("a"), State.Some("b")));
		Assert.isTrue(smachine.has(State.Some("a"), State.Some("c")));
		Assert.isFalse(smachine.has(State.Some("b"), State.Some("c")));
	}
	
	@Test
	public function testHasFrom() {
		var smachine = new StateMachine()
			.add(State.Some("a"), State.Some("b"))
			.add(State.Some("b"), State.Some("c"));
		Assert.isTrue(smachine.hasFrom(State.Some("a")));
		Assert.isTrue(smachine.hasFrom(State.Some("b")));
		Assert.isFalse(smachine.hasFrom(State.Some("c")));
	}
	
	@Test
	public function testHasTo() {
		var smachine = new StateMachine()
			.add(State.Some("a"), State.Some("b"))
			.add(State.Some("b"), State.Some("c"))
			.setState(State.Some("a"));
		Assert.isTrue(smachine.hasTo(State.Some("b")));
		Assert.isFalse(smachine.hasTo(State.Some("c")));
		smachine.setState(State.Some("b"));
		Assert.isTrue(smachine.hasTo(State.Some("c")));
		Assert.isFalse(smachine.hasTo(State.Some("a")));
	}
	
	@Test
	public function testOnChangeAB() {
		var smachine = new StateMachine();
		smachine.onChange.addOnce(function() {
			Assert.isTrue(Type.enumEq(smachine.currentState, State.Some("a")));
			smachine.onChange.addOnce(function() {
				Assert.isTrue(Type.enumEq(smachine.previousState, State.Some("a")));
				Assert.isTrue(Type.enumEq(smachine.currentState, State.Some("b")));
			});
			smachine.setState(State.Some("b"));
		});
		smachine
			.add(State.Some("a"), State.Some("b"))
			.setState(State.Some("a"));
	}
	
	@Test
	public function testOnChangeABAC() {
		var smachine = new StateMachine();
		smachine.onChange.addOnce(function() {
			Assert.isTrue(Type.enumEq(smachine.currentState, State.Some("a")));
			smachine.onChange.addOnce(function() {
				Assert.isTrue(Type.enumEq(smachine.previousState, State.Some("a")));
				Assert.isTrue(Type.enumEq(smachine.currentState, State.Some("b")));
				smachine.setState(State.Some("a"));
				smachine.onChange.addOnce(function() {
					Assert.isTrue(Type.enumEq(smachine.previousState, State.Some("a")));
					Assert.isTrue(Type.enumEq(smachine.currentState, State.Some("c")));
				});
				smachine.setState(State.Some("c"));
			});
			smachine.setState(State.Some("b"));
		});
		smachine
			.add(State.Some("a"), State.Some("b"))
			.add(State.Some("b"), State.Some("a"))
			.add(State.Some("a"), State.Some("c"))
			.setState(State.Some("a"));
	}
}