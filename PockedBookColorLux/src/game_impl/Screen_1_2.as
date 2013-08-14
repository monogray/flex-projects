package game_impl
{
	import flash.display.*;
	import flash.events.*;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	//import video.ExternalVideo;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	public class Screen_1_2 extends ScreenCore
	{
		[Embed(source = '../../assets/global/bg.jpg')]
		private var bgClass		:Class;
		private var bg			:Bitmap = new bgClass();
		
		[Embed(source = '../../assets/global/back.png')]
		private var bt1Class	:Class;
		private var bt1			:Bitmap = new bt1Class();
		
		[Embed(source = '../../assets/global/next.png')]
		private var bt2Class	:Class;
		private var bt2			:Bitmap = new bt2Class();
		
		[Embed(source = '../../assets/screen_1/voice.png')]
		private var voiceClass		:Class;
		private var voice			:Bitmap = new voiceClass();
		
		/*[Embed(source = "../../assets/flv/movie.flv", mimeType = "application/octet-stream")]
		public var movieBytes:Class;*/
		
		private var video1				:Video = new Video(760, 760);
		private var ns			
		:NetStream
		
		private var voiceCount			:int = 0;
		private var voiceCountMax		:int = 1000;
		
		private var voiceVideo			:int = 0;
		private var voiceVideoTo		:Number = 0;
		private var voiceVideoCountMax	:int = 500;
		
		private var isPlayed			:Boolean = false;
		//private var capture1			:Bitmap = new Bitmap( new BitmapData(640, 480, false, 0xff0000) );
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		public function Screen_1_2() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			openVideo2();
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
			
			container.addChild(voice);
			voice.x = 305;
			voice.y = 255;
			voice.alpha = 0.8;
		}
		
		public function next(e:MouseEvent):void {
			voiceCount += 1000;
		}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == -1)
				Globals.webcam.setCurrentState(0);
			isPlayed = true;
			
			ns.togglePause();
		}
		
		public override function beforHide():void {
			voiceVideo = 0;
			voiceVideoTo = 0;
			voiceCount = 0;
			
			isPlayed = false;
			
			ns.togglePause();
			ns.seek(0);
		}
		
		public override function loop():void {
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.5);
			drawCavwas.graphics.drawCircle(400, 350, voiceCount*(390/voiceCountMax));
			drawCavwas.graphics.drawCircle(400, 350, ns.time*20*(390/voiceCountMax));
			drawCavwas.graphics.endFill();
			
			var _voiceValue:Number = Globals.webcam.getMicrophoneActivityLevelIsActive() * 0.8;
			if(_voiceValue < 20) _voiceValue = 0;
			voiceCount += _voiceValue;
			voiceCount += (voiceCount < 0)?0:-15;
			
			if(voiceVideo < voiceCount) {
				voiceVideo = voiceCount;
			}
			
			if(voiceVideoTo < voiceVideo) {
				voiceVideoTo = voiceVideo;
			}
			
			if(ns.time*20 < voiceVideoTo) {
				if(!isPlayed) {
					isPlayed = true;
					ns.togglePause();
				}
			}else {
				if(isPlayed){
					isPlayed = false;
					ns.togglePause();
				}
			}
			
			if(ns.time*20 > 220){
				this.nextStep();
			}
		}
		
		
		
		protected function openVideo2():void {
			container.addChild(video1);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			//ns.client = customClient;
			video1.attachNetStream(ns);
			
			var netClient:Object = new Object();
			netClient.onMetaData = function(meta:Object):void {
				//	trace(meta.duration);
			};
			ns.client = netClient;	
			
			ns.play("http://www.helpexamples.com/flash/video/cuepoints.flv");
			//ns.play("http://pocked-book-ar.eugene.dev.ok/movie.flv");
			
			ns.togglePause();
		}
		
		protected function cuePointHandler(infoObject:Object):void {
			// trace("cuePoint");
		}
		protected function metaDataHandler(infoObject:Object):void {
			// trace("metaData");
		}
		
		/*protected function openVideo():void {
			container.addChild(video1);
			
			var nc:NetConnection = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS , onConnect);
			nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR , trace);
			
			var metaSniffer:Object = new Object();  
			nc.client = metaSniffer;
			//metaSniffer.onMetaData = getMeta;
			nc.connect(null);
		}
		
		private function getMeta(mdata:Object):void {
			video1.width = mdata.width / 2;
			video1.height = mdata.height / 2;
		};
		
		private function onConnect(e:NetStatusEvent):void {
			if (e.info.code == 'NetConnection.Connect.Success') {
				trace(e.target as NetConnection);
				ns = new NetStream(e.target as NetConnection);
				
				ns.client = {};
				var file:ByteArray = new movieBytes();
				
				ns.play(null);
				//ns.pause();
				ns.togglePause();
				
				ns.appendBytes(file);
				video1.attachNetStream(ns);
			}
			
		}*/
	}
}