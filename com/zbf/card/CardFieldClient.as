package script.com.zbf.card
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import script.com.zbf.card.CardDisplay;
	import script.com.zbf.engine.ClientEngine;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class CardFieldClient extends Sprite 
	{
		public var clientEngine:ClientEngine;
		public var cardDisplays:Vector.<CardDisplay>;
		public var index:int;
		public var position:int = -1;
		public var isClickable:Boolean = false;
		public function CardFieldClient() {
			
		}
		public static function createNewCardField(cardDisplays:Vector.<CardDisplay>
			,clientEngine:ClientEngine):CardFieldClient {
			var cardField:CardFieldClient = new CardFieldClient();
			cardField.clientEngine = clientEngine;
			cardField.init();
			return cardField;
		}
		
		public function init() {
			cardDisplays = new Vector.<CardDisplay>;
		}
		public function checkCards() {
			var flag:Boolean = false;
			for (var i = 0; i < cardDisplays.length; i++) {
				if (cardDisplays[i] == null) {
					cardDisplays.splice(i, 1);
					flag = true;
					break;
				}
			}
			if (flag) checkCards();
		}
		public function arrangeCards(e:Event = null) {
			checkCards();
			if (cardDisplays.length == 0) return;
			for (var i = 0; i < cardDisplays.length; i++) {
				cardDisplays[i].setPosition(i * 100, 0);
			}
		}
		public function showCards() {
			var length:int = cardDisplays.length;
			for (var i = 0; i < length; i++) {
				addChild(cardDisplays[i]);
			}
		}
		public function popCard(index:int = -1):CardDisplay {
			var card:CardDisplay=cardDisplays.splice(index, 1)[0];
			return card;
		}
		public function popCardByCode(code:int):CardDisplay {
			var card:CardDisplay;
			//if (cardDisplays.length == 0) return null;
			for (var i = 0; i < cardDisplays.length; i++) {
				card = cardDisplays[i];
				if (card.getCode() == code) {
					card = cardDisplays.splice(i, 1)[0];
					break;
				}
			}
			return card;
		}
		public function addCardByCardDisplay(card:CardDisplay) {
			cardDisplays.push(card);
			addChild(card);
			arrangeCards();
			showCards();
		}
		public function removeCardByCardCode(code:int):CardDisplay {
			var card:CardDisplay;
			for (var i = 0; i < cardDisplays.length; i++) {
				card = cardDisplays[i];
				if (card.getCode() == code) {
					removeChild(card);
					cardDisplays.splice(i, 1);
					arrangeCards();
					showCards();
				}
			}
			return card;
		}
		public function resetPosition() {
			position = -1;
		}
		public function removeAllFilter() {//删除所有滤镜
			for (var i = 0; i < cardDisplays.length; i++) {
				Draw.removeAllFilters(cardDisplays[i]);
			}
			resetPosition();
		}
		
		public function onSelectCard(e:MouseEvent) {
			var card:CardDisplay = e.target as CardDisplay;
			if (!card) return;
			if (!isClickable) return;
			setSelectedByCode(card.getCode());
			
		}
		public function addClickFunction() {
			this.mouseEnabled = false;
			this.addEventListener(MouseEvent.CLICK, onSelectCard);
		}
		public function setSelectedByCode(code:int) {
			removeAllFilter();//删除所有滤镜
			for (var i = 0; i < cardDisplays.length; i++) {
				if (cardDisplays[i].getCode() == code) {
					var card:CardDisplay = cardDisplays[i];
					Draw.addFilter(card, 1);
					position = i;
					clientEngine.sendOnSelectCard(this.index);
					break;
				}
			}
		}
		public function refreshAllCards() {
			removeAllFilter();
			arrangeCards();
			showCards();
		}
	}
}