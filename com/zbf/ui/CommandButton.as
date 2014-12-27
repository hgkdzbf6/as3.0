package script.com.zbf.ui
{
	import flash.display.Sprite;
	import script.com.zbf.utils.Draw;
	/**
	 * ...
	 * @author ...
	 */
	public class CommandButton extends Sprite 
	{
		public var cmdBackground:Sprite;
		public var string:String="";
		public function CommandButton() {
			
		}
		public function draw(str:String = "wocao", enabled:Boolean=true) {
			if(enabled){
				cmdBackground=Draw.drawCmd(str, Draw.FORMAT_1, Draw.GRADIENT_1, 0, 0, 150, 50);
			}else {
				cmdBackground=Draw.drawCmd(str, Draw.FORMAT_1, Draw.GRADIENT_0, 0, 0, 150, 50);
			}
			this.string = string;
			addChild(cmdBackground);
			mouseChildren = false;
			useHandCursor = true;
			buttonMode = true;
		}
		public function setEnabled(bool:Boolean) {	
			if(bool){
				cmdBackground=Draw.drawCmd(string, Draw.FORMAT_1, Draw.GRADIENT_1, 0, 0, 150, 50);
			}else {
				cmdBackground=Draw.drawCmd(string, Draw.FORMAT_1, Draw.GRADIENT_0, 0, 0, 150, 50);
			}
			addChild(cmdBackground);
		}
		public static function createNewCommandButton():CommandButton {
			var commandButton:CommandButton = new CommandButton();
			commandButton.draw();
			return commandButton;
		}		
		public static function createNewCommandButton2(string:String):CommandButton {
			var commandButton:CommandButton = new CommandButton();
			commandButton.draw(string);
			commandButton.string = string;
			return commandButton;
		}
	}
	
}