package script.com.zbf.engine
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import script.com.zbf.engine.Engine;
	import script.com.zbf.character.Character;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class CharacterEngine extends Engine
	{
		public var character:Character;
		private var _isSelected:Boolean = false;
		public var health:int = 30;
		//public var stage:Object;
		public var engine:Engine;
		public var isClickEnabled:Boolean=true;
		public var isYou:Boolean;
		public function CharacterEngine() {
			
		}
		public static function createNewCharacterEngine(engine: Engine,isYou:Boolean) {
			var characterEngine:CharacterEngine = new CharacterEngine();
			characterEngine.engine = engine;
			characterEngine.isYou = isYou;
			characterEngine.init(engine.stage);
			return characterEngine;
		}
		public function addClickListener() {
			character.mouseChildren= false;
			character.addEventListener(MouseEvent.CLICK, onClickEvent);
		}		
		public function addClickListener2() {
			character.mouseChildren= false;
			character.addEventListener(MouseEvent.CLICK, onClickEvent2);
		}
		public function setClickEnabled(bool:Boolean) {
			isClickEnabled = bool;
		}
		public function onClickEvent(e:Event) {	
			var mEngine:MainEngine = engine as MainEngine;
			if (!mEngine) return;
			if (!isClickEnabled) return;
			if (mEngine.isYourTurn != isYou) {
				setSelected(true);
				if (mEngine.isYourTurn) {
					mEngine.getCardFieldEngine(1).refreshCards();
				}else {
					mEngine.getCardFieldEngine(2).refreshCards();
				}
			}
		}
		public function onClickEvent2(e:Event) {
			var cEngine:ClientEngine = engine as ClientEngine;
			if (!cEngine) return;
			if (!isClickEnabled) return;
			if (cEngine.isYourTurn != isYou) {
				setSelected(true);				
				if (cEngine.isYourTurn) {
					cEngine.getCardField(1).refreshAllCards();
				}else {
					cEngine.getCardField(2).refreshAllCards();
				}
				//cEngine.sendOnSelectCard(
			}
		}
		public function init(stage:Sprite) {
			this.stage = stage;
			character = new Character() ;
			character.draw(String(health));
		}
		public function getSelected():Boolean 
		{
			return _isSelected;
		}
		public function decreaseHealth(val:int) {
			var format:TextFormat = character.tfHealth.getTextFormat();
			health -= val;
			character.tfHealth.text = String(health);
			character.tfHealth.setTextFormat(format);
		}
		public function setSelected(value:Boolean):void 
		{
			_isSelected = value;
			if (_isSelected) {
				if(engine as MainEngine){
					Draw.addFilter(character);
				}else if (engine as ClientEngine) {
					Draw.addFilter(character, 1);
				}
			}else {
				Draw.removeAllFilters(character);
			}
		}
	}
	
}