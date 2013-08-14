package
{
	import flash.display.Sprite;
	import flash.events.*;
	
	import screens.ScreenCore;
	
	public class GameCore
	{
		private var screenPool				:Vector.<ScreenCore> = new Vector.<ScreenCore>();
		private var currentScreen			:int = 0;
		private var screensContainer		:Sprite = new Sprite();
		
		public function GameCore() {
		}
		
		public function pushScreen(_screen:ScreenCore):void {
			screenPool.push(_screen);
			screensContainer.addChild( _screen.getContainer() );
			_screen.addEventListener("NextScreen", nextScreen);
			_screen.addEventListener("PrevScreen", prevScreen);
		}
		
		public function getScreenByName(_name:String):ScreenCore {
			for(var i:int = 0; i < screenPool.length; i++){
				if(screenPool[i].name == _name)
					return screenPool[i];
			}
			return null;
		}
		
		public function getScreenById(_id:int):ScreenCore {
			return screenPool[_id];
		}
		
		public function getScreensContainer():Sprite {
			return screensContainer;
		}
		
		private function createScreenByName(_name:String):void {
			var _screen:ScreenCore = new ScreenCore();
			_screen.name = _name;
			pushScreen(_screen);
		}
		
		private function nextScreen(e:Event):void {
			currentScreen++;
			if(currentScreen > screenPool.length-1){
				currentScreen = 0;
			}
		}
		
		private function prevScreen(e:Event):void {
			currentScreen--;
			if(currentScreen < 0){
				currentScreen = screenPool.length-1;
			}
		}
		private function updateScreens():void {
			for(var i:int = 0; i < screenPool.length; i++) {
				if(i == currentScreen)
					screenPool[i].show();
				else
					screenPool[i].hide();
			}
		}
		
		public function loop():void {
			screenPool[currentScreen].loop();
			updateScreens();
		}
	}
}