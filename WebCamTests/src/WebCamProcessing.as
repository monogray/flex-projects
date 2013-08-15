package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import mono_core.SpriteCore;
	
	import video.ExternalVideo;
	
	import webcam.WebCam;
	[SWF(width="800", height="800", frameRate="20", backgroundColor="#ffffff")]
	
	public class WebCamProcessing extends SpriteCore
	{
		private var cam				:WebCam = new WebCam();
		
		private var frame			:int = 0;
		private var frameMax		:int = 1;
		
		public var id				:int = 0;
		private var vidFrame		:int = 0;
		//private var vidMaxLen		:int = 150;
		
		private var currentState	:int = -1;
		
		private var container		:Sprite = new Sprite();
		
		private var convertationCaunter		:int = 0;
		private var convertationCaunterMax	:int = 100;
		
		private var url				:String = "http://sand.test.irst-ukraine.com.ua/";
		public function WebCamProcessing() {
			//if(stage) init();
			//else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init():void {
			initExternal(stage);
		}
		
		public function initExternal(_stage:Stage):void {
			var date:Date = new Date();
			var numVal:Number = date.time;
			id = Math.abs(numVal);
			
			cam.setupCameraParam(320, 240, 20, 280, 210);
			cam.setupCamera();
			cam.setupMicrophone();
			this.addChild( cam.getVideo() );
			//cam.getVideo().scaleX = 0.5;
			//cam.getVideo().scaleY = 0.5;
			
			addEventListener(Event.ENTER_FRAME, loop);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandlers);
			
			this.addChild( container );
			this.addChild( getLabel() );
		}
		
		public function keyboardHandlers( e:KeyboardEvent ):void {
			if ( e.keyCode == 32 ){								// space
			}else if ( e.ctrlKey && e.keyCode == 68 ){			// D
			}
		}
		
		public function setCurrentState( _state:int ):void {
			currentState = _state;
		}
		
		public function getCurrentState():int {
			return currentState;
		}
		
		public function loop(event:Event):void {
			/*setLabelText( "Sound: " + cam.getInfo() );
			cam.webCamLoop();
			if (currentState == 0 && vidFrame < vidMaxLen) {
				frame++;
				if(frame > frameMax) {
					frame = 0;
					cam.createSnapshot();
					cam.sendImage( url + "index.php?id=" + id + "&frame=" + (vidFrame++) );
				}
				
				container.graphics.beginFill(0x222222, 0.5);
				container.graphics.drawRect(10, 250, vidFrame*(790/vidMaxLen), 30);
				container.graphics.endFill();
			}else if(currentState == 0) {
				container.graphics.clear();
				currentState++;
				
				var request:URLRequest = new URLRequest(url + "jpg_to_flv.php?id="+id);
				var loader:URLLoader = new URLLoader();
				loader.load(request);
			}
			
			if(currentState == 1 && convertationCaunter < convertationCaunterMax){					
				convertationCaunter++;
				container.graphics.beginFill(0x222222, 0.5);
				container.graphics.drawRect(10, 250, convertationCaunter*(790/convertationCaunterMax), 30);
				container.graphics.endFill();
			}else if(currentState == 1){
				var request1:URLRequest = new URLRequest(url + "clear_seq.php?id="+id);
				var loader1:URLLoader = new URLLoader();
				loader1.load(request1);
				var request2:URLRequest = new URLRequest("http://test1.ru/media-server/clear_seq.php?id="+id);
				var loader2:URLLoader = new URLLoader();
				loader2.load(request2);
				
				openVideo();
				
				container.graphics.clear();
				cam.getVideo().visible = false;
				
				currentState++;
			}*/
			cam.webCamLoop();
			if (currentState == 0) {
				frame++;
				if(frame > frameMax){
					frame = 0;
					cam.createSnapshot();
					cam.sendImage( url + "create_seq.php?id=" + id + "&frame=" + (vidFrame++) );
				}
			}else if(currentState == 1){
				currentState = 2;
				
				var request:URLRequest = new URLRequest( url + "jpg_to_flv.php?id=" + id );
				var loader:URLLoader = new URLLoader();
				loader.load(request);
			}else if(currentState == 2){					
				convertationCaunter++;
				container.graphics.beginFill(0x2222ff, 0.5);
				container.graphics.drawRect(10, 250, convertationCaunter*(790/convertationCaunterMax), 30);
				container.graphics.endFill();
				if(convertationCaunter > convertationCaunterMax){
					convertationCaunter = 0;
					currentState = 3;
				}
			}else if(currentState == 3){
				var request1:URLRequest = new URLRequest( url + "clear_seq.php?id=" + id );
				var loader1:URLLoader = new URLLoader();
				loader1.load(request1);
				
				openVideo();
				
				container.graphics.clear();
				cam.getVideo().visible = false;
				
				currentState = 4;
			}
		}
		
		protected function openVideo():void {
			var vid:ExternalVideo = new ExternalVideo();
			vid.load_video(url + "videos/video-"+id+".flv", 320, 240);
			vid.resumePause();
			vid.is_loop();
			vid.scaleX = 3.5;
			vid.scaleY = 3.5;
			this.addChild(vid);
			vid.y = 300
			vid.x = 300;
		}
		
		public function getCam():WebCam {
			return cam;
		}
		
		public function getMicrophoneActivityLevelIsActive():Number {
			return cam.getMicrophoneActivityLevelIsActive();
		}
		
		public function getMicrophoneActivityLevel():Number {
			return cam.getMicrophoneActivityLevel();
		}
		
		public function getCapture():Bitmap {
			return cam.getCapture();
		}
	}
}