package script.com.zbf.data.default.minion
{
	import script.com.zbf.minion.MinionData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GengRuMing extends MinionData
	{
		public function GengRuMing() {
			super();
		}
		override public function init(name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1) 
		{
			this.name = "更如命";
			this.health = 7;
			this.attack = 6;
			this.cost = 1;
			this.originalAttack = 6;
			this.originalCost = 1;
			this.originalHealth = 7;	
		}
		override public function setProperties(isTaunt:Boolean = false, isWildFury:Boolean = false, hasHolyShield:Boolean = false, isStealth:Boolean = false, isCharge:Boolean = false) 
		{			
			this.isCharge = false;
			this.isStealth = false;
			this.hasHolyShield = false;
			this.isTaunt =  true;
			this.isWildFury = false;
			
			this.cardIndex=1;
		}
		override public function battleCry() 
		{
			mainEngine.dropACardRandomly(mainEngine.isYourTurn);
		}
		override public function deathRattle() 
		{
			mainEngine.drawACard(mainEngine.isYourTurn);
		}

	}
	
}