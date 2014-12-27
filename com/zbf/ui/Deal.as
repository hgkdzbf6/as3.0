package script.com.zbf.ui
{
	import flash.display.Sprite;
	import script.com.zbf.engine.MainEngine;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Deal extends Sprite
	{
		private var mainEngine:MainEngine;
		
		public function Deal()
		{
			init();
		}
		
		public function init()
		{
			mainEngine = MainEngine.createNewMainEngine(this);
			//commandEngine.run("命令名::参数1##参数2##参数3");
			//trace("sabi##sabi##woshi##yige##sabi".split("##")); 
		}
	}
}