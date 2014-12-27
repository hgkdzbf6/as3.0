package script.com.zbf.ui
{
	import flash.display.Sprite;
	import script.com.zbf.engine.ClientEngine;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardClient extends Sprite
	
	{
		public var clientEngine:ClientEngine;
		
		public function CardClient()
		{
			init();
		}
		
		public function init()
		{
			clientEngine = ClientEngine.createNewClientEngine(this);
		}
	}
}