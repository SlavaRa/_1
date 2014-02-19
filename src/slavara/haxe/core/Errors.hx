package slavara.haxe.core;
#if flash
import flash.errors.ArgumentError;

/**
 * @author SlavaRa
 */
extern class ArgumentNullError extends ArgumentError {
	public function new(?argName:String) super("the " + argName + " argument must not be null");
}
#else
import haxe.macro.Expr.Error;
import haxe.macro.Context;

/**
 * @author SlavaRa
 */
extern class ArgumentNullError extends Error {
	public function new(?argName:String) {
		super("the " + argName + " argument must not be null", Context.currentPos());
	}
}
#end