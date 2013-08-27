package webcam
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	import images.JPGEncoder;
	
	
	public class WebCam extends Sprite
	{
		// WebCam 
		private var vid					:Video;
		private	var cam					:Camera; 
		private	var camId				:int = 0; 
		private var videoOutputWidth	:int = 640;			// Output video resolution;		176x144 320x240
		private var videoOutputHeight	:int = 480;			// Output video resolution;
		private var videoFps			:int = 15;			// Output video fps;
		private	var videoWidth			:int = 320;			// 176x132  320x240  370x278  420x315  500x375  560x420
		private	var videoHeight			:int = 240;
		private	var widthScale			:Number = videoWidth / videoOutputWidth;
		private	var heighScale			:Number = videoHeight / videoOutputHeight;
		
		private	var mat					:Matrix = new Matrix(widthScale, 0, 0, heighScale, 0, 0);
		private var capture				:Bitmap;
		
		private	var imgBD				:BitmapData;
		//private	var imgBitmap		:Bitmap;
		private	var imgBA				:ByteArray;
		private	var jpgEncoder			:JPGEncoder = new JPGEncoder();

		private var info				:String = "";
		
		// Microphone 
		private var mic					:Microphone;
		private var isMicActive			:Boolean = false;
		private var micActivity			:Number = 0;
		
		private var sendLoader			:URLLoader = new URLLoader();
		private var sendHeader			:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
		
		
		public function WebCam() {
		}
		
		public function setupCameraParam(_videoOutputWidth:int, _videoOutputHeight:int, _videoFPS:int, _videoWidth:int, _videoHeight:int):void {
			videoOutputWidth = _videoOutputWidth;
			videoOutputHeight = _videoOutputHeight;
			videoFps = _videoFPS;
			videoWidth = _videoWidth;
			videoHeight = _videoHeight;
			widthScale = _videoWidth/_videoOutputWidth;
			heighScale = _videoHeight/_videoOutputHeight;
			mat = new Matrix(-widthScale, 0, 0, heighScale, videoWidth, 0);
		}
		
		public function setupCamera():void {
			if(Camera.names.length > 0){
				cam = Camera.getCamera(camId.toString());
				cam.setMode(videoOutputWidth, videoOutputHeight, videoFps);
				cam.addEventListener(StatusEvent.STATUS, camera_onStatus);
				
				vid = new Video(videoOutputWidth, videoOutputHeight);
				vid.attachCamera(cam);
				
				imgBD = new BitmapData(vid.width, vid.height);
				
				capture = new Bitmap( new BitmapData(videoWidth, videoHeight, false, 0xff0000) );
				
				this.dispatchEvent( new WebCamEvent(WebCamEvent.WEB_CAM_ADDED) );
			}else{
				this.dispatchEvent( new WebCamEvent(WebCamEvent.WEB_CAM_ADDED_ERROR) );
			}
		}
		
		private function camera_onStatus(e:StatusEvent):void {
			// Camera.Muted or Camera.Unmuted -> User's security
			// trace(event.code)
			if (cam.muted == true)
				info = 'Camera Access Rejected';
			else 
				info = 'Camera Access';
		}
		
		public function createSnapshotToBitmap():void {
			imgBD.draw(vid);
		}
		
		public function sendImageToUrl(_url:String):void {
			imgBA = jpgEncoder.encode(capture.bitmapData);
			
			var sendReq:URLRequest = new URLRequest(_url);
			sendReq.requestHeaders.push(sendHeader);
			sendReq.method = URLRequestMethod.POST;
			sendReq.data = imgBA;
			
			//var sendLoader:URLLoader;				// Вынести!!!!!!!!!!!!
			//sendLoader = new URLLoader();
			//sendLoader.addEventListener(Event.COMPLETE, imageSentHandler);
			sendLoader.load(sendReq);
		}
		
		private function imageSentHandler(event:Event):void {
			//var dataStr:String = event.currentTarget.data.toString();
			//var resultVars:URLVariables = new URLVariables();
			//resultVars.decode(dataStr);
			//imagePath = "http://" + resultVars.base + resultVars.filename;
		}
		
		public function setupMicrophone():void {
			mic = Microphone.getMicrophone();//camId+1);
			setupMicrophoneSettings(70, 44, true, false, 10, -1);
			
			mic.addEventListener(StatusEvent.STATUS, onMicStatus);
			mic.addEventListener(ActivityEvent.ACTIVITY, onMicActivity);
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
			//mic.gain = 80;
			//mic.rate = 44;
			//mic.noiseSuppressionLevel(10);
			//mic.setUseEchoSuppression(true);
			//mic.setLoopBack(true); 
			//mic.setSilenceLevel(0);
		}
		
		public function setupMicrophoneSettings(_gain:int, _rate:int, _useEchoSuppression:Boolean, _loopBack:Boolean, _silenceLevel:Number, _timeout:int=-1):void {
			mic.gain = _gain;
			mic.rate = _rate;
			mic.setUseEchoSuppression(_useEchoSuppression);
			mic.setSilenceLevel(_silenceLevel, _timeout);
			mic.setLoopBack(_loopBack);
		}
		
		private function micSampleDataHandler(e:SampleDataEvent):void {
			micActivity = e.data.readFloat();
		}
		
		private function onMicStatus(event:StatusEvent):void { 
			if (event.code == "Microphone.Unmuted") {
				trace("Microphone access was allowed."); 
			}else if (event.code == "Microphone.Muted") {
				trace("Microphone access was denied."); 
			} 
		}
		
		private function onMicActivity(event:ActivityEvent):void { 
			info = "activating = " + event.activating + ", activityLevel = " + mic.activityLevel;
			isMicActive = event.activating;
		}
		
		public function webCamLoop():void {
			capture.bitmapData.draw(vid, mat);
		}
		
		public function getMicrophoneActivity():Number {
			return micActivity;
		}
		
		public function getMicrophoneActivityLevel():Number {
			return mic.activityLevel;
		}
		
		public function getMicrophoneActivityLevelIsActive():Number {
			if(isMicActive)	return mic.activityLevel;
			else			return 0;
		}
		
		public function getVideo():Video {
			return vid;
		}
		
		public function getCapture():Bitmap {
			return capture;
		}
		
		public function getCamera():Camera {
			return cam;
		}
		
		public function getInfo():String {
			return info;
		}
	}
}
