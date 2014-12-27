package script.com.zbf.data.default.skill.sanguo.shu
{
	import script.com.zbf.card.CardBase;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.engine.CharacterEngine;
	import script.com.zbf.engine.CardFieldEngine;
	/**
	 * ...
	 * @author ...
	 */
	public class HuangYueYing extends SkillData
	{		
		public function HuangYueYing() {
			
		}
		/**
		 * 效果：使一个随从变为5攻击力
		 */
		override public function effect() 
		{			
			if (mainEngine.isYourTurn) {
				mainEngine.drawACard(true);
				mainEngine.drawACard(true);
			}else {
				mainEngine.drawACard(false);
				mainEngine.drawACard(false);
			}
		}
		override public function get cost():int 
		{
			return super.cost;
		}
		
		override public function set cost(value:int):void 
		{
			super.cost = 3;
		}
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = "黄月英武魂";
		}

	}
}