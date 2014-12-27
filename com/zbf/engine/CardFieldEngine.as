package script.com.zbf.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import script.com.zbf.card.CardData;
	import script.com.zbf.engine.Engine;
	import script.com.zbf.card.CardField;
	import script.com.zbf.card.CardBase;
	import flash.system.System;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CardFieldEngine extends Engine
	{
		public static const CARD_INTO_CARDFIELD:String = "cardIntoCardField";
		public static const CARD_OUT_CARDFIELD:String = "cardOutCardField"
		public var cardField:CardField;
		public var mainEngine:MainEngine;
		//public var stage:Object;
		
		public var isAttackSource:Boolean = false;
		public var isAttackTarget:Boolean = false;
		
		public var index:int; //在mainEngine中的序号
		public var position:int = -1;
		public var isClickEnabled:Boolean = true;
		
		public function CardFieldEngine()
		{
		
		}
		
		public function getCardNum():int
		{
			return cardField.cards.length;
		}
		
		public function addClickListener(stage:Object)
		{
			cardField.mouseEnabled = false;
			stage.addEventListener(MouseEvent.CLICK, onClickEvent);
		}
		
		public function setClickEnabled(bool:Boolean)
		{
			isClickEnabled = bool;
		}
		public function onSelectCard(position:int) {
			if (!isClickEnabled)
				return;
			refreshCards();
			cardField.cards[position].setSelected(true);
		}
		public function onClickEvent(e:Event)
		{
			if (!isClickEnabled)
				return;
			var card:CardBase = e.target as CardBase;
			if (!card)
				return;
			for (var i = 0; i < cardField.cards.length; i++)
			{
				cardField.cards[i].setSelected(false);
				if (cardField.cards[i] === card)
				{
					position = i;
				}
			}
			if (position >= 0)
			{
				cardField.cards[position].setSelected(true);
				if (mainEngine.isYourTurn)
				{
					mainEngine.getCharacterEngine(0).setSelected(false);
				}
				else
				{
					mainEngine.getCharacterEngine(1).setSelected(false);
				}
			}
		}
		
		public static function createNewCardFieldEngine(mainEngine:MainEngine):CardFieldEngine
		{
			var cardFieldEngine:CardFieldEngine = new CardFieldEngine();
			cardFieldEngine.mainEngine = mainEngine;
			cardFieldEngine.init(CardField.createNewCardField(cardFieldEngine), mainEngine.stage);
			return cardFieldEngine;
		}
		
		public static function createNewCardFieldEngine2(mainEngine:MainEngine, cards:Vector.<CardData> = null):CardFieldEngine
		{
			var cardFieldEngine:CardFieldEngine = new CardFieldEngine();
			cardFieldEngine.mainEngine = mainEngine;
			cardFieldEngine.stage = mainEngine.stage;
			cardFieldEngine.init(CardField.createNewCardField2(cardFieldEngine), mainEngine.stage);
			cardFieldEngine.createNewCards(cards);
			return cardFieldEngine;
		}
		
		public function tauntInCardField():Array
		{
			var array:Array = new Array();
			for (var i = 0; i < cardField.cards.length; i++)
			{
				if (cardField.cards[i].getTaunt())
				{
					array.push(i);
				}
			}
			return array;
		}
		
		public function createNewCards(cards:Vector.<CardData>)
		{
			if (!cards)
				cards = new Vector.<CardData>;
			for (var i = 0; i < cards.length; i++)
			{
				createNewCard(cards[i]);
			}
		}
		
		public function createNewCard(cardData:CardData)
		{
			cardField.addCardByCardData(cardData);
		}
		
		public function init(cardField:CardField, stage:Sprite)
		{
			this.cardField = cardField;
			this.stage = stage;
			//addListener(CARD_INTO_CARDFIELD, onCardIntoCardField);
		}
		
		public function onCardIntoCardField(e:Event = null)
		{
			cardField.init();
		}
		
		public function getCard(index:int = -1):CardBase
		{
			if (index == -1 && position >= 0)
			{
				return cardField.cards[position];
			}
			else if (index == -1 && position < 0)
			{
				return null;
			}
			if (cardField.cards.length > index)
			{
				var card:CardBase = cardField.cards[index];
				return card;
			}
			return null;
		}
		
		public function popCard(index:int = -1, to:int = -1):CardBase
		{
			var card:CardBase;
			if (index == -1 && position >= 0)
			{
				card = cardField.popCard(position, to);
				cardField.arrangeCards();
				return card;
			}
			card = cardField.popCard(index, to);
			position = -1;
			cardField.arrangeCards();
			return card;
		}
		
		public function addCard(_name:String = "小萝莉", health:int = 1, attack:int = 1, cost:int = 1, isTaunt:Boolean = false, isWildFury:Boolean = false, HasHolyShield:Boolean = false, isStealth:Boolean = false, isCharge:Boolean = false)
		{
			cardField.addCard(_name, health, attack, cost, isTaunt, isWildFury, HasHolyShield, isStealth, isCharge);
		}
		
		public function addCards(cards:Vector.<CardBase>)
		{
			if (!cards)
				return;
			for (var i = 0; i < cards.length; i++)
			{
				addCardByCardBase(cards[i]);
			}
		}
		
		public function addCardByCardBase(card:CardBase)
		{
			if (!card)
				return;
			position = -1;
			cardField.arrangeCards();
			card.setSelected(false);
			refreshCards();
			cardField.addCardByCardBase(card);
			mainEngine.sendNewCardCmd(card);
		}
		
		public function refreshCards()
		{
			position = -1;
			for (var i = 0; i < cardField.cards.length; i++)
			{
				cardField.cards[i].setSelected(false);
			}
			cardField.arrangeCards();
		}
		
		public function arrangeCards(e:Event = null)
		{
			cardField.arrangeCards(e);
		}
		
		public function destroyCard(index:int = -1)
		{
			if (index == -1)
			{
				var card:CardBase = popCard();
				card.setSelected(false);
				position = -1;
				cardField.removeChild(card);
				arrangeCards();
			}
		}
		
		public function destroyMinion(index:int = -1)
		{
			if (index == -1)
			{
				var card:CardBase = popCard();
				card.setSelected(false);
				position = -1;
				if (card.getType() == CardData.TYPE_MINION)
				{
					card.getMinionData().deathRattle();
				}
				cardField.removeChild(card);
				arrangeCards();
			}
		}
	}

}