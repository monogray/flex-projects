package video
{
	//import fl.video.*;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	
	public class ExternalVideo extends MovieClip
	{
		private	var nc					:NetConnection;
		public	var ns					:NetStream; 
		public	var vid					:Video; 
		private	var volume				:Number = 0;
		
		public function ExternalVideo():void
		{
		}

		public function Pause():void
		{
			if (ns.bytesTotal != 0)
				ns.pause();		
		}
		
		public function resumePause():void
		{
			if (ns.bytesTotal != 0)
				ns.resume();		
		}

		public function getTotalBytes():uint
		{			
			return ns.bytesTotal;
		}		
		
		public function getLoadedBytes():uint {			
			return ns.bytesLoaded;
		}			
		
	
		public function sound_fade_in():void {			
			var st:SoundTransform = new SoundTransform();
			st.volume = volume;
			ns.soundTransform = st;
//			ns.soundTransform.volume=0;
			addEventListener(Event.ENTER_FRAME, fade_in_on_frame);
		}			
		
		private function fade_in_on_frame(event:Event):void
		{
			var st:SoundTransform=new SoundTransform();
			if (volume < 1) {
				volume+=0.02;
				st.volume = volume;
				ns.soundTransform = st;
			}else{
				removeEventListener(Event.ENTER_FRAME, fade_in_on_frame);
			}
		}
		
		public function is_loop():void
		{
			ns.addEventListener(NetStatusEvent.NET_STATUS, loop_event);
		}
		
		private function loop_event(event:NetStatusEvent):void 
		{
			if ( (event.info.code) == "NetStream.Play.Stop" )
				ns.seek(0);			
		}
			
		public function load_video(name_str:String, width:int, height:int):void 
		{
			nc = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			vid = new Video(width, height);
								
			this.addChild(vid);				
			vid.attachNetStream(ns);  
			ns.play(name_str);
			ns.pause();				
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, netstat);
				
			var netClient:Object = new Object();
			netClient.onMetaData = function(meta:Object):void
				{
					//	trace(meta.duration);
				};
			ns.client = netClient;				
		}
		
		private function netstat(stats:NetStatusEvent):void 
		{		
		}
		
	}
}