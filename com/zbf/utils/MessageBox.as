package script.com.zbf.utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import script.com.zbf.interfac.IRunnable;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class  MessageBox extends Sprite
	{		
		public var window:Sprite;
		public var textField:TextField;
		public var cmd:Sprite;
		public var text:String;
		public var console:Console;
		public var runnable:IRunnable;
		
		public function MessageBox () {
		}
		public function init(console:Console) {
			this.console = console;
			draw();
			cmd.addEventListener(MouseEvent.CLICK, onClick);
		}		
		public static function createNewMessageBox(console:Console):MessageBox {
			var messageBox:MessageBox = new MessageBox();
			messageBox.init(console);
			return messageBox;
		}
		private function onClick(e:Event = null) {
			S();
		}
		public function S() {
			text = textField.text.toString();
			console.T(text);
			runnable.run(text);
		}
		public function draw() {
			window = Draw.drawConsoleBackground(300,50);
			textField = Draw.drawTextField(5, 5, Draw.FORMAT_1, true);
			cmd = Draw.drawCmd("发送", Draw.FORMAT_2, Draw.GRADIENT_2, 320, 0, 70, 50);
			textField.width = window.width-10;
			textField.height = window.height-10;
			addChild(window);
			addChild(textField);
			addChild(cmd);
		}
		
	}
	
}