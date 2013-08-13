package webcam
{
	import flash.events.Event;
	
	public class WebCamEvent extends Event
	{
		public static const WEB_CAM_ADDED			:String = "webCamAdded";
		public static const WEB_CAM_ADDED_ERROR		:String = "webCamAddedError";
		
		public function WebCamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}

}