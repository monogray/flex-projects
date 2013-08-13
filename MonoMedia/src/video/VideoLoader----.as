package  media.video
{

	import flash.display.Sprite;
	import flash.events.*;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class VideoLoader extends Sprite {
		public var videoURL						:String;
		protected var connection				:NetConnection;
		public var stream						:NetStream;
		public var video						:Video = new Video();
		public var VideoWidth					:int = 0;
		public var VideoHeight					:int = 0;
		public var isReplay						:Boolean = false;
		
		//public var customClient:Object = {onMetaData:metaDataHandler};
		protected var customClient				:Object = new Object();
		
		// Errors
		public var errorMasage:String = "";
		
		public function VideoLoader()
		{
		}
		
		public function init( urlStr:String, replayVideo:Boolean = false, _width:int=0, _height:int=0 ):void
		{
			videoURL = urlStr;
			VideoWidth = _width;
			VideoHeight = _height;
			isReplay = replayVideo;
			
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					errorMasage += "Unable to locate video: " + videoURL + ";\n";
					break;
			}
		}
		
		public function connectStream():void
		{
			//var stream:NetStream = new NetStream(connection);
			stream = new NetStream(connection);
			customClient.onMetaData = metaDataHandler;
			stream.client = customClient;
			
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			
			video = new Video(VideoWidth, VideoHeight);
			video.attachNetStream(stream);
			stream.play(videoURL);
			stream.pause();	
			
			this.addChild(video);
			
			if (isReplay)
				stream.addEventListener( NetStatusEvent.NET_STATUS, replay );
		}
		
		private function replay( event:NetStatusEvent  ):void
		{
			switch( event.info.code ){
				case "NetStream.Play.Stop":				//проигрывание файла завершено
					event.target.play(videoURL);
					break; 
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			//trace("securityErrorHandler: " + event);
			errorMasage += "securityErrorHandler: " + String(event) + ";\n";
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			// ignore AsyncErrorEvent events.
			errorMasage += "AsyncErrorEvent: " + String(event) + ";\n";
		}
		
		private function metaDataHandler(infoObject:Object):void
		{
			//myVideo.width = infoObject.width;
			//myVideo.height = infoObject.height;
		}
		
		/*public function goTo(_sec:Number):void 		// Dont work
		{
			var _val:Number = 0.08;
			if(_sec < stream.time)
				_val *= -1;
			stream.seek(stream.time+_val);		
		}*/
		
		public function Pause():void
		{
			if (stream.bytesTotal != 0)
				stream.pause();		
		}
		
		public function resumePause():void
		{
			if (stream.bytesTotal != 0)
				stream.resume();		
		}
		
		public function toStart():void
		{
			stream.seek(0);		
		}
		
		public function getNetStream():NetStream
		{
			return stream;		
		}
	}
}