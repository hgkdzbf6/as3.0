package script.com.zbf.data.default.skill
{
	import script.com.zbf.card.CardBase;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.skill.SkillData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Coin extends SkillData
	{		
		public function Coin() {
			super();
		}
		override public function effect() 
		{			
			if (mainEngine.isYourTurn) {
				mainEngine.yourCurrentCrystalNum ++;
			}else {
				mainEngine.enemyCurrentCrystalNum ++;
			}
		}
		override public function get cost():int 
		{
			return super.cost;
		}
		
		override public function set cost(value:int):void 
		{
			super.cost = 0;
		}
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = "硬币";
		}

	}
}