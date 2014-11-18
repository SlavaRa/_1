package slavara.haxe.core;
#if !macro
/**
 * @author SlavaRa
 */
class ArgumentNullError extends openfl.errors.Error {
	public function new(?argName:String) super("the " + argName + " argument must not be null", 1009);
}

/**
 * @author SlavaRa
 */
class NotImplementedError extends openfl.errors.Error {
	public function new() super();
}
#else
/**
 * @author SlavaRa
 */
extern class ArgumentNullError extends haxe.macro.Expr.Error {
	public function new(?argName:String) {
		super("the " + argName + " argument must not be null", haxe.macro.Context.currentPos());
	}
}
#end