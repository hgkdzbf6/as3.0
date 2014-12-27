package script.com.zbf.utils
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Move
	{
		public function Move() {
			
		}
		public static function setPosition(target:Sprite,px:int,py:int) {
			target.x = px;
			target.y = py;
		}
		public static function addAndSetposition(target:Sprite, to:Sprite, px:int, py:int) {
			to.addChild(target);
			Move.setPosition(target, px, py);
		}
	}
	
}