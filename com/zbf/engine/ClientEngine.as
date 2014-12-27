package script.com.zbf.engine
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.errors.IOError;
	import script.com.zbf.card.CardDisplay;
	import script.com.zbf.card.CardFieldClient;
	import script.com.zbf.card.CardData;
	import script.com.zbf.data.UserData
	import script.com.zbf.interfac.IReceiveMessage;
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.net.MySocket;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.ui.CardClient;
	import script.com.zbf.ui.CommandButtonGroup;
	import script.com.zbf.ui.Crystal;
	import script.com.zbf.utils.Component;
	import script.com.zbf.utils.Console;
	import script.com.zbf.utils.MessageBox;
	import script.com.zbf.utils.Move;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ClientEngine extends Engine implements IReceiveMessage
	{
		public var codes:Array;
		public var cardFields:Vector.<CardFieldClient>;
		public var commandEngine:CommandEngine;
		public var crystalEngines:Vector.<CrystalEngine>
		public var characterEngines:Vector.<CharacterEngine>
		public var commandButtonGroup:CommandButtonGroup;
		public var socket:MySocket;
		public var console:Console;
		public var messageBox:MessageBox;
		
		public var isYourTurn:Boolean=false;
		//public var stage:Sprite;
		public function ClientEngine() {
			
		}
		public static function createNewClientEngine(stage:Sprite) {
			var clientEngine:ClientEngine = new ClientEngine();
			clientEngine.stage = stage;
			clientEngine.commandEngine = CommandEngine.createNewCommandEngine(clientEngine);
			clientEngine.init();
			clientEngine.openSocket();
			return clientEngine;
		}
		public function init() {
			codes = new Array()
			cardFields = new Vector.<CardFieldClient>;
			console = Console.createNewConsole();
			messageBox = MessageBox.createNewMessageBox(console);
			messageBox.runnable = commandEngine;
			pushNewCardField();
			pushNewCardField();
			pushNewCardField();
			pushNewCardField();
			crystalEngines = new Vector.<CrystalEngine>;
			crystalEngines.push(CrystalEngine.createNewCrystalEngine(this));
			crystalEngines.push(CrystalEngine.createNewCrystalEngine(this));
			characterEngines = new Vector.<CharacterEngine>;
			characterEngines.push(CharacterEngine.createNewCharacterEngine(this, false));
			characterEngines.push(CharacterEngine.createNewCharacterEngine(this, true));
			commandButtonGroup = CommandButtonGroup.createNewCommandButtonGroup(["攻击", "出牌", "回合结束"]);
			addCmdFunctions();
		}
		public function openSocket() {
			socket = new MySocket();
			socket.receiver = this;
		}
		public function pushNewCardField() {
			var cardDisplays:Vector.<CardDisplay> = new Vector.<CardDisplay>;
			var len:int = cardFields.length;
			cardFields.push(CardFieldClient.createNewCardField(cardDisplays, this));
			cardFields[cardFields.length - 1].index = cardFields.length - 1;
		}
		public function newCardFromUserData(type:int,data:Component) {
			var cardDisplay:CardDisplay = new CardDisplay();
			cardDisplay.init(CardData.createNewCardData(type, data));
		}
		public function getCardField(index:int):CardFieldClient {
			return cardFields[index];
		}
		public function addCmdFunction(cmdIndex:int, func:Function) //添加按钮功能
		{
			addListener(MouseEvent.CLICK, func);
			addToStage(cmdIndex, commandButtonGroup.commandButtons[cmdIndex]);
		}
		public function addSelectFunction(cardFieldIndex:int, func:Function) {
			addListener(MouseEvent.CLICK, func);
			//加三
			addToStage(cardFieldIndex+3, getCardField(cardFieldIndex));
		}

		public function addCmdFunctions() {
			addCmdFunction(0, onAttack);
			addCmdFunction(1, onDeal);
			addCmdFunction(2, onEnd);
			getCardField(0).addClickFunction();
			getCardField(1).addClickFunction();
			getCardField(2).addClickFunction();
			getCardField(3).addClickFunction();
			getCharacterEngine(0).addClickListener2();
			getCharacterEngine(1).addClickListener2();
		}
		public function onAttack(e:Event=null) {
			trace("攻击键");
		}		
		public function onDeal(e:Event=null) {
			trace("出牌键");
			sendOnAttack();
		}		
		public function onEnd(e:Event=null) {
			trace("结束键");
		}
		/***************************************************主要方法*********************************************************/
		/**
		 * 1 新建一张卡
		 * 2 移动一张卡
		 * 3 为一张卡改数
		 * 
		 * 
		 */
		public function newCard(cardType:int,cardIndex:int,cardFieldClientIndex:int, code:int) {
			var cardDisplay:CardDisplay;
			if (isCodeInCodes(code)) {
				return;
			}
			if (cardType == CardData.TYPE_MINION) {
				var minionData:MinionData = UserData.getMinionData2(cardIndex);
				minionData.code = code;
				cardDisplay = CardDisplay.createNewCardDisplay(CardData.createNewCardData(CardData.TYPE_MINION,minionData));
			}else {
				var skillData:SkillData = UserData.getSkill(cardIndex, null);
				skillData.code = code;
				cardDisplay = CardDisplay.createNewCardDisplay(CardData.createNewCardData(CardData.TYPE_SKILL,skillData));
			}
			codes.push(code);
			getCardField(cardFieldClientIndex).addCardByCardDisplay(cardDisplay);
		}
		public function isCodeInCodes(code:int):Boolean {
			for (var i = 0; i < codes.length; i++) {
				if (code == codes[i]) return true;
			}
			return false;
		}
		public function removeCodeFromCodes(code:int) {
			for (var i = 0; i < codes.length; i++) {
				if (code == codes[i]) {
					codes.splice(i, 1);
				}
			}
		}
		public function addCodeToCodes(code:int) {
			if (isCodeInCodes(code)) return; 
			codes.push(code);
		}
		public function dropCard(cardFieldIndex:int, cardCode:int):CardDisplay {
			removeCodeFromCodes(cardCode);
			return getCardField(cardFieldIndex).removeCardByCardCode(cardCode);
		}
		public function moveCard(cardFieldIndex:int, cardCode:int, to:int) {
			var card:CardDisplay = getCardField(cardFieldIndex).popCardByCode(cardCode);
			getCardField(to).addCardByCardDisplay(card);
		}
		public function setAllCardFieldClickable(isYou:Boolean) {
				getCardField(0).isClickable = false;
				getCardField(1).isClickable = isYou;
				getCardField(2).isClickable = isYou;
				getCardField(3).isClickable = isYou;
				//自己可以操作自己的牌，自己场上的随从，以及敌人场上的随从
				//别人的回合什么都不能做
		}
		public function setCommandEnabled(isTrue:int) {
			var isYourTurn:Boolean;
			if (isTrue == 0) {
				isYourTurn = false;
			}else {
				isYourTurn = true;
			}
			commandButtonGroup.setAllCommandButtonEnabled(new Array(isYourTurn, isYourTurn , isYourTurn));
			this.isYourTurn = isYourTurn;
			setAllCardFieldClickable(isYourTurn);
		}
		public function initCommands() {
			addAndMove();			
		}
		public function refreshCrystal(isYou:int, available:int, unavailable:int) {
			getCrystalEngine(isYou).setCrystalNum(available, unavailable);
		}
		public function getCrystal(index:int):Crystal {
			return crystalEngines[index].crystal;
		}
		public function getCrystalEngine(index:int):CrystalEngine {
			return crystalEngines[index];
		}
		public function getCharacterEngine(index:int):CharacterEngine {
			return characterEngines[index];
		}
		public function getCharacter(index:int) {
			return characterEngines[index].character;
		}
		public function addAndMove() {
			Move.addAndSetposition(commandButtonGroup, stage, 796, 86);
			Move.addAndSetposition(getCrystal(0),stage, 683, 57);
			Move.addAndSetposition(getCrystal(1),stage, 683, 453);
			Move.addAndSetposition(getCharacter(0), stage, 683, 80);
			Move.addAndSetposition(getCharacter(1), stage, 683, 347);
			Move.addAndSetposition(getCardField(0),stage, 0, 0);
			Move.addAndSetposition(getCardField(1), stage,0, 150);
			Move.addAndSetposition(getCardField(2), stage,0, 300);
			Move.addAndSetposition(getCardField(3), stage,0, 450);
			Move.addAndSetposition(console, stage, 150, 100);
			Move.addAndSetposition(messageBox, stage,  150, 300);
		}
		public function receive(msg:String) {
			commandEngine.run(msg);
			console.T(msg);
		}	
		public function sendCommand(cmd:String)
		{
			try
			{
				socket.writeData(cmd);
			}
			catch (e:IOError)
			{
				trace("不能对无效的socket进行操作");
			}
		}
		public function sendOnAttack() {
			var command:String;
			command = CommandEngine.createNewCommand(
				CommandEngine.ON_ATTACK,
				getCardField(3).position
				);
			sendCommand(command);
		}
		public function sendOnSelectCard(cardFieldIndex:int) {
			var command:String;
			command = CommandEngine.createNewCommand(
				CommandEngine.SET_SELECT_CARD,
				cardFieldIndex,
				getCardField(cardFieldIndex).position);
			sendCommand(command);
		}
	}
}