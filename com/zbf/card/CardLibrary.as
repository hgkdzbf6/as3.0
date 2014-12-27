package script.com.zbf.card
{
	import script.com.zbf.card.CardBase;
	import script.com.zbf.engine.CardFieldEngine;
	import script.com.zbf.engine.MainEngine;
	/**
	 * ...
	 * @author ...
	 */
	public class CardLibrary  
	{
		public var cards:Vector.<CardBase>;
		public var mainEngine:MainEngine;
		public var cardFieldEngine:CardFieldEngine;
		public static function createNewCardLibrary(cardFieldEngine:CardFieldEngine) {
			var cardLibrary:CardLibrary = new CardLibrary();
			cardLibrary.cardFieldEngine = cardFieldEngine;
			cardLibrary.mainEngine = cardFieldEngine.mainEngine;
			cardLibrary.init();
			cardLibrary.addCard(CardBase.createNewMinionCard(cardFieldEngine));
			cardLibrary.addCard(CardBase.createNewMinionCard(cardFieldEngine,"大傻逼",9,0,3));
			return cardLibrary;
		}
		public static function createNewCardLibrary2(cardFieldEngine:CardFieldEngine,cards:Vector.<CardData> = null) {
			var cardLibrary:CardLibrary = new CardLibrary();
			cardLibrary.cardFieldEngine = cardFieldEngine;
			cardLibrary.mainEngine = cardFieldEngine.mainEngine;
			cardLibrary.init();
			if(cards){
				for (var i = 0; i < cards.length; i++) {
					cardLibrary.cards.push(CardBase.createNewMinionCardByCardData(cardFieldEngine,cards[i]));
				}
			}
			return cardLibrary;
		}
		public function CardLibrary() {
			
		}
		public function init() {
			cards = new Vector.<CardBase>;
		}
		public function addCard(card:CardBase) {
			cards.push(card);
		}
		public function popCardsRandomly(num:int):Vector.<CardBase> {
			cards.sort(sortCards);
			return cards.splice(cards.length-num , num);
		}
		private function sortCards(card1:CardBase,card2:CardBase):Number {
			if (Math.random() - 0.5 > 0) {
				return -1;
			}
			return 1;
		}
		public function popCards(num:int):Vector.<CardBase> {
			return cards.splice(cards.length-num , num);
		}
		public function popCard(index:int=-1):CardBase {
			return cards.splice(index, 1)[0];
		}
	}
	
}