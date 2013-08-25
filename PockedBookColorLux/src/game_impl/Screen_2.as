package game_impl
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_2 extends ScreenCore
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
		
		[Embed(source = '../../assets/screen_1/content.png')]
		private var pkClass1			:Class;
		private var pkOff				:Bitmap = new pkClass1();
		
		[Embed(source = '../../assets/screen_1/pocket-on.png')]
		private var pkClass2			:Class;
		private var pkOn				:Bitmap = new pkClass2();
		private var content				:Sprite = new Sprite();
		private var contentMask			:Sprite = new Sprite();
		
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
			this.setStepsCount(2);
			container.addChild(bg);
			
			contentMask.graphics.beginFill(0xff0000, 1);
			contentMask.graphics.drawRect(0, 0, 363, 550);
			contentMask.graphics.endFill();
			setPos(contentMask, 210, 90)
			
			container.addChild(pkOn);
			setPos(pkOn, 155, 30).setScale(pkOn, 1.5, 1.5);
			
			content.addChild(pkOff);
			container.addChild(content);
			setPos(content, 210, 90).setScale(content, 1.5, 1.5);
			
			content.mask = contentMask;
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
		}
		
		public override function beforHide():void {
			motionCount = 0;
			isEnd = false;
			setPos(content, 210, 90);
		}
		
		public override function clickNext(e:Event):void {
			isEnd = true;
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
			/*drawCavwas.graphics.beginFill(0xffffff, 0.3);
			drawCavwas.graphics.drawCircle(400, 350, motionValMedian*(390/motionCountMax));
			drawCavwas.graphics.drawCircle(400, 350, motionCount*(390/motionCountMax));
			drawCavwas.graphics.endFill();*/
			
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
				/*endCounter++;
				drawCavwas.graphics.clear();
				if(endCounter > endCounterMax){
					isEnd = false;
					endCounter = 0;
					this.nextStep();
					motionCount = 0;
					firstDelay = 0;
				}*/
				
				if(this.currentStep == 0){
					TweenLite.to(content, 0.8, {x:-153, ease:Bounce.easeOut});
					isEnd = false;
					this.nextStep();
					firstDelay = 0;
				}else if(this.currentStep == 1){
					TweenLite.to(content, 0.8, {x:-520, ease:Bounce.easeOut});
					isEnd = false;
					this.nextStep();
					firstDelay = 0;
				}else if(this.currentStep == 2){
					this.nextStep();
					firstDelay = 0;
				}
			}
		}
	}
}

