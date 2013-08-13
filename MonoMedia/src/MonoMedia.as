package
{
	import flash.display.*;
	import flash.events.*;
	
	import MonoCore.*;
	
	[SWF(width="1280", height="720", frameRate="20", backgroundColor="#111111")]
	
	public class MonoAR extends Sprite
	{
		private var colorWorks:ColorWorks;
		private var helpers:Helpers;
		
		public function MonoAR() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(event:Event):void {
			try{
				stage.align = StageAlign.TOP;
				//stage.displayState = StageDisplayState.FULL_SCREEN;
				//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}catch(e:Error){
				trace(e);
			}
			
			// Color Works
			colorWorks = new ColorWorks();
			colorWorks.addEventListener("initApp", initApp);
			colorWorks.addEventListener("WithoutWebCam", initAppWithoutWebCam);
			colorWorks.init();
			
			
			addEventListener(Event.ENTER_FRAME, loop);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function initApp(event:Event):void {
			//this.addChild(graphicContainer);
			this.addChild(colorWorks.webCam.vid1);
			this.setChildIndex(colorWorks.webCam.vid1, 0);
			helpers.setObjPos(colorWorks.webCam.vid1, 179, 120, 1.1, 1.1);
			
			/*// To Del
			this.addChild(camSprite);
			camSprite.addChild(colorWorks.debugCapture);
			colorWorks.debugCapture.alpha = 1;
			camSprite.addChild(colorWorks.debugSprite);
			camSprite.addChild(colorWorks.target);
			setObjPos(camSprite, 370*0.9+5, 5, -0.9, 0.9);
			camSprite.visible = isDebug;
			*/
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, colorWorks.keyboardHandlers);
			
			colorWorks.removeEventListener("initApp", initApp);
		}
		
		public function initAppWithoutWebCam(event:Event):void {
			colorWorks.removeEventListener("WithoutWebCam", initAppWithoutWebCam);
		}
		
		public function loop(event:Event):void {
			
		}
	}
}