package game_impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
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
		private var motionCountMax		:int = 320*240*0.2; //320*240*0.5;
		private var motionCountMax2		:int = 320*240*0.95;
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var motionVal			:Vector.<Number> = new Vector.<Number>(30);
		private var motionValMedian		:int = 0;
		
		private var isEnd				:Boolean = false;
		private var endCounter			:int = 0;
		private var endCounterMax		:int = 20;
	
		public function Screen_2() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
		}
		
		public override function beforHide():void {
			motionCount = 0;
		}
		
		public override function loop():void {
			Globals.colorWorks.createColorVector();
			Globals.colorWorks.motionDetection();
			Globals.colorWorks.deleteNoiseInVector(Globals.colorWorks.getColorMotionVector(), 7);
			
			if(firstDelay < firstDelayMax){
				Globals.colorWorks.createColorVectorTmpImmediately();
			}else{
				//Globals.colorWorks.createColorVectorTmp();
				Globals.colorWorks.createAdaptiveColorVectorTmp(2);
			}
			
			Globals.colorWorks.drawBinaryColorVector( Globals.colorWorks.getColorMotionVector() );
			
			motionCount = (motionCount * 2 + Globals.colorWorks.getMotionCount()) / 3;
			if(motionCount > motionCountMax2)
				motionCount = 0;
			
			putValueInVector_number(motionVal, motionCount);
			motionValMedian = getMedianFromVector_number(motionVal) * 1.5;
			
			if(firstDelay < firstDelayMax){
				firstDelay++;
				motionCount = 0;
			}
			
			
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.3);
			//drawCavwas.graphics.drawRect(10, 250, motionCount*(790/motionCountMax), 30);
			drawCavwas.graphics.drawCircle(400, 350, motionValMedian*(390/motionCountMax));
			drawCavwas.graphics.drawCircle(400, 350, motionCount*(390/motionCountMax));
			drawCavwas.graphics.endFill();
			
			drawCavwas.graphics.moveTo(20, 450);
			for(var i:int = 0; i < motionVal.length; i++){
				drawCavwas.graphics.lineStyle(2, 0xffff00);
				drawCavwas.graphics.lineTo(i*2 + 20, 450-motionVal[i]/100);
			}
			drawCavwas.graphics.lineStyle(2, 0x00ff00);
			drawCavwas.graphics.moveTo(20, 450-motionValMedian/100);
			drawCavwas.graphics.lineTo(motionVal.length*2 + 20, 450-motionValMedian/100);
			
			//if(motionCount > motionCountMax && motionCount < motionCountMax2){
			if(motionCount - motionValMedian > motionCountMax){
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

