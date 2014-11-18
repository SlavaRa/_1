import massive.munit.TestSuite;

import ExampleTest;
import slavara.haxe.core.controllers.BaseControllerTest;
import slavara.haxe.core.display.BaseSpriteTest;
import slavara.haxe.core.display.ResourceSpriteTest;
import slavara.haxe.core.models.DataContainerTest;
import slavara.haxe.core.models.DataEventBubblingTest;
import slavara.haxe.core.utils.DestroyableTest;
import slavara.haxe.core.utils.StringUtilsTest;
import slavara.haxe.game.controllers.BaseSystemControllerTest;
import slavara.haxe.game.models.UnknownDataTest;
import slavara.haxe.game.models.UnknownProtoTest;
import slavara.haxe.game.models.UnknownTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(ExampleTest);
		add(slavara.haxe.core.controllers.BaseControllerTest);
		add(slavara.haxe.core.display.BaseSpriteTest);
		add(slavara.haxe.core.display.ResourceSpriteTest);
		add(slavara.haxe.core.models.DataContainerTest);
		add(slavara.haxe.core.models.DataEventBubblingTest);
		add(slavara.haxe.core.utils.DestroyableTest);
		add(slavara.haxe.core.utils.StringUtilsTest);
		add(slavara.haxe.game.controllers.BaseSystemControllerTest);
		add(slavara.haxe.game.models.UnknownDataTest);
		add(slavara.haxe.game.models.UnknownProtoTest);
		add(slavara.haxe.game.models.UnknownTest);
	}
}
