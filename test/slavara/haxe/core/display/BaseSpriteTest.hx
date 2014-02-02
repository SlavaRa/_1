package slavara.haxe.core.display;
import massive.munit.Assert;
import slavara.haxe.core.TypeDefs.BaseSprite;

/**
 * @author SlavaRa
 */
class BaseSpriteTest {

	public function new() { }
	
	@Test
	public function getChildByPathTest() {
		var sprite0 = new BaseSprite();
		var sprite1 = new BaseSprite();
		var sprite2 = new BaseSprite();
		
		sprite0.name = "sprite0";
		sprite1.name = "sprite1";
		sprite2.name = "sprite2";
		
		sprite0.addChild(sprite1);
		sprite1.addChild(sprite2);
		
		Assert.areEqual(sprite2, sprite0.getChildByName("sprite1.sprite2"));
	}
}