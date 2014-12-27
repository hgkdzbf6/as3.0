package script.com.zbf.engine
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.errors.IOError;
	import script.com.zbf.card.CardBase;
	import script.com.zbf.card.CardData;
	import script.com.zbf.card.CardField;
	import script.com.zbf.character.Character;
	import script.com.zbf.data.UserData;
	import script.com.zbf.engine.Engine;
	import script.com.zbf.interfac.IReceiveMessage;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.ui.CommandButtonGroup;
	import flash.events.MouseEvent;
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.card.CardLibrary;
	import script.com.zbf.engine.CrystalEngine;
	import script.com.zbf.ui.Crystal;
	import script.com.zbf.utils.Component;
	import script.com.zbf.utils.Console;
	import script.com.zbf.net.MySocket;
	import script.com.zbf.utils.Move;
	
	/**
	 * 设计思路
	 * 关于全局的侦听器都放在MainEngine中
	 * 关于点击事件的侦听器放在Stage中
	 * MainEngine负责接收事件，然后发出事件
	 * @author ...
	 */
	public class MainEngine extends Engine implements IReceiveMessage
	{
		//public var stage:Sprite;
		public var cardFieldEngines:Vector.<CardFieldEngine>;
		public var commandButtonGroup:CommandButtonGroup;
		public var cardLibrarys:Vector.<CardLibrary>;
		public var characterEngines:Vector.<CharacterEngine>;
		public var crystalEngines:Vector.<CrystalEngine>;
		public var c:Console;
		public static const EVENT_STATE_CHANGE:String = "stateChange";
		public var state:String = "init";
		public var isYourTurn:Boolean = true;
		public var socket:MySocket;
		private var _yourCrystalNum:int = 0;
		private var _yourCurrentCrystalNum:int;
		private var commandEngine:CommandEngine;
		private var _enemyCrystalNum:int = 0;
		private var _enemyCurrentCrystalNum:int;
		/**
		 * 事件名称:初始化
		 * 此时刚进入游戏，分发起手牌和扔硬币
		 */
		public static const EVENT_INIT:String = "init";
		/**
		 * 分发起手牌
		 */
		public static const EVENT_BEFORE_THROW_COIN:String = "beforeThrowCoin";
		/**
		 * 扔硬币
		 */
		public static const EVENT_THROW_COIN:String = "throwCoin";
		/**
		 * 换牌
		 */
		public static const EVENT_AFTER_THROW_COIN:String = "afterThrowCoin";
		/**
		 * 你的回合
		 */
		public static const EVENT_YOUR_TURN:String = "yourTurn";
		/**
		 * 敌人的回合
		 */
		public static const EVENT_ENEMY_TURN:String = "enemyTurn";
		public static const EVENT_YOUR_TURN_END:String = "yourTurnEnd";
		public static const EVENT_ENEMY_TURN_END:String = "enemyTurnEnd";
		
		public function MainEngine()
		{
		
		}
		
		public static function createNewMainEngine(stage:Sprite):MainEngine
		{
			var mainEngine:MainEngine = new MainEngine();
			mainEngine.stage = stage;
			mainEngine.cardFieldEngines = new Vector.<CardFieldEngine>;
			mainEngine.cardLibrarys = new Vector.<CardLibrary>;
			mainEngine.characterEngines = new Vector.<CharacterEngine>;
			mainEngine.crystalEngines = new Vector.<CrystalEngine>;
			mainEngine.commandEngine = CommandEngine.createNewCommandEngine(mainEngine);
			
			mainEngine.cardFieldEngines.push(CardFieldEngine.createNewCardFieldEngine2(mainEngine));
			mainEngine.cardFieldEngines.push(CardFieldEngine.createNewCardFieldEngine2(mainEngine));
			mainEngine.cardFieldEngines.push(CardFieldEngine.createNewCardFieldEngine2(mainEngine));
			mainEngine.cardFieldEngines.push(CardFieldEngine.createNewCardFieldEngine2(mainEngine));
			mainEngine.setIndexToCardFieldEngine();
			mainEngine.cardLibrarys.push(CardLibrary.createNewCardLibrary2(mainEngine.getCardFieldEngine(1)));
			mainEngine.cardLibrarys.push(CardLibrary.createNewCardLibrary2(mainEngine.getCardFieldEngine(2)));
			//为自己加入随从
			mainEngine.addInitialCardsIntoCardLibrary(true, false, [1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]);
			//为敌人加入随从
			mainEngine.addInitialCardsIntoCardLibrary(false, false, [1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]);
			//为自己加入法术
			mainEngine.addInitialCardsIntoCardLibrary(true, true, [1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]);
			//为敌人加入法术
			mainEngine.addInitialCardsIntoCardLibrary(false, true, [1, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3]);
			
			mainEngine.characterEngines.push(CharacterEngine.createNewCharacterEngine(mainEngine, false));
			mainEngine.characterEngines.push(CharacterEngine.createNewCharacterEngine(mainEngine, true));
			
			mainEngine.crystalEngines.push(CrystalEngine.createNewCrystalEngine(mainEngine));
			mainEngine.crystalEngines.push(CrystalEngine.createNewCrystalEngine(mainEngine));
			
			mainEngine.commandButtonGroup = CommandButtonGroup.createNewCommandButtonGroup(["敌人出牌", "敌人取消", "敌人攻击", "自己攻击", "自己取消", "自己出牌"]);
			mainEngine.init(stage);
			return mainEngine;
		}
		public function addInitialCardsIntoCardLibrary(isYou:Boolean, isSkill:Boolean, array:Array) {
			for (var i = 0; i < array.length;i++){
				if (isSkill) {
					this.addSkillCardsIntoCardLibrary(!isYou, array[i]);
				}else {
					this.addCardIntoCardLibrary(!isYou, array[i]);
				}
			}
		}
		public function setIndexToCardFieldEngine()
		{
			for (var i = 0; i < cardFieldEngines.length; i++)
			{
				cardFieldEngines[i].index = i;
			}
		}
		
		public function controlAMinion(yourToEnemy:Boolean)
		{
			if (yourToEnemy)
			{
				getCardFieldEngine(1).addCardByCardBase(getCardFieldEngine(2).popCard(-1, 1));
			}
			else
			{
				getCardFieldEngine(2).addCardByCardBase(getCardFieldEngine(1).popCard(-1, 2));
			}
		}
		
		public function addSkillCardsIntoCardLibrary(isEnemy:Boolean, index:int)
		{
			addSkillCardIntoCardLibrary(isEnemy, UserData.getSkill(index, this));
		}
		
		public function addCardIntoCardLibrary(isEnemy:Boolean,  index:int)
		{
			pushCardIntoCardLibrary(isEnemy, false, UserData.getMinionData(this, index));
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
		
		public function sendInitCmd()
		{
			var command:String;
			command = CommandEngine.createNewCommand(CommandEngine.INIT);
			//命令格式：INIT::
			sendCommand(command);
		}
		public function sendNewCardCmd(card:CardBase) {			
			var command:String;
			command=CommandEngine.createNewCommand(
					CommandEngine.NEW_CARD,
					card.getType(),
					card.getIndex(),
					card.getCardFieldEngineIndex(),
					card.getCode()
				);
			//命令格式：NEW_CARD::CARD_TYPE(随从还是法术)##CARD_INDEX(种类不是位置)##CARD_FIELD_INDEX##CODE
			sendCommand(command);
		}
		public function sendMoveCardCmd(card:CardBase,to:int) {
			var command:String;
			command = CommandEngine.createNewCommand(
				CommandEngine.MOVE_CARD,
				card.getCardFieldEngineIndex(),
				card.cardDisplay.getCode(),
				to);
			sendCommand(command);
			//命令格式：MOVE_CARD::CARD_FIELD_INDEX##CARD_CODE##TO_CARD_FIELD_INDEX
		}
		public function sendSetCommandEnabledCmd(isYou:Boolean) {
			var command:String;
			if (isYou) {			
				command = CommandEngine.createNewCommand(
					CommandEngine.SET_COMMAND_ENABLED, 1);
			}else {
				command = CommandEngine.createNewCommand(
					CommandEngine.SET_COMMAND_ENABLED,0);
			}				
			sendCommand(command);
		}
		public function sendDropCardCmd(card:CardBase) {
			var command:String;
			command = CommandEngine.createNewCommand(
				CommandEngine.DROP_CARD,
				card.getCardFieldEngineIndex(),
				card.cardDisplay.getCode());
			sendCommand(command);
			//命令格式：DROP_CARD::CARD_FIELD_INDEX##CARD_CODE
		}
		public function sendRefreshCrystalsCmd(isYou:int,available:int,unavailable:int) {
			var command:String;
			command = CommandEngine.createNewCommand(
				CommandEngine.REFRESH_CRYSTAL,
				isYou, available, unavailable);
			sendCommand(command);
		}
		public function receive(msg:String) {
			commandEngine.run(msg);
		}
		public function addSkillCardIntoCardLibrary(isEnemy:Boolean,skillData:SkillData)
		{
			if (isEnemy)
			{
				cardLibrarys[0].addCard(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(0), skillData));
			}
			else
			{
				cardLibrarys[1].addCard(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(3), skillData));
			}
		}
		
		public function isCardBelongToCardFieldEngine(card:CardBase, cardFieldEngine:CardFieldEngine):Boolean
		{
			for (var i = 0; i < cardFieldEngine.getCardNum(); i++)
			{
				if (card == cardFieldEngine.getCard(i))
				{
					return true;
				}
			}
			return false;
		}
		
		public function pushCardIntoCardLibrary(isEnemy:Boolean, isSkill:Boolean, data:Component)
		{
			if (!isSkill)
			{
				if (isEnemy)
				{
					cardLibrarys[0].addCard(CardBase.createNewMinionCardByMinionData(getCardFieldEngine(0), data as MinionData));
				}
				else
				{
					cardLibrarys[1].addCard(CardBase.createNewMinionCardByMinionData(getCardFieldEngine(3), data as MinionData));
				}
			}
			else
			{
				if (isEnemy)
				{
					cardLibrarys[0].addCard(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(0), data as SkillData));
				}
				else
				{
					cardLibrarys[1].addCard(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(3), data as SkillData));
				}
			}
		}
		
		/**
		 * 初始化
		 * 这步任务是先把该放的侦听器放好
		 * 主流程是根据state的变化而进行的
		 * @param	stage
		 */
		public function init(stage:Sprite)
		{
			this.stage = stage;
			//cardFieldEngine.cardField.addListener(stage);
			getCardFieldEngine(1).addClickListener(stage);
			getCardFieldEngine(0).addClickListener(stage);
			getCardFieldEngine(2).addClickListener(stage);
			getCardFieldEngine(3).addClickListener(stage);
			
			getCharacterEngine(0).addClickListener();
			getCharacterEngine(1).addClickListener();
			/**
			 * 执行的过程在这里添加
			 */
			addCmdFunction(0, onEnemyDeal);
			addCmdFunction(1, onEnemyEnd);
			addCmdFunction(2, onEnemyAttack);
			addCmdFunction(3, onYourAttack);
			addCmdFunction(4, onYourEnd);
			addCmdFunction(5, onYourDeal);
			
			addConsole();
			openSocket();
			addListener(EVENT_STATE_CHANGE, stateChange);
			addAllToStage();
			setState(EVENT_INIT);
			addAndMove();
			sendInitCmd();
		}
		
		public function openSocket()
		{
			socket = new MySocket();
			socket.receiver = this;
		}
		
		public function addConsole()
		{
			if (!c)
			{
				c = Console.createNewConsole();
			}
		}
		
		public function getCrystal(index:int):Crystal
		{
			return crystalEngines[index].crystal;
		}
		
		public function getCrystalEngine(index:int):CrystalEngine
		{
			return crystalEngines[index];
		}
		
		/**
		 * 真正的主流程从这里开始哈哈哈哈哈哈
		 * @param	e
		 */
		
		public function stateChange(e:Event)
		{
			switch (state)
			{
				case EVENT_INIT: 
					trace("游戏开始了！");
					c.T("游戏开始了！");
					setState(EVENT_BEFORE_THROW_COIN);
					break;
				case EVENT_BEFORE_THROW_COIN: 
					/**
					 * 先每个人发三张牌
					 */
					bringCardsFromCardLibrary(1, 3);
					bringCardsFromCardLibrary(0, 3);
					setState(EVENT_THROW_COIN);
					break;
				case EVENT_THROW_COIN: 
					/**
					 * 扔硬币
					 */
					isYourTurn = throwTheCoin();
					setState(EVENT_AFTER_THROW_COIN);
					break;
				case EVENT_AFTER_THROW_COIN: 
					//trace("isyourturn的值", isYourTurn);
					//c.T("isyourturn的值", isYourTurn);
					if (isYourTurn == true)//你先手
					{
						bringCardsFromCardLibrary(0, 1);//对方摸一张牌
						getCardFieldEngine(0).addCardByCardBase(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(0), UserData.getSkill(1, this)));
						//对方加一张硬币
						setState(EVENT_ENEMY_TURN_END);
						//别人的回合结束，自己的回合开始
					}
					else
					{
						bringCardsFromCardLibrary(1, 1);//自己摸一张牌
						getCardFieldEngine(3).addCardByCardBase(CardBase.createNewSkillCardBySkillData(getCardFieldEngine(3), UserData.getSkill(1, this)));
						//自己加一张硬币
						setState(EVENT_YOUR_TURN_END);
						//自己的回合结束
					}
					break;
				case EVENT_YOUR_TURN: 
					bringCardsFromCardLibrary(1, 1);
					//自己摸一张拍
					commandButtonGroup.setAllCommandButtonEnabled(new Array(false, false, false, true, true, true));
					sendSetCommandEnabledCmd(true);
					//按钮设置为只有自己的才有效
					break;
				case EVENT_ENEMY_TURN: 
					bringCardsFromCardLibrary(0, 1);
					//对方摸一张拍
					commandButtonGroup.setAllCommandButtonEnabled(new Array(true, true, true, false, false, false));
					//按钮设置为只有别人的才有效
					sendSetCommandEnabledCmd(false);
					break;
				case EVENT_YOUR_TURN_END: 
					enemyCrystalNum++;
					enemyCurrentCrystalNum = enemyCrystalNum;
					//水晶+1并回满
					isYourTurn = false;
					//换敌人的回合
					setAllMinionAttackable(1);
					//敌人的随从变得可以攻击
					setAllCardFieldEngineEnabled(new Array(true, true, true, false));
					//这些东西可以被选中
					refreshAllSelectable();
					//刷新
					setState(EVENT_ENEMY_TURN);
					break;
				case EVENT_ENEMY_TURN_END: 
					yourCrystalNum++;
					yourCurrentCrystalNum = yourCrystalNum;
					//水晶+1并回满
					isYourTurn = true;
					//换自己的回合
					setAllMinionAttackable(2);
					//自己的随从变得可以攻击
					setAllCardFieldEngineEnabled(new Array(false, true, true, true));
					//这些东西可以被选中
					refreshAllSelectable();
					//刷新
					setState(EVENT_YOUR_TURN);
					break;
			}
		}
		
		public function drawACard(isYou:Boolean)
		{
			if (isYou)
			{
				bringCardsFromCardLibrary(1, 1);
			}
			else
			{
				bringCardsFromCardLibrary(0, 1);
			}
		}
		public function drawASpecificMinionCard(isYou:Boolean,cardIndex:int) {
			if (isYou) {
				bringCardsFromVoid(1, cardIndex);
			}else {
				bringCardsFromVoid(0, cardIndex);
			}
		}		
		public function drawASpecificSkillCard(isYou:Boolean,cardIndex:int) {
			if (isYou) {
				bringSkillCardsFromVoid(1, cardIndex);
			}else {
				bringSkillCardsFromVoid(0, cardIndex);
			}
		}
		public function setAllMinionAttackable(index:int)
		{
			for (var i = 0; i < getCardField(index).cards.length; i++)
			{
				getCardFieldEngine(index).getCard(i).isFreezing = false;
				getCardFieldEngine(index).getCard(i).isCanAttack = true;
				getCardFieldEngine(index).getCard(i).HasAttacked = false;
			}
		}
		public function setOnAttack(position:int) {
			getCardFieldEngine(3).position = position;
			onYourDeal();
		}
		public function setSelectCard(cardFieldIndex:int,position:int) {
			getCardFieldEngine(cardFieldIndex).position = position;
			getCardFieldEngine(cardFieldIndex).onSelectCard(position);
		}
		public function callCardFieldSpecialEffect(index:int) //调用卡牌的特殊效果
		{
		
		}
		
		public function getCardFieldEngine(index:int):CardFieldEngine //得到卡牌管理器
		{
			cardFieldEngines[index].index = index;
			return cardFieldEngines[index];
		}
		
		public function getCardField(index:int):CardField //得到卡牌集合
		{
			return cardFieldEngines[index].cardField;
		}
		
		public function addCmdFunction(cmdIndex:int, func:Function) //添加按钮功能
		{
			addListener(MouseEvent.CLICK, func);
			addToStage(cmdIndex, commandButtonGroup.commandButtons[cmdIndex]);
		}
		
		/**
		 * 接受并且发送。用于文件内通信
		 * @param	source
		 * @param	target
		 */
		public function receiveAndDispatch(source:String, target:String) //接受并且发送
		{
			addEventListener(source, func);
			function func(e:Event)
			{
				dispatchEvent(new Event(target));
			}
		}
		
		public function getState():String
		{
			return state;
		}
		
		public function setState(state:String)
		{
			this.state = state;
			trace("当前到了" + state + "状态");
			c.T("当前到了" + state + "状态");
			this.dispatchEvent(new Event(EVENT_STATE_CHANGE, true));
		}
		
		public function onEnemyDeal(e:Event = null)
		{
			deal(cardFieldEngines[0], cardFieldEngines[1]);
		}
		
		public function onEnemyEnd(e:Event = null)
		{
			if (!isYourTurn)
			{
				setState(EVENT_ENEMY_TURN_END);
			}
		}
		
		public function onYourEnd(e:Event = null)
		{
			if (isYourTurn)
			{
				setState(EVENT_YOUR_TURN_END);
			}
		}
		
		public function onYourDeal(e:Event = null)
		{
			deal(cardFieldEngines[3], cardFieldEngines[2]);
		}
		
		public function onEnemyAttack(e:Event = null)
		{
			if (isYourTurn)
			{
				trace("对不起不到你的回合");
				return;
			}
			var position:int = getCardFieldEngine(1).position;
			var position2:int = getCardFieldEngine(2).position;
			if (position < 0)
			{
				trace("请选择攻击者！");
			}
			else if (position2 < 0 && !getCharacterEngine(1).getSelected())
			{
				trace("请选择一个目标");
			}
			else if (getCardFieldEngine(1).getCard(position).canAttack())
			{
				if (position2 >= 0)
				{
					twoMinionAttack();
				}
				else if (getCharacterEngine(1).getSelected())
				{
					minionAttackCharacter();
				}
				if (getCardFieldEngine(1).getCard(position))
				{
					getCardFieldEngine(1).getCard(position).isCanAttack = false;
					getCardFieldEngine(1).getCard(position).HasAttacked = true;
				}
			}
			else
			{
				trace("这个随从暂时不能攻击");
			}
		}
		
		public function onYourAttack(e:Event = null)
		{
			if (!isYourTurn)
			{
				trace("对不起不到你的回合");
				return;
			}
			var position:int = getCardFieldEngine(2).position;
			var position2:int = getCardFieldEngine(1).position;
			if (position < 0)
			{
				trace("请选择攻击者！");
			}
			else if (position2 < 0 && !getCharacterEngine(0).getSelected())
			{
				trace("请选择一个目标");
			}
			else if (getCardFieldEngine(2).getCard(position).canAttack())
			{
				if (position2 >= 0)
				{
					twoMinionAttack();
				}
				else if (getCharacterEngine(0).getSelected())
				{
					minionAttackCharacter();
				}
				if (getCardFieldEngine(2).getCard(position))
				{
					getCardFieldEngine(2).getCard(position).isCanAttack = false;
					getCardFieldEngine(2).getCard(position).HasAttacked = true;
				}
			}
			else
			{
				trace("这个随从暂时不能攻击");
			}
		}
		
		public function dealDamageToMinions(isYourMinion:Boolean, func:Function)
		{
			if (isYourMinion)
			{
				for (var i = 0; i < getCardFieldEngine(1).getCardNum(); i++)
				{
					getCardFieldEngine(1).getCard(i).decreaseCurrentHealth(func.apply());
				}
			}
			else
			{
				for (var j = 0; j < getCardFieldEngine(2).getCardNum(); j++)
				{
					getCardFieldEngine(2).getCard(j).decreaseCurrentHealth(func.apply());
				}
			}
		}
		
		public function minionDead(card:CardBase, cardFieldEngine:CardFieldEngine, damage:int = 0)
		{
			if (card.getCurrentHealth() <= 0)
			{
				trace("这个名叫" + card.getName() + "的随从死亡，死亡时的血量为" + card.getCurrentHealth() + "，受到" + damage + "点伤害" + "，原来有" + card.getHealth() + "点血");
				trace(cardFieldEngine.index);
				cardFieldEngine.destroyMinion();
			}
		}
		
		public function twoMinionAttack()
		{
			var card1:CardBase = getCardFieldEngine(1).getCard();
			var card2:CardBase = getCardFieldEngine(2).getCard();
			var attack1:int = card2.getCurrentAttack();
			var attack2:int = card1.getCurrentAttack();
			card1.decreaseCurrentHealth(attack1);
			card2.decreaseCurrentHealth(attack2);
			//minionDead(card1, getCardFieldEngine(1), attack1);
			//minionDead(card2, getCardFieldEngine(2), attack2);
		}
		
		public function minionAttackCharacter()
		{
			if (isYourTurn && getCharacterEngine(0).getSelected())
			{
				getCharacterEngine(0).decreaseHealth(getCardFieldEngine(2).getCard().getAttack());
			}
			else if (!isYourTurn && getCharacterEngine(1).getSelected())
			{
				getCharacterEngine(1).decreaseHealth(getCardFieldEngine(1).getCard().getAttack());
			}
		}
		
		public function deal(source:CardFieldEngine, target:CardFieldEngine)
		{
			//首先得到从来源处卡牌的信息
			var testCard:CardBase = source.getCard(source.position);
			//如果来源处没有卡片返回
			if (!testCard)
				return;
			//如果是法术牌
			if (testCard.getType() == CardData.TYPE_SKILL)
			{
				//如果在你的回合
				if (isYourTurn)
				{
					//如果你当前的法力值减去卡牌法力水晶的消耗值大于0
					dealYouSkill(testCard, source);
				}
				//如果在敌人的回合
				else
				{
					//如果敌人当前的法力值减去卡牌法力水晶的消耗值大于0
					dealEnemySkill(testCard, source);
				}
				return;
			}
			//如果是随从卡
			else if (testCard.getType() == CardData.TYPE_MINION)
			{
				//如果在你的回合
				if (isYourTurn)
				{
					dealYouMinion(testCard,source, target);
				}
				else
				{
					dealEnemyMinion(testCard,source, target);
				}
			}
		}
		
		public function dealYouSkill(testCard:CardBase, source:CardFieldEngine)
		{
			if (yourCurrentCrystalNum - testCard.getCost() >= 0)
			{
				//打出这张牌
				yourCurrentCrystalNum -= testCard.getCost();
				//执行法术牌效果
				source.getCard(source.position).run();
				//移除这张卡片
				source.cardField.removeChild(source.popCard(source.position, -1));
				sendDropCardCmd(testCard);
			}
			else
			{
				trace("我没有足够的法力值");
				//不进行任何操作
				return;
			}
		}
		
		public function dealYouMinion(testCard:CardBase,source:CardFieldEngine, target:CardFieldEngine)
		{
			//如果你当前的法力值减去卡牌的法力值大于等于0
			if (yourCurrentCrystalNum - testCard.getCost() >= 0)
			{
				var ycard:CardBase = source.popCard(source.position, -1);
				//使用这张卡牌
				//弹出这张卡牌
				//减去你当前的花费
				sendMoveCardCmd(ycard, target.index);
				yourCurrentCrystalNum -= ycard.getCost();
				trace("我的法力值消耗了" + ycard.getCost() + "点，现在还剩余" + yourCurrentCrystalNum + "点法力值");
				target.addCardByCardBase(ycard);
				ycard.run();
				ycard.cardFieldEngine = this.getCardFieldEngine(2);
			}
			else
			{
				trace("我没有足够的法力值,我想打出" + testCard.getCost() + "法力值的牌，但是我的法力水晶只有" + yourCurrentCrystalNum + "点");
			}
			source.refreshCards();
			target.refreshCards();
		}
		
		public function dealEnemyMinion(testCard:CardBase,source:CardFieldEngine, target:CardFieldEngine)
		{
			if (enemyCurrentCrystalNum - testCard.getCost() >= 0)
			{
				var ecard:CardBase = source.popCard(source.position);
				sendMoveCardCmd(ecard, target.index);
				enemyCurrentCrystalNum -= ecard.getCost();
				trace("敌人的法力值消耗了" + ecard.getCost() + "点，现在还剩余" + enemyCurrentCrystalNum + "点法力值");
				target.addCardByCardBase(ecard);
				ecard.run();
				ecard.cardFieldEngine = this.getCardFieldEngine(1);
			}
			else
			{
				trace("敌人没有足够的法力值,我想打出" + testCard.getCost() + "法力值的牌，但是我的法力水晶只有" + enemyCurrentCrystalNum + "点");
			}
			source.refreshCards();
			target.refreshCards();
		}
		
		public function dealEnemySkill(testCard:CardBase, source:CardFieldEngine)
		{
			if (enemyCurrentCrystalNum - testCard.getCost() >= 0)
			{
				//减去相应的法力水晶
				enemyCurrentCrystalNum -= testCard.getCost();
				//执行法术牌效果
				source.getCard(source.position).run();
				//移除这张卡片
				source.cardField.removeChild(source.popCard(source.position, -1));
				sendDropCardCmd(testCard);
			}
			else
			{
				trace("敌人没有足够的法力值");
				return;
			}
		}
		
		public function bringCardsFromCardLibrary(isYou:int, num:int)
		{
			var to:CardFieldEngine;
			if (isYou == 0)
			{
				to = getCardFieldEngine(0);
			}
			else
			{
				to = getCardFieldEngine(3);
			}
			to.addCards(cardLibrarys[isYou].popCardsRandomly(num));
			var str:String = (isYou == 0 ? "敌人" : "你");
			trace(str + "从牌库中摸了" + num + "张牌");
			to.refreshCards();
		}
		public function bringCardsFromVoid(isYou:int, num:int) {	
			var to:CardFieldEngine;
			if (isYou == 0)
			{
				to = getCardFieldEngine(0);
			}
			else
			{
				to = getCardFieldEngine(3);
			}
			to.addCardByCardBase(CardBase.createNewMinionCardByMinionData(to, UserData.getMinionData(this, num)));
			var str:String = (isYou == 0 ? "敌人" : "你");
			trace(str + "从牌库中摸了" + num + "张牌");
			to.refreshCards();
		}		
		public function bringSkillCardsFromVoid(isYou:int, num:int) {	
			var to:CardFieldEngine;
			if (isYou == 0)
			{
				to = getCardFieldEngine(0);
			}
			else
			{
				to = getCardFieldEngine(3);
			}
			to.addCardByCardBase(CardBase.createNewSkillCardBySkillData(to, UserData.getSkill(num,this)));
			var str:String = (isYou == 0 ? "敌人" : "你");
			trace(str + "从牌库中摸了" + num + "张牌");
			to.refreshCards();
		}
		public function setCardFieldClickEnabled(target:CardFieldEngine, bool:Boolean)
		{
			target.setClickEnabled(bool);
		}
		
		public function throwTheCoin():Boolean
		{
			var bool:Boolean = (Math.random() - 0.5 > 0) ? true : false;
			var str:String;
			if (bool)
			{
				str = "你先手";
			}
			else
			{
				str = "敌人先手";
			}
			trace("扔硬币的结果是" + str + "," + bool);
			return bool;
		}
		
		public function setAllCardFieldEngineEnabled(array:Array)
		{
			for (var i = 0; i < array.length; i++)
			{
				setCardFieldClickEnabled(getCardFieldEngine(i), array[i] as Boolean);
			}
		}
		public function refreshAllCardFieldEngine()
		{
			for (var i = 0; i < cardFieldEngines.length; i++)
			{
				getCardFieldEngine(i).refreshCards();
			}
		}
		
		public function getCharacterEngine(index:int):CharacterEngine
		{
			return characterEngines[index];
		}
		
		public function getCharacter(index:int):Character
		{
			return getCharacterEngine(index).character;
		}
		
		public function refreshAllSelectable()
		{
			getCardFieldEngine(0).refreshCards();
			getCardFieldEngine(1).refreshCards();
			getCardFieldEngine(2).refreshCards();
			getCardFieldEngine(3).refreshCards();
			getCharacterEngine(0).setSelected(false);
			getCharacterEngine(1).setSelected(false);
		}
		
		public function getYourHandEngine():CardFieldEngine
		{
			return cardFieldEngines[3];
		}
		
		public function getEnemyHandEngine():CardFieldEngine
		{
			return cardFieldEngines[0];
		}
		
		public function dropACardRandomly(isYou:Boolean)
		{
			var num:Number = Math.random();
			var card:CardBase;
			if (isYou)
			{
				card = getYourHandEngine().popCard(int(Math.floor(num * getYourHandEngine().getCardNum())), 3);
				if (card)
				{
					getCardField(3).removeChild(card);
					sendDropCardCmd(card);
				}
			}
			else
			{
				card = getEnemyHandEngine().popCard(int(Math.floor(num * getEnemyHandEngine().getCardNum())), 0);
				if (card)
				{
					getCardField(0).removeChild(card);
					sendDropCardCmd(card);
				}
			}
		}
		
		public function addAndMove()
		{
			Move.addAndSetposition(c, stage, 0, 550);
			Move.addAndSetposition(getCrystal(0), stage, 683, 57);
			Move.addAndSetposition(getCrystal(1), stage, 683, 453);
			Move.addAndSetposition(getCardField(0), stage, 0, 0);
			Move.addAndSetposition(getCardField(1), stage, 0, 150);
			Move.addAndSetposition(getCardField(2), stage, 0, 300);
			Move.addAndSetposition(getCardField(3), stage, 0, 450);
			Move.addAndSetposition(commandButtonGroup, stage, 796, 86);
			Move.addAndSetposition(getCharacter(0), stage, 683, 80);
			Move.addAndSetposition(getCharacter(1), stage, 683, 347);
		}
		
		public function get yourCurrentCrystalNum():int
		{
			return _yourCurrentCrystalNum;
		}
		
		public function set yourCurrentCrystalNum(value:int):void
		{
			_yourCurrentCrystalNum = value;
			sendRefreshCrystalsCmd(1, _yourCurrentCrystalNum, _yourCrystalNum - _yourCurrentCrystalNum);
			getCrystalEngine(1).setCrystalNum(_yourCurrentCrystalNum, _yourCrystalNum - _yourCurrentCrystalNum);
		}
		
		public function get yourCrystalNum():int
		{
			return _yourCrystalNum;
		}
		
		public function set yourCrystalNum(value:int):void
		{
			_yourCrystalNum = value;
			sendRefreshCrystalsCmd(1, _yourCurrentCrystalNum, _yourCrystalNum - _yourCurrentCrystalNum);
			getCrystalEngine(1).setCrystalNum(_yourCurrentCrystalNum, _yourCrystalNum - _yourCurrentCrystalNum);
		}
		
		public function get enemyCrystalNum():int
		{
			return _enemyCrystalNum;
		}
		
		public function set enemyCrystalNum(value:int):void
		{
			_enemyCrystalNum = value;
			sendRefreshCrystalsCmd(0, _enemyCurrentCrystalNum, _enemyCrystalNum - _enemyCurrentCrystalNum);
			getCrystalEngine(0).setCrystalNum(_enemyCurrentCrystalNum, _enemyCrystalNum - _enemyCurrentCrystalNum);
		}
		
		public function get enemyCurrentCrystalNum():int
		{
			return _enemyCurrentCrystalNum;
		}
		
		public function set enemyCurrentCrystalNum(value:int):void
		{
			_enemyCurrentCrystalNum = value;
			sendRefreshCrystalsCmd(0, _enemyCurrentCrystalNum, _enemyCrystalNum - _enemyCurrentCrystalNum);
			getCrystalEngine(0).setCrystalNum(_enemyCurrentCrystalNum, _enemyCrystalNum - _enemyCurrentCrystalNum);
		}
	}
}