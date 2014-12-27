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
	public class ZhaoXiang extends SkillData
	{		
		public function ZhaoXiang() {
			
		}
		/**
		 * 效果：控制一个角色，并使对方抽两张牌
		 */
		override public function effect() 
		{			
			if (mainEngine.isYourTurn) {
				mainEngine.controlAMinion(false);
				mainEngine.drawACard(false);
				mainEngine.drawACard(false);
			}else {
				mainEngine.controlAMinion(true);
				mainEngine.drawACard(true);
				mainEngine.drawACard(true);
			}
		}
		override public function get cost():int 
		{
			return super.cost;
		}
		
		override public function set cost(value:int):void 
		{
			super.cost = 5;
		}
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = "招降";
		}

	}
}