package script.com.zbf.card {
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.utils.Component;
	
	public class CardData {
		public static const TYPE_SKILL:int = 1;
		public static const TYPE_MINION:int = 0;
		
		private var _type:int = 0;
		public var data:Component;
		public var minionData:MinionData;
		public var skillData:SkillData;
		
		public function CardData() {
			// constructor code
		}
		public static function createNewCardData(type:int,data:Component) {
			var cardData:CardData = new CardData();
			cardData.init(type,data);
			return cardData;
		}
		public function init(type:int,data:Component) {
			setData(type, data);
			_type = type;
		}
		public function setData(type:int, data:Component) {
			this.data = data;
			if (type == TYPE_MINION) {
				minionData = data as MinionData;
			}else if(type==TYPE_SKILL){
				skillData = data as SkillData;
			}
		}
		public function getData():Component {
			return data;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			_type = value;
		}

	}
	
}
