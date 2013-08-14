package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	import flash.display.*;
	import flash.events.Event;
	
	import colors_work.ColorWorks;
	
	import game_impl.*;
	
	[SWF(width='760', height='760', backgroundColor='#6b6e70', frameRate='30')]
	
	public class PockedBookColorLux extends Sprite
	{
		private var globals			:Globals;
		private var game			:GameCore;
		
		private var label			:TextField;
		
		public function PockedBookColorLux() {
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			var webcamEntety:WebCamProcessing = new WebCamProcessing();
			webcamEntety.initExternal(stage);
			Globals.setWebcam(webcamEntety);
			
			var colorWorks:ColorWorks = new ColorWorks();
			colorWorks.setCapture( webcamEntety.getCapture() );
			colorWorks.initApp();
			Globals.setColorWorks(colorWorks);
			
			game = new GameCore();
			this.addChild( game.getScreensContainer() );
			
			createScreens();
			
			webcamEntety.scaleX = 0.5;
			webcamEntety.scaleY = 0.5;
			this.addChild(webcamEntety);
			
			Globals.colorWorks.getDebugCapture().scaleX = 0.5;
			Globals.colorWorks.getDebugCapture().scaleY = 0.5;
			this.addChild( Globals.colorWorks.getDebugCapture() );
			Globals.colorWorks.getDebugCapture().x = 325/2;
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			label = new TextField();
			label.text = "Test";
			this.addChild(label);
		}
		
		private function createScreens():void {
			var screen0:Screen_0 = new Screen_0();
			game.pushScreen(screen0);
			var screen1:Screen_1 = new Screen_1();
			game.pushScreen(screen1);
			var screen1_2:Screen_1_2 = new Screen_1_2();
			game.pushScreen(screen1_2);
			var screen3:Screen_3 = new Screen_3();
			game.pushScreen(screen3);
			var screen2:Screen_2 = new Screen_2();
			game.pushScreen(screen2);
			var screen2_2:Screen_2_2 = new Screen_2_2();
			game.pushScreen(screen2_2);
			//var screen4:Screen_4 = new Screen_4();
			//game.pushScreen(screen4);
			var screen5:Screen_5 = new Screen_5();
			game.pushScreen(screen5);
		}
		
		private function loop(e:Event):void {
			try{
				game.loop();
			}catch(e:Error){
				label.text = String(e);
			}
		}
	}
}