package script.com.zbf.ui
{
	import flash.display.Sprite;
	import script.com.zbf.utils.Draw;
	import script.com.zbf.ui.CommandButton;
	/**
	 * 设定：按钮的大小100*50
	 * 边框的大小：120*60
	 * @author ...
	 */
	public class CommandButtonGroup extends Sprite
	{
		
		public var commandButtons:Vector.<CommandButton>;
		public function CommandButtonGroup() {
			
		}
		public static function createNewCommandButtonGroup(array:Array):CommandButtonGroup {
			var commandButtonGroup:CommandButtonGroup = new CommandButtonGroup();
			commandButtonGroup.addButtons(array);
			commandButtonGroup.setButtonEnabled(0, false);
			commandButtonGroup.setButtonEnabled(1, false);
			commandButtonGroup.setButtonEnabled(2, false);
			return commandButtonGroup;
		}
		public function addButtons(array:Array) {
			if (!commandButtons) {
				commandButtons = new Vector.<CommandButton>;
			}
			for (var i = 0; i < array.length; i++) {
				commandButtons.push(CommandButton.createNewCommandButton2(array[i] as String));
			}
			arrangeButtons();
		}
		public function arrangeButtons() {
			for (var i = 0; i < commandButtons.length; i++) {
				var commandButton:CommandButton = commandButtons[i];
				commandButton.x = 5;
				commandButton.y = 5 + i * 60;
				addChild(commandButton);
			}
		}
		public function setButtonEnabled(index:int,bool:Boolean) {
			commandButtons[index].mouseEnabled = bool;
			commandButtons[index].setEnabled(bool);
		}
		public function setAllCommandButtonEnabled(array:Array)
		{
			for (var i = 0; i < array.length; i++)
			{
				setButtonEnabled(i, array[i]);
			}
		}
	}
	
}