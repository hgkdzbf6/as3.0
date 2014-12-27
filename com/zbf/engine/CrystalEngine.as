package script.com.zbf.engine
{
	import flash.display.Sprite;
	import script.com.zbf.ui.Crystal;
	import script.com.zbf.engine.Engine;
	/**
	 * ...
	 * @author ...
	 */
	public class CrystalEngine extends Engine 
	{
		public var engine:Engine;
		//public var stage:Sprite;
		public var crystal:Crystal;
		public function CrystalEngine() {
			
		}
		public static function createNewCrystalEngine(engine:Engine):CrystalEngine {
			var crystalEngine:CrystalEngine = new CrystalEngine;
			crystalEngine.engine = engine;
			crystalEngine.stage = engine.stage;
			crystalEngine.init();
			return crystalEngine;
		}
		public function init() {
			crystal = new Crystal();
			crystal.draw();
		}
		public function setCrystalNum(a:int,u:int) {
			crystal.redraw(a, u);
		}
	}
}