package  script.com.zbf.ui
{
	import flash.display.Sprite;
	import script.com.zbf.utils.Draw;
	import script.com.zbf.engine.CrystalEngine;
	/**
	 * ...
	 * @author ...
	 */
	public class Crystal extends Sprite 
	{
		public var display:Sprite;
		public function Crystal() {
			
		}
		public function init() {
			
		}
		public function draw() {
			display = Draw.redrawCrystals(0, 10);
		}
		public function redraw(available:int, unavailable:int) {
			if (numChildren) {
				removeChildAt(0);
			}
			display = Draw.redrawCrystals(available, unavailable);
			addChild(display);
		}
	}
	
}