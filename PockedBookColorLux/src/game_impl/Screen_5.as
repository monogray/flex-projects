package game_impl
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	import flash.net.*;
	
	public class Screen_5 extends ScreenCore
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
		
		private var drawCavwas			:Sprite = new Sprite();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		public function Screen_5() {
			this.setStepsCount(0);
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", postTofacebok);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
		}
		
		public function postTofacebok(e:Event):void {
			/*var request:URLRequest = new URLRequest();
			request.url = "http://sand.test.irst-ukraine.com.ua/ar-app/index.php?mod=publish";
			request.method = URLRequestMethod.GET;
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			try	{
				loader.load(request);
			}catch (error:Error){
				trace("Unable to load URL");
			}*/
			var url:URLRequest = new URLRequest("http://sand.test.irst-ukraine.com.ua/ar-app/index.php?mod=publish&id="+Globals.webcam.id);
				navigateToURL(url, "_self");
		}
		
		public override function beforShow():void {
			if(Globals.webcam.getCurrentState() == 0)
				Globals.webcam.setCurrentState(1);
		}
		
		public override function loop():void {
		}
	}
}
