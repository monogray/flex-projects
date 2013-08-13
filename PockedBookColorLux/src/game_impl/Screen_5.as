package game_impl
{
	import flash.display.*;
	import screens.ScreenCore;
	
	public class Screen_5 extends ScreenCore
	{
		[Embed(source = '../../assets/global/bg.jpg')]
		private var bgClass		:Class;
		private var bg			:Bitmap = new bgClass();
		
		private var drawCavwas			:Sprite = new Sprite();
		
		public function Screen_5() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			container.addChild(drawCavwas);
		}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == 0)
				Globals.webcam.setCurrentState(1);
		}
		
		public override function loop():void {
		}
	}
}
