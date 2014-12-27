package script.com.zbf.net
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import script.com.zbf.interfac.IReceiveMessage;
	
	public class MySocket extends Sprite
	{
		var socket:Socket;
		var isMainEngine:Boolean;
		public var receiver:IReceiveMessage;
		
		public function MySocket()
		{
			init();
		}
		
		public function init(host:String = "127.0.0.1", port:int = 6666)
		{
			socket = new Socket();
			socket.timeout = 50000;
			socket.addEventListener(Event.CONNECT, onConnect);
			socket.connect(host, port);
		}
		
		private function onConnect(event:Event):void
		{
			trace("你他妈是傻逼吗");
			writeData("连接成功！Connected......");
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSendData);
		}
		
		/**
		 * 接收到数据触发这个事件
		 * @param	e
		 */
		private function onSendData(e:ProgressEvent)
		{
			if (socket)
			{
				while (socket.bytesAvailable)
				{
					var msg:String = socket.readUTFBytes(socket.bytesAvailable);
					trace(msg);
					if(receiver)
					receiver.receive(msg);
					//socket.writeUTFBytes("I receive it!");
					//socket.flush();
				}
			}
		}
		
		public function writeData(msg:String)
		{
			if (socket)
			{
				socket.writeUTFBytes(msg + "\n");
				socket.flush();
			}
		}
	}
}

