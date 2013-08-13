package game_impl
{
	import flash.display.*;
	import flash.events.*;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_1 extends ScreenCore
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
		
		private var voiceCount			:int = 0;
		private var voiceCountMax		:int = 1000;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		public function Screen_1() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 680).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(680, 680).addEventListener("CLICK", clickNext);
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
		}
		
		public override function loop():void {
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.5);
			drawCavwas.graphics.drawCircle(400, 350, voiceCount*(390/voiceCountMax));
			drawCavwas.graphics.endFill();
			
			var _voiceValue:Number = Globals.webcam.getMicrophoneActivityLevelIsActive()*0.8;
			if(_voiceValue < 20) _voiceValue = 0;
			voiceCount += _voiceValue;
			voiceCount += (voiceCount < 0)?0:-15;
			
			if(voiceCount > voiceCountMax){
				this.nextStep();
				voiceCount = 0;
				drawCavwas.graphics.clear();
			}
		}
	}
}