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
	public class DeadlyDamage extends SkillData
	{		
		public function DeadlyDamage() {
			
		}
		override public function effect() 
		{			
			if (mainEngine.isYourTurn) {
				mainEngine.getCharacterEngine(0).decreaseHealth(8);
			}else {
				mainEngine.getCharacterEngine(1).decreaseHealth(8);
			}
		}
		override public function get cost():int 
		{
			return super.cost;
		}
		
		override public function set cost(value:int):void 
		{
			super.cost = 4;
		}
		override public function get name():String 
		{
			return super.name;
		}
		
		override public function set name(value:String):void 
		{
			super.name = "死亡打击";
		}

	}
}