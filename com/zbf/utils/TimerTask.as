package  script.com.zbf.utils{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import script.com.utils.MyTimer;
	public class TimerTask {
		public static const DEFAULT_DELAY:Number = 20;
		public static var timers:Vector.<MyTimer> = new Vector.<MyTimer>;
		public function TimerTask() {
			// constructor code
		}
		public static function init() {
			addTimer(DEFAULT_DELAY);
		}
		public static function addTimer(d:Number) :MyTimer{
			var mytimer:MyTimer = new MyTimer(d);
			timers.push(mytimer);
			return mytimer;
		}
		public static function addFunction(
			delay:int,
			limitFunc:Function,
			paramNum:int=0,
			...rest) 
		{
			var timer:MyTimer;
			for (var i = 0; i < timers.length; i++) {
				if (timers[i].delay == delay) {
					timer == timers[i];
				}
			}
			timer = addTimer(delay);
			timer.addEventListener(TimerEvent.TIMER, stopFunc);
			function stopFunc() {
				if (paramNum == 0) {
					limitFunc();
				}else if (paramNum == 1) {
					limitFunc(rest[0]);
				}else if (paramNum == 2) {
					limitFunc(rest[0],rest[1]);
				}
				if (limitFunc() == true) {					
					timer.removeEventListener(TimerEvent.TIMER, limitFunc);
					timer.removeEventListener(TimerEvent.TIMER, stopFunc);
					removeTimer(timer);
				}
			}
			timer.start();
		}
		public static function removeTimer(mytimer:MyTimer) {
			if(mytimer==null)return;
			if (timers.indexOf(mytimer) != -1 ){
				timers.splice(timers.indexOf(mytimer), 1);
			}else {
				for (var i = 0; i < timers.length; i++) {
					if (timers[i].index == mytimer.index) {
						timers.splice(i, 1);
					}
				}
			}
			mytimer.stop();
			mytimer == null;
		}
		public static function distroy() {
			do {
				var timer:MyTimer = timers.pop();
				timer = null;
			}while (timers.length <= 0);
		}
	}
}