package script.com.zbf.character
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class Character extends Sprite
	{
		public var tfHealth:TextField;
		public function Character() {
			
		}
		//"我是大怪hia！"
		public function draw(str:String) {
			addChild(Draw.drawCharacter(str));
			tfHealth = Draw.drawLabel(40, 58, str, Draw.FORMAT_1);
			addChild(tfHealth);
		}
	}
	
}