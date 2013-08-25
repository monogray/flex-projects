package game_impl
{
	import flash.display.*;
	import flash.events.*;
	
	import screens.ScreenCore;
	import mono_core.ButtonCore;
	
	public class Screen_0 extends ScreenCore
	{
		[Embed(source = '../../assets/screen_0/start_bg.jpg')]
		private var bgClass:Class;
		private var bg:Bitmap = new bgClass();
		
		[Embed(source = '../../assets/screen_0/without-webcam.png')]
		private var bt1Class:Class;
		private var bt1:Bitmap = new bt1Class();
		
		[Embed(source = '../../assets/screen_0/with-webcam.png')]
		private var bt2Class:Class;
		private var bt2:Bitmap = new bt2Class();
		
		private var drawCavwas			:Sprite = new Sprite();
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		public function Screen_0() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(460, 650).addEventListener("CLICK", clickWith);
			bt_2.addBitmap(bt2).setPosition(80, 650).addEventListener("CLICK", clickWithout);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
		}
		
		public function clickWith(e:Event):void {
			this.nextStep();
		}
		
		public function clickWithout(e:Event):void {
			this.nextStep();
		}
		
		public override function loop():void {
			if(Globals.webcam.getCam().getCamera().muted){
				bt_2.getContainer().visible = false;
				bt_1.setPosition(300, 650);
			}else{
				bt_2.getContainer().visible = true;
				bt_1.setPosition(460, 650);
			}
		}
	}
}

