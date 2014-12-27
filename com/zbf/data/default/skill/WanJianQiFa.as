package script.com.zbf.data.default.skill
{
	import script.com.zbf.card.CardBase;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.engine.CharacterEngine;
	/**
	 * ...
	 * @author ...
	 */
	public class WanJianQiFa extends SkillData
	{		
		public function WanJianQiFa() {
			
		}
		/**
		 * 效果：对所有敌方随从造成1-5点伤害
		 */
		override public function effect() 
		{			
			if (mainEngine.isYourTurn) {
				mainEngine.dealDamageToMinions(false, damage);
			}else {
				mainEngine.dealDamageToMinions(false, damage);
			}
		}
		private function damage():int {
			return int(Math.random()*4+1);
		}
		override public function get cost():int 
		{
			return super.cost;
		}
		
		override public function set cost(value:int):void 
		{
			super.cost = 2;
		}
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = "万箭齐发";
		}

	}
}