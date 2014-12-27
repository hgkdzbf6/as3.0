package script.com.zbf.utils
{
	
	/**
	 * ...
	 * @author ...
	 */
	public class Component extends Object
	{
		public static var CODE:int=5438;
		//public static const ORIGINAL_INDEX:int = 5438;
		public var code:int;
		public function Component() {
			getCode();
		}
		public function getType():int {
			return -1;
		}
		public function getCode() {
			this.code = CODE;
			CODE++;
		}
	}
	
}