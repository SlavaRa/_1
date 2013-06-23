package slavara.haxe.core.controllers;
import slavara.haxe.core.display.DisplayObject;
import slavara.haxe.core.display.DisplayObjectContainer;
import slavara.haxe.core.models.Data;
import slavara.haxe.core.utils.IInitialize;

/**
 * @author SlavaRa
 */

interface IController extends IInitialize {
	var container(default, null):DisplayObjectContainer;
	var data(default, null):Data;
	var view(default, null):DisplayObject;
}