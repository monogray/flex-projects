package game_impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_2 extends ScreenCore
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
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var firstDelay			:int = 0;
		private var firstDelayMax		:int = 24;
		
		private var motionCount			:int = 0;
		private var motionCountMax		:int = 320*240*0.5;
		private var motionCountMax2		:int = 320*240*0.95;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var isEnd				:Boolean = false;
		private var endCounter			:int = 0;
		private var endCounterMax		:int = 5;
		
		public function Screen_2() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 680).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(680, 680).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
		}
		
		public override function loop():void {
			Globals.colorWorks.createColorVector();
			Globals.colorWorks.motionDetection();
			Globals.colorWorks.deleteNoiseInVector(Globals.colorWorks.getColorMotionVector(), 7);
			
			if(firstDelay < firstDelayMax){
				Globals.colorWorks.createColorVectorTmpImmediately();
			}else{
				Globals.colorWorks.createColorVectorTmp();
			}
			
			Globals.colorWorks.drawBinaryColorVector( Globals.colorWorks.getColorMotionVector() );
			
			motionCount = (motionCount * 3 + Globals.colorWorks.getMotionCount()) / 4;
			if(motionCount > motionCountMax2)
				motionCount = 0;
			
			if(firstDelay < firstDelayMax){
				firstDelay++;
				motionCount = 0;
			}
			
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.2);
			//drawCavwas.graphics.drawRect(10, 250, motionCount*(790/motionCountMax), 30);
			drawCavwas.graphics.drawCircle(400, 350, motionCount*(390/motionCountMax));
			drawCavwas.graphics.endFill();
			
			if(motionCount > motionCountMax && motionCount < motionCountMax2){
				isEnd = true;
			}
			
			if(isEnd){
				endCounter++;
				drawCavwas.graphics.clear();
				if(endCounter > endCounterMax){
					isEnd = false;
					endCounter = 0;
					this.nextStep();
					motionCount = 0;
					firstDelay = 0;
				}

			}
		}
	}
}

