package screens
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mono_core.SpriteCore;
	
	public class ScreenCore extends SpriteCore
	{
		protected var currentStep			:int = 0;
		protected var stepLen				:int = 0;
		protected var container				:Sprite = new Sprite();
		protected var isVisible				:Boolean = false;
		
		protected var screenW				:int = 800;
		protected var screenH				:int = 800;
		
		public function ScreenCore(){
			super();
			container.addChild( getLabel() );
			hideImmediately();
		}
		
		public function getCurrentStep():int {
			return currentStep;
		}
		
		public function nextStep():void {
			currentStep++;
			if(currentStep > stepLen){
				dispatchEvent( new Event("NextScreen") );
				currentStep = 0;
			}
		}
		
		public function prevStep():void {
			currentStep--;
			if(currentStep < 0){
				dispatchEvent( new Event("PrevScreen") );
				currentStep = 0;
			}
		}
		
		public function setStepsCount(_stepsCount:int):void {
			stepLen = _stepsCount;
		}
		
		public function getContainer():Sprite {
			return container;
		}
		
		public function addChildToContainer(_child:Sprite):void {
			container.addChild(_child);
		}
		
		public function clickNext(e:Event):void {
			this.nextStep();
		}
		
		public function clickPrev(e:Event):void {
			this.prevStep();
		}
		
		public function hide():void {
			if(isVisible != false){
				beforHide();
				TweenLite.to(container, 0.5, {x:-screenW, y:0, ease:Bounce.easeOut});
				isVisible = false;
			}
		}
		
		public function hideImmediately():void {
			//beforHide();
			TweenLite.to(container, 0, {x:-screenW, y:0});
			isVisible = false;
		}
		
		public function show():void {
			if(isVisible != true){
				beforShow();
				container.x = screenW;
				TweenLite.to(container, 0.5, {x:0, y:0, ease:Bounce.easeOut});
				isVisible = true;
			}
		}
		
		public function beforShow():void {
		}
		
		public function beforHide():void {
		}

		public function loop():void {
		}
	}
}