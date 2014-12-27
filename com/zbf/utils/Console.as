package script.com.zbf.utils
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class Console extends Sprite 
	{
		public var window:Sprite;
		public var textField:TextField;
		public var text:String;
		public static function createNewConsole():Console {
			var console:Console = new Console();
			console.init();
			return console;
		}
		public function T(...rest) {
			for (var i = 0; i < rest.length; i++) {
				if (i==rest.length-1) {
					addText(rest[i].toString());
				}else {
					addText(rest[i].toString()+" ");
				}
			}
			addText("\n");
		}
		public function C() {
			setText("");
		}
		public function addText(str:String) {
			if(text){
				setText(text + str );
			}else {
				setText(str);
			}
		}
		public function draw() {
			window = Draw.drawConsoleBackground();
			textField = Draw.drawTextField(5, 5, Draw.FORMAT_1, true);
			textField.width = window.width-10;
			textField.height = window.height-10;
			addChild(window);
			addChild(textField);
		}
		public function setText(text:String) {
			this.text = text;
			textField.text = text;
		}
		public function Console() {
			init();
		}
		public function init() {
			draw();
		}
	}
	
}