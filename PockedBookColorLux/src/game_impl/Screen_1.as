package game_impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_1 extends ScreenCore
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
		
		private var voiceCount			:Number = 0;
		private var voiceCountMax		:Number = 1000;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var voiceVal			:Vector.<Number> = new Vector.<Number>(25);
		private var voiceValMedian		:Number = 0;
		private var isNext				:Boolean;
		
		private var video1				:Video = new Video(760, 760);
		private var ns					:NetStream;
		
		private var isPlayed			:Boolean = false;
		private var isToNext			:Boolean = false;
		
		private var voiceVideo			:Number = 0;
		private var voiceVideoTo		:Number = 0;
		
		public function Screen_1() {
			container.addChild(bg);
			
			openVideo2();
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
			
			container.addChild(voice);
			this.setPos(voice, 305, 255);
			voice.alpha = 0.8;
		}
		
		public function next(e:MouseEvent):void {
			//voiceCount += 1000;
			isToNext = true;
		}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == -1)
				Globals.webcam.setCurrentState(0);
			
			if(!isPlayed) {
				ns.togglePause();
			}
			isPlayed = true;
			isToNext = false;
			
			voiceCount = 0;
			voiceVideoTo = 0;
		}
		
		public override function beforHide():void {
			if(isPlayed) {
				ns.togglePause();
			}
			isPlayed = false;
			isToNext = false;
			ns.seek(0);
		}
		
		public override function loop():void {
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.5);
			drawCavwas.graphics.drawCircle(400, 350, voiceCount*(390/voiceCountMax));
			drawCavwas.graphics.endFill();
			
			//var _voiceValue:Number = Globals.webcam.getMicrophoneActivityLevelIsActive()*0.8;
			//if(_voiceValue < 30) _voiceValue = 0;
			//voiceCount += _voiceValue;
			//voiceCount += (voiceCount < 0)?0:-15;
			
			putNext( Math.abs(Globals.webcam.getMicrophoneActivity()*100) );
			
			drawCavwas.graphics.moveTo(20, 250);
			
			var _median:int = 0
			for(var i:int = 0; i < voiceVal.length; i++){
				drawCavwas.graphics.beginFill(0xffffff, 1);
				drawCavwas.graphics.lineStyle(2, 0xffff00);
				//drawCavwas.graphics.drawRect(i*2 + 20, 250, 2, -voiceVal[i]);
				drawCavwas.graphics.endFill();
				
				drawCavwas.graphics.lineTo(i*2 + 20, 250-voiceVal[i]);
				if(i > 0 && i < voiceVal.length-1) {
					//if( voiceVal[i] - voiceVal[i-1] > 0 && voiceVal[i] - voiceVal[i-1] > 40 && voiceVal[i] - voiceVal[i+1] > 0 ) {
					//if(true){
					if( voiceValMedian > 25 && voiceVal[i] > voiceValMedian*2.5){
						drawCavwas.graphics.beginFill(0xff0000, 1);
						drawCavwas.graphics.lineStyle();
						drawCavwas.graphics.drawRect(i*2 + 20, 250, 2, -voiceVal[i]*1.2);
						drawCavwas.graphics.endFill();
						
						isNext = true;
					}
					//}
					
					voiceVal[i] = (voiceVal[i]*9 + voiceVal[i+1])/10;
				}
				if(i < voiceVal.length)
					_median += voiceVal[i];
				
				/*if(voiceVal[i] > 0)
					voiceVal[i] *= 0.99;
				else 
					voiceVal[i] = 0;*/
			}
			
			voiceValMedian = _median/(voiceVal.length/2);
			drawCavwas.graphics.lineStyle(2, 0x00ff00);
			drawCavwas.graphics.moveTo(20, 250-voiceValMedian);
			drawCavwas.graphics.lineTo(voiceVal.length*2 + 20, 250-voiceValMedian);
			
			if(voiceValMedian > 50){
				// TO NOISY
				drawCavwas.graphics.beginFill(0xff0000, 1);
				drawCavwas.graphics.drawRect(350, 50, 50, 50);
			}else{
				if(isNext){
					drawCavwas.graphics.beginFill(0x00ff00, 1);
					drawCavwas.graphics.drawRect(350, 50, 50, 50);
					isNext = false;
					
					isToNext = true;
				}
			}
			
			
			if(isToNext){
				voiceCount += 0.9;
			}
			
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
			
			if(ns.time*20 > 75){
				this.nextStep();
			}
			
			//if(voiceCount > voiceCountMax){
				//this.nextStep();
				//voiceCount = 0;
				//drawCavwas.graphics.clear();
			//}
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
		
		private function putNext(_val:Number):void {
			voiceVal[voiceVal.length - 1] = _val;
			var _len:int = voiceVal.length-1;
			for(var i:int = 0; i < _len; i++){
				voiceVal[i] = voiceVal[i+1];
			}
		}
	}
}