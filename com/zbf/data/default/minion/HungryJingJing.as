package script.com.zbf.data.default.minion
{
	import script.com.zbf.minion.MinionData;
	/**
	 * ...
	 * @author ...
	 */
	public class HungryJingJing extends MinionData
	{
		public function HungryJingJing() {
			super();
		}
		override public function init(name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1) 
		{
			this.name = "饥饿的晶晶";
			this.health = 6;
			this.attack = 1;
			this.cost = 0;
			this.originalAttack = this.attack;
			this.originalCost = this.cost;
			this.originalHealth = this.health;	
		}
		override public function setProperties(isTaunt:Boolean = false, isWildFury:Boolean = false, hasHolyShield:Boolean = false, isStealth:Boolean = false, isCharge:Boolean = false) 
		{			
			this.isCharge = false;
			this.isStealth = false;
			this.hasHolyShield = false;
			this.isTaunt =  true;
			this.isWildFury = false;
			
			this.cardIndex = 3;
		}
		override public function battleCry() 
		{
			mainEngine.drawASpecificSkillCard(mainEngine.isYourTurn, MinionData.SOAP_INDEX);
		}

		override public function deathRattle() 
		{
			
		}
	}
	
}