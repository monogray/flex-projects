package
{
	import colors_work.ColorWorks;

	public class Globals
	{
		public static var webcam			:WebCamProcessing;
		public static var colorWorks		:ColorWorks;
		
		public function Globals()
		{
		}
		
		public static function setWebcam(_webcam:WebCamProcessing):void {
			webcam = _webcam;
		}
		
		public static function setColorWorks(_colorWorks:ColorWorks):void {
			colorWorks = _colorWorks;
		}
	}
}