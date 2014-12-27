package script.com.zbf.net{
    import flash.net.Socket;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    public class ClientSocket extends Socket {
        public function ClientSocket(ip:String,port:uint) {
            super(ip,port);
            addEventListener("connect",socketConnect);
            addEventListener("socketData",socketData);
            addEventListener("ioError",ioError);
        }
        public function send(src:String) {
            writeUTFBytes(src);
            writeByte(10);
            flush();
        }
        private function socketConnect(event:Event) {
            send("hello world");
        }
        private function socketData(event:ProgressEvent) {
            trace(readUTFBytes(bytesAvailable));
        }
        private function ioError(event:IOErrorEvent) {
            trace("connect error");
        }
    }
}