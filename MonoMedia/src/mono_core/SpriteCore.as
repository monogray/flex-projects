package mono_core
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class SpriteCore extends Sprite
	{
		private var label			:TextField;
		private var format			:TextFormat = new TextFormat();
		private var labelText		:String = "";
		
		public function SpriteCore() {
			configureLabel();
		}
		
		public function setLabelText(_str:String):void {
			labelText = _str;
			label.text = labelText;
		}
		
		public function getLabel():TextField {
			return label;
		}
		
		public function configureTextFormat():void {
			format.font = "Verdana";
			format.color = 0xFF0000;
			format.size = 10;
			format.underline = true;
		}
		
		private function configureLabel():void {
			label = new TextField();
			label.autoSize = TextFieldAutoSize.LEFT;
			label.background = false;
			label.border = false;
			
			label.x = 100;
			
			label.defaultTextFormat = format;
			addChild(label);
		}
		
		public function setPos(_obj:Sprite, _x:int, _y:int):void {
			_obj.x = _x;
			_obj.y = _y;
		}
		
		public function addValueToVectorPool_number(_vector:Vector.<Number>, _value:Number):void {
			var _len:int = _vector.length - 1;
			for(var i:int; i < _len; i++){
				_vector[i] = _vector[i+1];
			}
			_vector[_len] = _value;
		}
	}
}