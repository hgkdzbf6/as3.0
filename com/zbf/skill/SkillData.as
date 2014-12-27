package script.com.zbf.skill
{
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.utils.Component;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SkillData extends Component
	{
		public var cardIndex:int;
		private var _name:String;
		private var _cost:int;
		public var mainEngine:MainEngine;
		
		/**
		 *
		 */
		public function SkillData()
		{
			super();
		}
		
		public static function createNewSkillData(mainEngine:MainEngine, name:String, cost:int):SkillData
		{
			var skillData:SkillData = new SkillData();
			skillData.setMainEngine(mainEngine);
			skillData.init(name, cost);
			return skillData;
		}
		
		public function setMainEngine(mainEngine:MainEngine) {
			this.mainEngine = mainEngine;
		}
		public function init(name:String="硬币", cost:int=0)
		{
			this.name = name;
			this.cost = cost;
		}
		
		override public function getType():int
		{
			return 1;
		}
		
		public function run()
		{
			effect();
		}
		
		public function effect()
		{
			if (mainEngine.isYourTurn)
			{
				mainEngine.yourCurrentCrystalNum++;
			}
			else
			{
				mainEngine.enemyCurrentCrystalNum++;
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function set cost(value:int):void 
		{
			_cost = value;
		}
	}

}