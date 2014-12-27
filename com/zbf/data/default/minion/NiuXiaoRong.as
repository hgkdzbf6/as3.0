package script.com.zbf.data.default.minion
{
	import script.com.zbf.minion.MinionData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class NiuXiaoRong extends MinionData
	{
		public function NiuXiaoRong() {
			super();
		}
		override public function init(name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1) 
		{
			this.name = "牛笑容";
			this.health = 1;
			this.attack = 5;
			this.cost = 3;
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
			this.cardIndex = 2;
		}
		override public function battleCry() 
		{
			mainEngine.drawACard(mainEngine.isYourTurn);
		}
		override public function deathRattle() 
		{
			mainEngine.drawACard(mainEngine.isYourTurn);
		}

	}
	
}