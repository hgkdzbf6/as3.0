package script.com.zbf.minion
{
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.utils.Component;
	import script.com.zbf.utils.MyData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MinionData extends Component
	{
		public static const COIN_INDEX:int = 1;
		public static const DEADLY_DAMAGE_INDEX:int = 2;
		public static const ZHAO_XIANG_INDEX:int = 3;
		public static const WANJIANQIFA_INDEX:int = 4;
		public static const SOAP_INDEX:int = 5;
		
		
		public  var cardIndex:int;
		
		public var mainEngine:MainEngine;
		public var name:String = "小萝莉";
		public var description:String = "";
		private var _health:int = 1;
		public var attack:int = 1;
		public var cost:int = 1;
		public var originalHealth:int = 1;
		public var originalAttack:int = 1;
		public var originalCost:int = 1;
		
		public var isTaunt:Boolean = false;
		public var isWildFury:Boolean = false;
		public var hasHolyShield:Boolean = false;
		public var isStealth:Boolean = false;
		public var isCharge:Boolean = false;
		
		public function MinionData()
		{
			super();
		}
		
		public function writeDescription(str:String)
		{
			description = str;
		}
		
		public static function createNewMinionData(name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1, isTaunt:Boolean = false, isWildFury:Boolean = false, HasHolyShield:Boolean = false, isStealth:Boolean = false, isCharge:Boolean = false):MinionData
		{
			var minionData:MinionData = new MinionData();
			minionData.init(name, health, attack, cost);
			minionData.setProperties(isTaunt, isWildFury, HasHolyShield, isStealth, isCharge);
			return minionData;
		}
		
		public function setMainEngine(mainEngine:MainEngine)
		{
			this.mainEngine = mainEngine;
		}
		
		public function init(name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1)
		{
			this.name = name;
			this.health = health;
			this.attack = attack;
			this.cost = cost;
			this.originalAttack = attack;
			this.originalCost = cost;
			this.originalHealth = health;
		}
		
		/**
		 * 设置特性
		 * @param	isTaunt 嘲讽
		 * @param	isWildFury 风怒
		 * @param	HasHolyShield 圣盾
		 * @param	isStealth 潜行
		 * @param	isCharge 冲锋
		 */
		public function setProperties(isTaunt:Boolean = false, isWildFury:Boolean = false, hasHolyShield:Boolean = false, isStealth:Boolean = false, isCharge:Boolean = false)
		{
			this.isCharge = isCharge;
			this.isStealth = isStealth;
			this.hasHolyShield = hasHolyShield;
			this.isTaunt = isTaunt;
			this.isWildFury = isWildFury;
		}
		
		public function toString():String
		{
			return "name=" + name + ",health=" + health + ",attack=" + attack + "cost=" + cost;
		}
		
		public function effect()
		{
		
		}
		
		/**
		 * 此方法用来继承
		 */
		public function battleCry()
		{
		
		}
		
		/**
		 * 亡语
		 */
		public function deathRattle()
		{
		
		}
		
		/**
		 * 激怒
		 */
		public function enrage()
		{
		
		}
		
		override public function getType():int
		{
			return 0;
		}
		
		public function get health():int
		{
			return _health;
		}
		
		public function set health(value:int):void
		{
			_health = value;
		}
		
	
	}

}