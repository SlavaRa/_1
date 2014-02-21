package slavara.haxe.core;

#if !(flash11 && starling)
typedef DisplayObject = flash.display.DisplayObject;
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
typedef BaseSprite = slavara.haxe.core.display.openfl.BaseSprite;
typedef ResourceSprite = slavara.haxe.core.display.openfl.ResourceSprite;
#else
//TODO: implement me
#end