package script.com.zbf.utils {
	import flash.utils.Timer;
	
	public class MyTimer extends Timer {
		public var index:int;
		public static var INDEX:int = 0;
		public function MyTimer(delay:Number,repeatCount:int=0) {
			// constructor code
			INDEX++;
			index = INDEX;
			super(delay, repeatCount);
		}
	}
	
}
