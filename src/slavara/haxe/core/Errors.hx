package slavara.haxe.core;
import flash.errors.ArgumentError;

/**
 * @author SlavaRa
 */
class NullArgumentError extends ArgumentError {
	public function new(?argName:String) super("the " + argName + " argument must not be null");
}