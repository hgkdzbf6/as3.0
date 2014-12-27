package script.com.zbf.card {
	import flash.display.Sprite;
	import script.com.zbf.engine.CardFieldEngine;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.utils.Component;
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.utils.Draw;
	public class CardBase extends Sprite {
		
		public var cardDisplay:CardDisplay;
		public var selected:Boolean = false;
		public var mainEngine:MainEngine;
		public var cardFieldEngine:CardFieldEngine;
		public var isCanAttack:Boolean = false;
		public var HasAttacked:Boolean = false;
		public var isFreezing:Boolean = false;
		
		public function CardBase() {
			// constructor code
		}
		public function init(data:CardDisplay) {
			this.cardDisplay = data;
			this.mouseChildren = false;
			addChild(cardDisplay);
		}
		/**
		 * 新建一个随从
		 * @param	name 名称
		 * @param	health 生命值
		 * @param	attack 攻击力
		 * @param	cost 花费
		 * @param	isTaunt 嘲讽
		 * @param	isWildFury 风怒
		 * @param	HasHolyShield 圣盾
		 * @param	isStealth 潜行
		 * @param	isCharge 冲锋
		 * @return 一个新的CardBase对象
		 */
		public static function createNewMinionCard(
			cardFieldEngine:CardFieldEngine,
			name:String = "小萝莉", 
			health:int = 1, 
			attack:int = 1, 
			cost:int = 1,
			isTaunt:Boolean = false, 
			isWildFury:Boolean = false,
			HasHolyShield:Boolean = false, 
			isStealth:Boolean = false,
			isCharge:Boolean = false):CardBase {
				
			
			var card:CardBase = new CardBase();
			card.cardFieldEngine = cardFieldEngine;
			card.mainEngine = cardFieldEngine.mainEngine;
			var data:MinionData = new MinionData();
			data.init(name, health, attack, cost);
			data.setProperties(isTaunt, isWildFury, HasHolyShield, isStealth, isCharge);
			var cardData:CardData = new CardData();
			cardData.init(0, data);
			var cardDisplay:CardDisplay = new CardDisplay();
			cardDisplay.init(cardData);
			card.init(cardDisplay);
			return card;
		}	
		public static function createNewMinionCardByCardData(cardFieldEngine:CardFieldEngine,cardData:CardData):CardBase {
			var card:CardBase = new CardBase();
			var cardDisplay:CardDisplay = new CardDisplay();
			card.cardFieldEngine = cardFieldEngine;
			card.mainEngine = cardFieldEngine.mainEngine;
			cardDisplay.init(cardData);
			card.init(cardDisplay);
			return card;
		}
		public static function createNewMinionCardByMinionData(cardFieldEngine:CardFieldEngine,minionData:MinionData) {
			var card:CardBase = new CardBase();
			var cardData:CardData = new CardData();
			var cardDisplay:CardDisplay = new CardDisplay();
			card.cardFieldEngine = cardFieldEngine;
			card.mainEngine = cardFieldEngine.mainEngine;
			cardData.init(0, minionData);
			cardDisplay.init(cardData);
			card.init(cardDisplay);
			return card;
		}
		public static function createNewSkillCard(cardFieldEngine:CardFieldEngine,name:String="小萝莉",cost:int=1):CardBase {
			var card:CardBase = new CardBase();
			var data:SkillData = SkillData.createNewSkillData(cardFieldEngine.mainEngine, name, cost);
			data.init(name, cost);
			card.cardFieldEngine = cardFieldEngine;
			card.mainEngine = cardFieldEngine.mainEngine;
			var cardData:CardData = new CardData();
			cardData.init(1, data);
			var cardDisplay:CardDisplay = new CardDisplay();
			cardDisplay.init(cardData);
			card.init(cardDisplay);
			return card;
		}  
		public static function createNewSkillCardBySkillData(cardFieldEngine:CardFieldEngine, data:SkillData) {
			var card:CardBase = new CardBase();
			var cardData:CardData = new CardData();
			var cardDisplay:CardDisplay = new CardDisplay();
			card.cardFieldEngine = cardFieldEngine;
			card.mainEngine = cardFieldEngine.mainEngine;
			cardData.init(1, data);
			cardDisplay.init(cardData);
			card.init(cardDisplay);
			return card;
		}
		public function getType():int {
			return cardDisplay.data.type;
		}
		public function setPosition(px:int, py:int) {
			this.cardDisplay.setPosition(px, py);
		}
		public function setSelected(bool:Boolean) {
			selected = bool;
			if (selected) {
				this.cardDisplay.addFilter();
			}else {
				this.cardDisplay.removeAllFilters();
			}
		}
		public function getCardFieldEngineIndex():int {
			return cardFieldEngine.index;
		}
		public function getCode() {
			return cardDisplay.data.data.code;
		}
		public function getCost():int {			
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.cost;
			}else if (getType() == CardData.TYPE_SKILL) {
				return cardDisplay.data.skillData.cost;
			}
			return -1;
		}
		public function getName():String {
			if (getType() == CardData.TYPE_MINION) {
				return getMinionData().name;
			}else　if (getType() == CardData.TYPE_SKILL) {
				return getSkillData().name;
			}
			return "";
		}
		public function getTaunt():Boolean {
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.isTaunt;
			}
			trace("这不是一个随从");
			return false;
		}
		public function setTaunt(flag:Boolean) {
			if (getType() != CardData.TYPE_MINION) {
				trace("这不是一个随从");
			}
			cardDisplay.data.minionData.isTaunt = flag;
		}
		public function getWildFury():Boolean {
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.isWildFury;
			}
			trace("这不是一个随从");
			return false;
		}
		public function setWildFury(flag:Boolean) {
			if (getType() != CardData.TYPE_MINION) {
				trace("这不是一个随从");
			}
			cardDisplay.data.minionData.isWildFury= flag;
		}
		public function getHolyShield():Boolean {
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.hasHolyShield;
			}
			trace("这不是一个随从");
			return false;
		}
		public function setHolyShield(flag:Boolean) {
			if (getType() != CardData.TYPE_MINION) {
				trace("这不是一个随从");
			}
			cardDisplay.data.minionData.hasHolyShield = flag;
		}
		public function getStealth():Boolean {
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.isStealth;
			}
			trace("这不是一个随从");
			return false;
		}
		public function setStealth(flag:Boolean) {
			if (getType() != CardData.TYPE_MINION) {
				trace("这不是一个随从");
			}
			cardDisplay.data.minionData.isStealth= flag;
		}
		public function getCharge():Boolean {
			if (getType()==CardData.TYPE_MINION) {
				return cardDisplay.data.minionData.isCharge;
			}
			trace("这不是一个随从");
			return false;
		}
		public function setCharge(flag:Boolean) {
			if (getType() != CardData.TYPE_MINION) {
				trace("这不是一个随从");
			}
			cardDisplay.data.minionData.isCharge = flag;
		}
		public function decreaseCurrentHealth(val:int ) {
			getMinionData().health -= val;
			trace(getMinionData().health);
			mainEngine.minionDead(this, this.cardFieldEngine, val);
			cardDisplay.refreshAll(new Array(0,0,-1,0));
		}	
		public function addCurrentHealth(val:int) {
			cardDisplay.data.minionData.health += val;
			cardDisplay.refreshAll(new Array());
		}	
		public function setCurrentHealth(val:int) {
			cardDisplay.data.minionData.health = val;
			cardDisplay.refreshAll(new Array());
		}		
		public function setHealth(val:int) {
			cardDisplay.data.minionData.originalHealth = val;
			cardDisplay.refreshAll(new Array());
		}
		public function setAttack(val:int) {
			cardDisplay.data.minionData.attack = val;
			cardDisplay.refreshAll(new Array());
		}
		public function getHealth():int {
			return getMinionData().originalHealth;
		}		
		public function getCurrentHealth():int {
			return getMinionData().health;
		}
		public function getIndex():int {
			if (getMinionData()) {
				return getMinionData().cardIndex; 
			}else {
				return getSkillData().cardIndex;
			}
		}
		public function getAttack():int {
			return cardDisplay.minionData.originalAttack;
		}
		public function getCurrentAttack():int {
			return cardDisplay.minionData.attack;
		}
		public function getMinionData():MinionData {
			return cardDisplay.minionData;
		}		
		public function getSkillData():SkillData {
			return cardDisplay.skillData;
		}
		public function canAttack():Boolean {
			if (getMinionData() == null) {
				trace("请选择一个目标");
				return false;//不是随从返回假
			}
			if (isFreezing) {
				trace("冻结的角色无法进行攻击");
				return false;//冻结返回假
			}	
			if (HasAttacked) {
				trace("该随从已经进行过攻击了");
				return false;//攻击过返回假
			}
			if (getMinionData().isCharge) {
				//trace("");
				return true;//冲锋返回真
			}
			if (getMinionData().attack == 0) {
				trace("没有攻击力的角色无法进行攻击");
				return false;//攻击力为0返回假
			}
			if (!isCanAttack) {
				trace("在本回合放入的随从无法立刻进行攻击");
				return false;//刚放上去返回假
			}
			
			
			return aboutTaunt(!mainEngine.isYourTurn, 2) && aboutTaunt(mainEngine.isYourTurn, 1);
		}
		public function aboutTaunt(isYourTurn:Boolean,cardFieldIndex:int):Boolean {
			if (isYourTurn) {
				var array:Array = mainEngine.getCardFieldEngine(cardFieldIndex).tauntInCardField();
				if (array.length>0) {
					for (var i = 0; i < array.length; i++) {
						if (mainEngine.getCardFieldEngine(cardFieldIndex).position == i) {
							return true;
						}
					}
					trace("我必须攻击一个具有嘲讽技能的随从");
					return false;
				}
			}
			return true;
		}
		public function run() {
			if (getType() == CardData.TYPE_SKILL) {
				cardDisplay.skillData.run();
			}else if (getType() == CardData.TYPE_MINION) {
				cardDisplay.minionData.battleCry();
			}
		}
	}
	
}
