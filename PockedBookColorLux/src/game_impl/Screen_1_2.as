package game_impl
{
	import flash.display.*;
	import flash.events.*;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	import flash.media.*;
	import flash.net.*;
	
	public class Screen_1_2 extends ScreenCore
	{
		[Embed(source = '../../assets/global/bg.jpg')]
		private var bgClass				:Class;
		private var bg					:Bitmap = new bgClass();
		
		[Embed(source = '../../assets/global/back.png')]
		private var bt1Class			:Class;
		private var bt1					:Bitmap = new bt1Class();
		
		[Embed(source = '../../assets/global/next.png')]
		private var bt2Class			:Class;
		private var bt2					:Bitmap = new bt2Class();
		
		[Embed(source = '../../assets/screen_1/voice.png')]
		private var voiceClass			:Class;
		private var voice				:Bitmap = new voiceClass();
		
		private var vid					:Video = new Video(810, 760);
		private var ns					:NetStream;
		
		private var voiceCount			:Number = 0;
		private var voiceCountMax		:Number = 1000;
		
		private var voiceVideo			:Number = 0;
		private var voiceVideoTo		:Number = 0;
		private var voiceVideoCountMax	:Number = 500;
		
		private var isPlayed			:Boolean = false;
		private var isToNext			:Boolean = false;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		public function Screen_1_2() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			openVideo2();
			
			container.addChild(drawCavwas);
			
			container.addChild(voice);
			this.setPos(voice, 700, 20).setScale(voice, 0.5, 0.5);
			voice.alpha = 0.9;
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(690, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
		}
		
		public override function clickNext(e:Event):void {
			isToNext = true;
		}
		
		//public function next(e:MouseEvent):void {
			//voiceCount += 1000;
		//}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == -1)
				Globals.webcam.setCurrentState(0);
			
			if(!isPlayed) {
				ns.togglePause();
			}
			isPlayed = true;
			isToNext = false;
		}
		
		public override function beforHide():void {
			voiceVideo = 0;
			voiceVideoTo = 0;
			voiceCount = 0;
			
			if(isPlayed) {
				ns.togglePause();
			}
			isPlayed = false;
			isToNext = false;
			ns.seek(0);
		}
		
		public override function loop():void {
			/*drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.5);
			drawCavwas.graphics.drawCircle(400, 350, voiceCount*(390/voiceCountMax));
			drawCavwas.graphics.drawCircle(400, 350, ns.time*20*(390/voiceCountMax));
			drawCavwas.graphics.endFill();*/
			
			var _voiceValue:Number;
			if(!isToNext){
				_voiceValue = Globals.webcam.getMicrophoneActivityLevelIsActive() * 0.6;
				if(_voiceValue < 60) _voiceValue = 0;
				voiceCount += _voiceValue/20;
				//voiceCount += (voiceCount < voiceVideo)?0:-voiceCount/5;
			}else{
				voiceCount += 20;
			}
			
			if(voiceVideo < voiceCount) {
				voiceVideo = voiceCount;
			}
			
			if(voiceVideoTo < voiceVideo) {
				voiceVideoTo = voiceVideo;
			}
			
			//if(ns.time*20 < voiceVideoTo) {
			if(_voiceValue != 0) {
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
			
			if(ns.time*20 > 20){
				this.nextStep();
			}
		}
		
		protected function openVideo2():void {
			container.addChild(vid);
			
			var nc:NetConnection = new NetConnection();
			nc.connect(null);
			ns = new NetStream(nc);
			//ns.client = customClient;
			vid.attachNetStream(ns);
			
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