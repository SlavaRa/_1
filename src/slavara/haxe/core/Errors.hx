package slavara.haxe.core;
#if !macro

/**
 * @author SlavaRa
 */
class ArgumentNullError extends flash.errors.ArgumentError {
	public function new(?argName:String) super("the " + argName + " argument must not be null", 1009);
}

class NotImplementedError extends flash.errors.Error {
	public function new() super();
}

#else
import haxe.macro.Context;

/**
 * @author SlavaRa
 */
extern class ArgumentNullError extends haxe.macro.Expr.Error {
	public function new(?argName:String) {
		super("the " + argName + " argument must not be null", Context.currentPos());
	}
}
#end