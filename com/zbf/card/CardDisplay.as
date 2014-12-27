package script.com.zbf.card
{
	import flash.display.GraphicsGradientFill;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import script.com.zbf.minion.MinionData;
	import script.com.zbf.skill.SkillData;
	import script.com.zbf.utils.Component;
	import flash.text.TextField;
	import script.com.zbf.utils.Draw;
	
	import flash.geom.Point;
	
	public class CardDisplay extends Sprite
	{
		public var simple:Sprite;
		public var tfAttack:TextField;
		public var tfHealth:TextField;
		public var tfCost:TextField;
		public var tfName:TextField;
		
		public var tauntLight:Shape;
		public var wildFuryLight:Shape;
		public var holyShieldLight:Shape;
		public var stealthLight:Shape;
		public var chargeLight:Shape;
		
		public var minionData:MinionData;
		public var skillData:SkillData;
		public var data:CardData;
		
		public static const ATTACK_POSITION:Point = new Point(14, 121);
		public static const HEALTH_POSITION:Point = new Point(72, 121);
		public static const COST_POSITION:Point = new Point(11, 21);
		public static const NAME_POSITION:Point = new Point(31, 63);
		
		public static const TAUNT_POSITION:Point = new Point(16, 88);
		public static const HOLYSHIELD_POSITION:Point = new Point(32, 88);
		public static const STEALTH_POSITION:Point = new Point(48, 88);
		public static const CHARGE_POSITION:Point = new Point(64, 88);
		public static const WILDFURY_POSITION:Point = new Point(80, 88);
		
		public static const RADIUS:int = 8;
		
		public static const HARMFUL:int = -1;
		public static const BENIFICIAL:int = 1;
		public static const NORMAL:int = 0;
		
		public static const TAUNT_INDEX:int = 1;
		public static const HOLYSHIELD_INDEX:int = 2;
		public static const STEALTH_INDEX:int = 4;
		public static const CHARGE_INDEX:int = 8;
		public static const WILDFURY_INDEX:int = 16;
		public function CardDisplay()
		{
			// constructor code
		}
		public static function createNewCardDisplay(cardData:CardData):CardDisplay {
			var cardDisplay:CardDisplay = new CardDisplay();
			cardDisplay.init(cardData);
			return cardDisplay;
		}
		public function init(data:CardData)
		{
			this.data = data;
			drawSimpleCard(data.getData());
			this.mouseChildren = false;
			this.mouseEnabled = true;
			addChild(simple);
		}
		
		public function addFilter()
		{
			Draw.addFilter(this);
		}
		
		public function setLight(flag:Boolean,on:GraphicsGradientFill,point:Point):Shape
		{
			if (!minionData)
			{
				return null;
			}
			if (flag) {
				return  Draw.drawLight(point, RADIUS, on);
			}else {
				return Draw.drawLight(point, RADIUS, Draw.LIGHT_GRADIENT_0);
			}
			return null;
		}
		public function setPosition(px:int,py:int) {
			x = px;
			y = py;
		}
		public function initLights() {
			tauntLight = new Shape();
			stealthLight = new Shape();
			wildFuryLight = new Shape();
			holyShieldLight = new Shape();
			chargeLight = new Shape();
		}
		public function setLights(minionData:MinionData=null) {
			if (!minionData) {
				return;
			}
			tauntLight=setLight(minionData.isTaunt, Draw.LIGHT_GRADIENT_1,TAUNT_POSITION);
			stealthLight=setLight(minionData.isStealth, Draw.LIGHT_GRADIENT_2,STEALTH_POSITION);
			wildFuryLight=setLight( minionData.isWildFury, Draw.LIGHT_GRADIENT_3,WILDFURY_POSITION);
			holyShieldLight=setLight( minionData.hasHolyShield, Draw.LIGHT_GRADIENT_4,HOLYSHIELD_POSITION);
			chargeLight=setLight( minionData.isCharge, Draw.LIGHT_GRADIENT_5,CHARGE_POSITION);
		}
		public function setLightsByLightInfomation(lightIndex:int) {
			var order:int = lightIndex;
			if (order & TAUNT_INDEX) {
				setLight(true, Draw.LIGHT_GRADIENT_1,TAUNT_POSITION);
			}else {
				setLight(false, Draw.LIGHT_GRADIENT_1,TAUNT_POSITION);
			}
			if (order & HOLYSHIELD_INDEX) {
				setLight(true, Draw.LIGHT_GRADIENT_4,HOLYSHIELD_POSITION);
			}else {
				setLight(false, Draw.LIGHT_GRADIENT_4,HOLYSHIELD_POSITION);
			}
			if (order & STEALTH_INDEX) {
				setLight(true, Draw.LIGHT_GRADIENT_2,STEALTH_POSITION);
			}else {
				setLight(false, Draw.LIGHT_GRADIENT_2,STEALTH_POSITION);
			}
			if (order & CHARGE_INDEX) {
				setLight(true, Draw.LIGHT_GRADIENT_5,CHARGE_POSITION);
			}else {
				setLight(false, Draw.LIGHT_GRADIENT_5,CHARGE_POSITION);
			}
			if (order & WILDFURY_INDEX) {
				setLight(true, Draw.LIGHT_GRADIENT_3,WILDFURY_POSITION);
			}else {
				setLight(false, Draw.LIGHT_GRADIENT_3,WILDFURY_POSITION);
			}
		}
		public function removeAllFilters()
		{
			filters = null;
		}
		
		public function drawSimpleCard(data:Component)
		{
			simple = new Sprite();
			simple.x = 0;
			simple.y = 0;
			simple.mouseChildren = false;
			if (data.getType() == CardData.TYPE_MINION)
			{
				minionData = data as MinionData;
				simple.addChild(Draw.drawCardBack(1, 100, 0, 0));
				tfHealth = Draw.drawLabelByPoint(HEALTH_POSITION, String(minionData.health), Draw.FORMAT_1);
				tfAttack = Draw.drawLabelByPoint(ATTACK_POSITION, String(minionData.attack), Draw.FORMAT_1);
				tfName = Draw.drawLabelByPoint(NAME_POSITION, String(minionData.name), Draw.FORMAT_1);
				tfCost = Draw.drawLabelByPoint(COST_POSITION, String(minionData.cost), Draw.FORMAT_1);
				initLights();
				setLights(minionData);
				
				simple.addChild(tauntLight);
				simple.addChild(holyShieldLight);
				simple.addChild(wildFuryLight);
				simple.addChild(stealthLight);
				simple.addChild(chargeLight);
				simple.addChild(tfHealth);
				simple.addChild(tfAttack);
				simple.addChild(tfCost);
				simple.addChild(tfName);
			}
			else if (data.getType() == CardData.TYPE_SKILL)
			{
				skillData = data as SkillData;
				simple.addChild(Draw.drawCardBack(0, 100, 0, 0));
				tfName = Draw.drawLabelByPoint(NAME_POSITION, String(skillData.name), Draw.FORMAT_1);
				tfCost = Draw.drawLabelByPoint(COST_POSITION, String(skillData.cost), Draw.FORMAT_1);
				simple.addChild(tfCost);
				simple.addChild(tfName);
			}
		}
		public function getCode() {
			return data.data.code;
		}
		public function refreshAll(array:Array=null)
		{
			if (data.getData().getType() == CardData.TYPE_MINION)
			{
				refresh(tfAttack, String(minionData.attack),array[0]);
				refresh(tfCost, String(minionData.cost),array[1]);
				refresh(tfHealth, String(minionData.health),array[2]);
				refresh(tfName, minionData.name,array[3]);
			}
			else if (data.getData().getType() == CardData.TYPE_SKILL)
			{
				refresh(tfCost, String(skillData.cost));
				refresh(tfName, skillData.name);
			}
		}
		
		public function refresh(textField:TextField, text:String,type:int=0)
		{
			var format:TextFormat = textField.getTextFormat();
			textField.text = text;
			if (type == HARMFUL) {
				format.color = 0xFF0000;
			}else if (type == BENIFICIAL) {
				format.color = 0x00FF00;
			}
			textField.setTextFormat(format);
		}
		
	}

}
