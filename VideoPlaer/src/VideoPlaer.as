package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import video.ExternalVideo;
	
	[SWF(width='320', height='240', backgroundColor='#6b6e70', frameRate='30')]
	public class VideoPlaer extends Sprite
	{
		private var url				:String = "http://sand.test.irst-ukraine.com.ua/";
		
		public function VideoPlaer()
		{
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			openVideo();
		}
		
		protected function openVideo():void {
			var id:String = this.loaderInfo.parameters["id"];
			var vid:ExternalVideo = new ExternalVideo();
			vid.load_video(url + "videos/video-"+id+".flv", 320, 240);
			vid.resumePause();
			vid.is_loop();
			//vid.scaleX = 3.5;
			//vid.scaleY = 3.5;
			this.addChild(vid);
			//vid.y = 300
			//vid.x = 300;
		}
	}
}