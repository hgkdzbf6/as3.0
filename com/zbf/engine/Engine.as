package script.com.zbf.engine {
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	public class Engine extends EventDispatcher{
		var listeners:Array;
		var functions:Array;
		public  var stage:Sprite;
		public function Engine() {
			// constructor code
		}
		public function addListener(listener:String, func:Function) {
			if (!listeners) listeners = new Array();
			if (!functions) functions = new Array();
			listeners.push(listener);
			functions.push(func);
		}
		public function addAllToStage(target:Sprite=null) {
			if (listeners.length != functions.length) {
				trace(listeners.length, functions.length);
				trace("侦听器和函数集合的长度不匹配");
			}
			for (var i = 0; i < listeners.length; i++) {
				addToStage(i,target);
			}
			trace("在舞台上放了"+listeners.length+"个侦听器");
		}
		public function addToStage(index:int, target:Sprite = null ) {
			if (!target&&listeners) {
				this.addEventListener(listeners[index], functions[index]);
			}else if(listeners){
				target.addEventListener(listeners[index], functions[index]);
			}
		}
	}
}
