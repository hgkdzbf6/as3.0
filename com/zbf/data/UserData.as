package script.com.zbf.data
{
	import script.com.zbf.data.default.minion.GengRuMing;
	import script.com.zbf.data.default.minion.NiuXiaoRong;
	import script.com.zbf.data.default.minion.HungryJingJing;
	import script.com.zbf.data.default.skill.Coin;
	import script.com.zbf.data.default.skill.DeadlyDamage;
	import script.com.zbf.data.default.skill.Soap;
	import script.com.zbf.data.default.skill.WanJianQiFa;
	import script.com.zbf.data.default.skill.ZhaoXiang;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.skill.SkillData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class  UserData
	{
		/**
		 * 1号
		 * isEnemy:Boolean,isSkill:Boolean,name:String="小萝莉", health:int=1, attack:int=1, cost:int=1,isTaunt:Boolean = false, isWildFury:Boolean = false,HasHolyShield:Boolean=false, isStealth:Boolean=false,isCharge:Boolean=false
		 */

		
		/**
		 * 2号
		 */
		//public static const GENG_RU_MING:GengRuMing = new GengRuMing();
		public static const MA_WEN_HAO:Array = ["马文豪", 1, 2, 3, true, false, true, false, false];
		public function UserData() {
			
		}
		public static function getSkill(index:int,mainEngine:MainEngine):SkillData{
			var skillData:SkillData;
			switch(index) {
				case 1:
					skillData = new Coin();
					break;
				case 2:
					skillData = new DeadlyDamage();
					break;
				case 3:
					skillData = new ZhaoXiang();
					break;
				case 4:
					skillData = new WanJianQiFa();
					break;
				case 5:
					skillData = new Soap();
					break;
			}
			skillData.setMainEngine(mainEngine);
			skillData.init();
			skillData.cardIndex = index;
			return skillData;
		}
		public static function getMinionData(mainEngine:MainEngine,index:int):MinionData {
			var minionData:MinionData;
			minionData=getMinionData2(index);
			minionData.setMainEngine(mainEngine);
			return minionData;
	}		
	public static function getMinionData2(index:int):MinionData {
			var minionData:MinionData;
			switch(index) {
				case 1:
					minionData = new GengRuMing();
					break;
				case 2:
					minionData = new NiuXiaoRong();
					break;		
				case 3:
					minionData = new HungryJingJing();
					break;
			}
			minionData.init();
			minionData.setProperties();
			return minionData;
		}
	}
}
