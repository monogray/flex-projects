package mono_core
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class ButtonCore extends Sprite
	{
		private var container		:Sprite = new Sprite();
		
		public function ButtonCore()
		{
			container.addEventListener(MouseEvent.CLICK, click);
			container.addEventListener(MouseEvent.MOUSE_OVER, over);
			container.addEventListener(MouseEvent.MOUSE_OUT, out);
		}
		
		public function click(e:MouseEvent):void {
			dispatchEvent( new Event("CLICK") );
		}
		
		public function over(e:MouseEvent):void {
			container.alpha = 0.8;
			Mouse.cursor = "button";
			dispatchEvent( new Event("MOUSE_OVER") );
		}
		
		public function out(e:MouseEvent):void {
			container.alpha = 1;
			Mouse.cursor = "auto";
			dispatchEvent( new Event("MOUSE_OUT") );
		}
		
		public function getContainer():Sprite {
			return container;
		}
		
		public function addBitmap(_bmp):ButtonCore {
			container.addChild(_bmp);
			return this;
		}
		
		public function setPosition(_x:Number, _y:Number):ButtonCore {
			container.x = _x;
			container.y = _y;
			return this;
		}
	}
}