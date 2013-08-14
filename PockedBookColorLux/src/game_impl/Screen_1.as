package game_impl
{
	import flash.display.*;
	import flash.events.*;
	
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
		
		private var voiceCount			:int = 0;
		private var voiceCountMax		:int = 1000;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var voiceVal			:Vector.<Number> = new Vector.<Number>(35);
		private var voiceValMedian		:int = 0;
		
		public function Screen_1() {
			this.setStepsCount(0);
			container.addChild(bg);
			
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
			voiceCount += 1000;
		}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == -1)
				Globals.webcam.setCurrentState(0);
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
			
			putNext( Globals.webcam.getMicrophoneActivityLevel() );
			
			
			drawCavwas.graphics.moveTo(20, 250);
			
			var _median:int = 0
			for(var i:int = 0; i < voiceVal.length; i++){
				drawCavwas.graphics.beginFill(0xffffff, 1);
				drawCavwas.graphics.lineStyle(2, 0xffff00);
				//drawCavwas.graphics.drawRect(i*2 + 20, 250, 2, -voiceVal[i]);
				drawCavwas.graphics.endFill();
				
				drawCavwas.graphics.lineTo(i*2 + 20, 250-voiceVal[i]);
				if(i > 0 && i < voiceVal.length-1){
					if( voiceVal[i] - voiceVal[i-1] > 0 && voiceVal[i] - voiceVal[i-1] > 40 && voiceVal[i] - voiceVal[i+1] > 0 || voiceVal[i] > 99 ) {
					if( voiceVal[i] > voiceValMedian*1.1 ){
						drawCavwas.graphics.beginFill(0xff0000, 1);
						drawCavwas.graphics.lineStyle();
						drawCavwas.graphics.drawRect(i*2 + 20, 250, 2, -voiceVal[i]*1.2);
						drawCavwas.graphics.endFill();}
					}
				}
				_median += voiceVal[i];
				
				if(voiceVal[i] > 0)
					voiceVal[i] = (-101+voiceVal[i])*0.5;
				else 
					voiceVal[i] = 0;
			}
			
			voiceValMedian = _median/voiceVal.length;
			drawCavwas.graphics.lineStyle(2, 0x00ff00);
			drawCavwas.graphics.moveTo(20, 250-voiceValMedian);
			drawCavwas.graphics.lineTo(voiceVal.length*2 + 20, 250-voiceValMedian);
			
			//if(voiceCount > voiceCountMax){
				//this.nextStep();
				//voiceCount = 0;
				//drawCavwas.graphics.clear();
			//}
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