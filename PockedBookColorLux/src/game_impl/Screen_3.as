package game_impl
{
	import flash.display.*;
	
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
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var firstDelay				:int = 0;
		private var firstDelayMax			:int = 24;
		
		private var luminosityCount			:int = 0;
		private var luminosityCountMax		:int = 320*240*0.5;
		
		private var drawCavwas				:Sprite = new Sprite();
		
		public function Screen_3() {
			this.setStepsCount(0);
			
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
			
			container.addChild(light);
			light.x = 320;
			light.y = 255;
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
			
			drawCavwas.graphics.clear();
			drawCavwas.graphics.beginFill(0xffffff, 0.2);
			//drawCavwas.graphics.drawRect(10, 250, luminosityCount*(790/luminosityCountMax), 30);
			drawCavwas.graphics.drawCircle(400, 350, luminosityCount*(390/luminosityCountMax));
			drawCavwas.graphics.endFill();
			
			if(luminosityCount > luminosityCountMax){
				this.nextStep();
				luminosityCount = 0;
				firstDelay = 0;
			}
		}
	}
}