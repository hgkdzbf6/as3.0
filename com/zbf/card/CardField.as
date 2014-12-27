package script.com.zbf.card
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import script.com.zbf.card.CardData;
	import script.com.zbf.engine.CardFieldEngine;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.minion.MinionData;
	
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class CardField extends Sprite 
	{
		var cardFieldEngine:CardFieldEngine;
		var mainEngine:MainEngine;
		public var cards:Vector.<CardBase> = new Vector.<CardBase>;
		public function CardField() {

		}
		public static function createNewCardField(cardFieldEngine:CardFieldEngine):CardField {
			var cardField:CardField = new CardField();
			cardField.mainEngine = cardFieldEngine.mainEngine;
			cardField.cardFieldEngine = cardFieldEngine;
			cardField.init();
			return cardField;
		}		
		public static function createNewCardField2(cardFieldEngine:CardFieldEngine):CardField {
			var cardField:CardField = new CardField();
			cardField.mainEngine = cardFieldEngine.mainEngine;
			cardField.cardFieldEngine = cardFieldEngine;
			return cardField;
		}	
		public function init() {
			var card:CardBase = CardBase.createNewMinionCard(cardFieldEngine,"大傻逼", 2, 2, 2, true, true,true,true,true);
			var card2:CardBase = CardBase.createNewSkillCard(cardFieldEngine);
			cards.push(card);
			cards.push(card2);
			arrangeCards();
			showCards();
		}

		public function arrangeCards(e:Event=null) {
			var length:int = cards.length;
			//trace("cards的长度"+cards.length);
			for (var i = 0; i < length; i++) {
				cards[i].setPosition(i * 100, 0);
			}
		}
		public function showCards() {
			var length:int=cards.length;
			for (var i = 0; i < length; i++) {
				addChild(cards[i]);
			}
		}
		/***************************
		public function addListener(stage:Object) {
			mouseEnabled = false;
			stage.addEventListener(MouseEvent.CLICK, onClickEvent);
		}
		public function onClickEvent(e:Event) {
			var card:CardBase = e.target as CardBase;
			if (!card) return;
			for (var i = 0; i < cards.length; i++ ) {
				cards[i].setSelected(false);
				if (cards[i] === card) {
					position = i;
				}
			}
			if(position>=0){
				cards[position].setSelected(true);
			}
		}
		/***********************************/

		public function popCard(index:int = -1,to:int=-1):CardBase {
			if (!cards||cards.length==0) {
				return null;
			}
			var card:CardBase = cards.splice(index, 1)[0];
			if (to != -1) {
				card.cardFieldEngine = mainEngine.getCardFieldEngine(to);
			}
			return card;
		}
		public function addCardByCardBase(card:CardBase) {
			cards.push(card);
			arrangeCards();
			showCards();
		}
		public function addCardByCardData(cardData:CardData) {
			var card:CardBase = CardBase.createNewMinionCardByCardData(cardFieldEngine,cardData);
			cards.push(card);
			arrangeCards();
			showCards();
		}
		public function addCard(
			name:String = "小萝莉", 
			health:int = 1, 
			attack:int = 1, 
			cost:int = 1,
			isTaunt:Boolean = false, 
			isWildFury:Boolean = false,
			HasHolyShield:Boolean = false, 
			isStealth:Boolean = false,
			isCharge:Boolean = false) {
			cards.push(CardBase.createNewMinionCard(cardFieldEngine,name, health, attack, cost, isTaunt, isWildFury, HasHolyShield, isStealth, isCharge));
			arrangeCards();
			showCards();
		}
	}
}