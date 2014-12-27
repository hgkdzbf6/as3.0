package script.com.zbf.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author zbf
	 */
	public class AddForeignSource extends Sprite
	{
		public static const EVENT_COMPLETE:String = "event_complete";
		public static const BITMAP:int = 0;
		public static const SPRITE:int = 1;
		
		var url:String;
		var loader:Loader;
		var request:URLRequest;
		
		public function AddForeignSource()
		{
		
		}
		
		public function init(url:String, type:int=0)
		{
			this.url = url;
			request = new URLRequest(url);
			loader = new Loader();
			loader.load(request);
			switch (type)
			{
				case BITMAP: 
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					break;
				case SPRITE: 
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
					break;
			}
		}
		
		public function onComplete(e:Event)
		{
			this.dispatchEvent(new Event(EVENT_COMPLETE, true));
			trace("hehe");
		}
		
		public function getBitmap():Bitmap
		{
			var bitmap:Bitmap;	
			var bitmapdata:BitmapData = new BitmapData(loader.width, loader.height);
				bitmapdata.draw(loader);
				bitmap = new Bitmap(bitmapdata);
			trace("我接受到数据了");
			return bitmap;
		}
	}

}