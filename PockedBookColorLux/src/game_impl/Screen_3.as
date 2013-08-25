package game_impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_3 extends ScreenCore
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
		
		[Embed(source = '../../assets/screen_4/light.png')]
		private var lightClass		:Class;
		private var light			:Bitmap = new lightClass();
		
		[Embed(source = '../../assets/screen_1/pk-lightOff.png')]
		private var pkClass1			:Class;
		private var pkOff				:Bitmap = new pkClass1();
		
		[Embed(source = '../../assets/screen_1/pocket-on.png')]
		private var pkClass2			:Class;
		private var pkOn				:Bitmap = new pkClass2();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var firstDelay				:int = 0;
		private var firstDelayMax			:int = 24;
		
		private var luminosityCount			:int = 0;
		private var luminosityCountMax		:int = 320*240*0.5;
		
		private var drawCavwas				:Sprite = new Sprite();
		
		private var isToNext			:Boolean = false;
		
		public function Screen_3() {
			this.setStepsCount(0);
			
			container.addChild(bg);
			
			container.addChild(pkOff);
			setPos(pkOff, 155, 30).setScale(pkOff, 1.5, 1.5);
			container.addChild(pkOn);
			setPos(pkOn, 155, 30).setScale(pkOn, 1.5, 1.5);
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(690, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
			
			container.addChild(light);
			this.setPos(light, 700, 20).setScale(light, 0.5, 0.5);
			light.alpha = 0.9;
		}
		
		public override function clickNext(e:Event):void {
			isToNext = true;
		}
		
		public override function beforShow():void {
			toFirstSatate();
		}
		
		public override function beforHide():void {
			toFirstSatate();
		}
		
		public function toFirstSatate():void {
			pkOn.alpha = 0;
			light.alpha = 0.9;
			
			isToNext = false;
			luminosityCount = 0;
			firstDelay = 0;
		}
		
		public override function loop():void {
			Globals.colorWorks.createColorVector();
			Globals.colorWorks.rgbColorVectorToGrayscale();
			Globals.colorWorks.createGrayVectorTmp();
			Globals.colorWorks.luminosityDetection();
			Globals.colorWorks.deleteNoiseInVector(Globals.colorWorks.getLuminosityVector(), 2);
			Globals.colorWorks.drawBinaryColorVector( Globals.colorWorks.getLuminosityVector() );
			//Globals.colorWorks.drawColorVector( Globals.colorWorks.getGrayVector() );
			
			luminosityCount = (luminosityCount + Globals.colorWorks.getLuminosityCount()) / 2;
			
			if(firstDelay < firstDelayMax){
				firstDelay++;
				luminosityCount = 0;
			}
			
			//drawCavwas.graphics.clear();
			//drawCavwas.graphics.beginFill(0xffffff, 0.2);
			//drawCavwas.graphics.drawCircle(400, 350, luminosityCount*(390/luminosityCountMax));
			//drawCavwas.graphics.endFill();
			
			if(luminosityCount > luminosityCountMax){
				isToNext = true;
			}
			
			if(isToNext){
				pkOn.alpha += 0.03;
				if(light.alpha > 0) light.alpha -= 0.05;
				if(pkOn.alpha > 2)
					this.nextStep();
			}
		}
	}
}