package MonoCore
{
	import flash.display.*;
	import flash.events.*;
	
	public class Helpers extends Sprite
	{
		
		public function Helpers(){
		}
		
		/* Set Object Position */
		public function setObjPos(_target:Object, _x:Number=0, _y:Number=0, _xScale:Number=1, _yScale:Number=1):void{
			_target.x = _x;
			_target.y = _y;
			_target.scaleX = _xScale;
			_target.scaleY = _yScale;
		}
	}
}