package script.com.zbf.engine
{
	import script.com.zbf.engine.Engine;
	import script.com.zbf.engine.MainEngine;
	import script.com.zbf.interfac.IRunnable;
	/**
	 * ...
	 * @author ...
	 */
	public class CommandEngine extends Engine implements IRunnable
	{
		public static const SPLIT_MARK:String = "##";
		public static const ORDER_MARK:String = "::";
		//命令格式：COMMAND::参数1##参数2##参数3

		public static const NEW_CARD:String = "NEW_CARD";
		public static const MOVE_CARD:String = "MOVE_CARD";
		public static const DROP_CARD:String = "DROP_CARD";
		public static const INIT:String = "INIT";
		public static const REFRESH_CRYSTAL:String = "REFRESH_CRYSTAL";
		public static const SET_COMMAND_ENABLED:String = "SET_COMMAND_ENABLED";
		public static const SET_SELECT_CARD:String = "SET_SELECT_CARD";
		public static const ON_DEAL:String = "ON_DEAL";
		public static const ON_END:String = "ON_END";
		public static const ON_ATTACK:String = "ON_ATTACK";
		public var engine:Engine;
		public var mainEngine:MainEngine;
		public var clientEngine:ClientEngine;
		public var cmd:String;			//储存命令的字符串
		//public var cmdArray:Array;	//储存命令的数组，从字符串中得到
		public static function createNewCommandEngine(engine:Engine):CommandEngine {
			var commandEngine:CommandEngine=new CommandEngine();
			commandEngine.engine = engine;
			return commandEngine;
		}
		public function CommandEngine() {
			
		}
		public function getMainEngine():MainEngine {
			mainEngine = engine as MainEngine;
			return mainEngine;
		}
		public function getClientEngine():ClientEngine {
			clientEngine = engine as ClientEngine;
			return clientEngine;
		}
		public function getOrderArray(cmd:String):Array {
			var array:Array = cmd.split("\n");
			return array;
		}
		public function runSingle(cmd:String) {
			var cmdArray:Array = getCmdArray(cmd);
			trace(cmdArray);
			if (!cmdArray) return;
			var orderName:String = getOrderName(cmdArray);
			switch(orderName) {
				case NEW_CARD:
					newCard(cmdArray[1],cmdArray[2],cmdArray[3],cmdArray[4]);
					break;		
				case DROP_CARD:
					dropCard(cmdArray[1],cmdArray[2]);
					break;					
				case INIT:
					initCommands();
					break;
				case MOVE_CARD:
					moveCard(cmdArray[1], cmdArray[2], cmdArray[3]);
					break;		
				case REFRESH_CRYSTAL:
					refreshCrystal(cmdArray[1], cmdArray[2], cmdArray[3]);
					break;
				case SET_COMMAND_ENABLED:
					setCommandEnabled(cmdArray[1]);
					break;
				case ON_ATTACK:
					onAttack(cmdArray[1]);
					break;		
				case SET_SELECT_CARD:
					onSelectCard(cmdArray[1], cmdArray[2]);
					break;
				default:
					trace("无法识别的命令");
					getClientEngine().console.T("无法识别的命令");
					break;
			}
		}
		public function run(cmd:String) {
			var array:Array = getOrderArray(cmd);
			for (var i = 0; i < array.length; i++) {
				runSingle(array[i]);
			}
		}
		/**
		 * 示例用法	
		 * var command:String;
			command=CommandEngine.createNewCommand(
					CommandEngine.NEW_CARD,
					card.getType(),
					card.getIndex(),
					card.getCardFieldEngineIndex(),
					card.getCode()
				);
				mainEngine.sendCommand(command);
		 * @param	order
		 * @param	...rest
		 * @return
		 */
		public static function createNewCommand(order:String,...rest):String {
			var str:String = "";
			str = str.concat(order, CommandEngine.ORDER_MARK);
			for (var i = 0; i < rest.length; i++) {
				str = str.concat(rest[i]);
				if (i != rest.length - 1) {
					str = str.concat(CommandEngine.SPLIT_MARK);
					
				}
			}
			return str;
		}		

		/**
		 * 命令：新建一张卡
		 * @param	cardType
		 * @param	cardIndex
		 * @param	cardFieldClientIndex
		 * @param	code
		 */
		public function newCard(cardType:String, cardIndex:String, cardFieldClientIndex:String, code:String) {
			var a:int = int(cardType);
			var b:int = int(cardIndex);
			var c:int = int(cardFieldClientIndex);
			var d:int = int(code);
			getClientEngine().newCard(a,b,c,d);
		}		
		public function dropCard(cardFieldIndex:String,cardCode:String) {
			var a:int = int(cardFieldIndex);
			var b:int = int(cardCode);
			getClientEngine().dropCard(a,b);
		}		
		public function moveCard(cardFieldIndex:String,cardCode:String,to:String) {
			var a:int = int(cardFieldIndex);
			var b:int = int(cardCode);
			var c:int = int(to);
			getClientEngine().moveCard(a,b,c);
		}
		public function refreshCrystal(isYou:String, available:String, amount:String) {
			var a:int = int(isYou);
			var b:int = int(available);
			var c:int = int(amount);
			getClientEngine().refreshCrystal(a, b, c);
		}
		public function setCommandEnabled(isTrue:String) {
			var a:int = int(isTrue);
			getClientEngine().setCommandEnabled(a);
		}
		public function initCommands() {
			getClientEngine().initCommands();
		}
		public function onAttack(position:String) {
			var a:int = int(position);
			getMainEngine().setOnAttack(a);
		}
		public function onSelectCard(cardFieldIndex:String,position:String) {
			var a:int = int(cardFieldIndex);
			var b:int = int(position);
			getMainEngine().setSelectCard(a,b);
		}
		public function getCmdArray(cmd:String):Array {
			var array:Array = new Array();
			array = cmd.split(ORDER_MARK);
			if (array.length == 1) {
				trace("命令错误");
				return null;
			}
			array = new Array().concat(array[0],array[1].split(SPLIT_MARK));
			return array;
		}
		public function getOrderName(array:Array):String {
			return array[0].toString();
		}
	}
	
}