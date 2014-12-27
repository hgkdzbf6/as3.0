package script.com.zbf.minion
{
	import flash.events.Event;
	import script.com.zbf.minion.MinionData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import script.com.zbf.utils.Draw;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class MinionDisplay extends Sprite
	{
		public static const ATTACK_POSITION:Point = new Point(10, 111);
		public static const HEALTH_POSITION:Point = new Point(67, 111);
		public static const COST_POSITION:Point = new Point(7, 11);
		public static const NAME_POSITION:Point = new Point(27, 52);
		public var isMouseMoveOn:Boolean = false;
		public var simple:Sprite;
		public var tfAttack:TextField;
		public var tfHealth:TextField;
		public var tfCost:TextField;
		public var tfName:TextField;
		public var minionData:MinionData;
		public function MinionDisplay() {
			init();
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		public function init() {
			minionData = new MinionData();
			minionData.init();
			drawSimpleMinion(minionData);
			addChild(simple);
		}
		public function onMouseOver(e:Event) {
			if (!isMouseMoveOn) {
				trace(minionData.toString());
			}
			isMouseMoveOn = true;
		}
		public function onMouseOut(e:Event) {
			isMouseMoveOn = false;
		}
		public function drawSimpleMinion(minionData:MinionData) {
			simple = new Sprite();
			simple.x = 100;
			simple.y = 100;
			simple.addChild(Draw.drawMinionBack(1, 100, 0, 0));
			tfName = Draw.drawLabelByPoint(NAME_POSITION, String(minionData.name), Draw.FORMAT_1);
			simple.addChild(tfName);
			simple.mouseChildren = false;
		}
	}
	
}