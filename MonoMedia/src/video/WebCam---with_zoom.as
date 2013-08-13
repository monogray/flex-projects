package media.video
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.utils.*;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	public class WebCam extends Sprite
	{
		//WebCam 
		public  var vid1:Video = null;
		public	var cam1:Camera; 
		private var videoOutputWidth1:int = 800;	// Output video resolution;		176x144 320x240
		private var videoOutputHeight1:int = 600;	// Output video resolution;
		private var videoFPS1:int = 20;				// Output video fps;
		public	var videoWidth1:int = 640;			// 176x132  320x240  370x278  420x315  500x375  560x420
		public	var videoHeight1:int = 480;
		public	var widthScale1:Number = videoWidth1/videoOutputWidth1;
		public	var heighScale1:Number = videoHeight1/videoOutputHeight1;
		
		public	var mat1:Matrix = new Matrix(widthScale1, 0, 0, heighScale1, 0, 0);
		//public	var mat1:Matrix = new Matrix(1, 0, 0, 1, -(videoOutputWidth1/2-videoWidth1/2), -(videoOutputHeight1/2-videoHeight1/2));
		
		public  var capture:Bitmap = new Bitmap( new BitmapData(videoWidth1, videoHeight1, false, 0) );
		
		// Zoom
		private var videoZoom:Number = 1.4;
		private var isZoom:Boolean = false;
		public  var captureZoom:Bitmap = new Bitmap( new BitmapData(videoOutputWidth1, videoOutputHeight1, false, 0) );
		public	var zoomMat:Matrix;
		
		// Debug
		public  var _debugInfo:String = "";
		
		public function WebCam(){
		}
		
		public function setupCameraParam( _videoOutputWidth:int, _videoOutputHeight:int, _videoFPS:int,
										 _videoWidth:int, _videoHeight:int, _mat:Matrix=null ):void {
			videoOutputWidth1 = _videoOutputWidth;		// Output video resolution;		176x144 320x240
			videoOutputHeight1 = _videoOutputHeight;	// Output video resolution;
			videoFPS1 = _videoFPS;						// Output video fps;
			videoWidth1 = _videoWidth;					// 176x132  320x240  370x278 420x315   500x375   560x420
			videoHeight1 = _videoHeight;
			widthScale1 = _videoWidth/_videoOutputWidth;
			heighScale1 = _videoHeight/_videoOutputHeight;
			if(_mat == null)
				mat1 = new Matrix(widthScale1, 0, 0, heighScale1, 0, 0);
			else 
				mat1 = _mat;
		}
		
		public function setupZoomMode( _isZoom:Boolean, _videoZoom:Number=1 ):void {
			isZoom = _isZoom;
			videoZoom = _videoZoom;
			if(_isZoom)
				zoomMat = new Matrix(videoZoom, 0, 0, videoZoom, -(videoOutputWidth1*videoZoom/2-videoOutputWidth1/2), -(videoOutputHeight1*videoZoom/2-videoOutputHeight1/2));
		}
		
		public function setupCamera(_camId:String="0"):void {
			if(Camera.names.length > 0){
				Security.showSettings(SecurityPanel.CAMERA);
				vid1 = new Video(videoOutputWidth1, videoOutputHeight1);
				cam1 = Camera.getCamera(_camId);
				cam1.setMode(videoOutputWidth1, videoOutputHeight1, videoFPS1);
				vid1.attachCamera(cam1);
				
				capture = new Bitmap( new BitmapData(videoWidth1, videoHeight1, false, 0) );
				captureZoom = new Bitmap( new BitmapData(videoOutputWidth1, videoOutputHeight1, false, 0) );
				
				this.dispatchEvent( new Event("webCamAdded") );
			}else{
				this.dispatchEvent( new Event("webCamAddedError") );
			}
		}
		
		public function setEnterFrameProcessing(_val:Boolean):void {
			if(_val)
				addEventListener(Event.ENTER_FRAME, webCamEventLoop);
			else 
				removeEventListener(Event.ENTER_FRAME, webCamEventLoop);
		}
		
		public function webCamEventLoop(event:Event):void {
			webCamLoop();
		}
		
		/**
		 * Main loop processing
		 */
		public function webCamLoop():void {
			if(!isZoom){
				capture.bitmapData.lock();
				capture.bitmapData.draw(vid1, mat1);
				capture.bitmapData.unlock();
			}else{
				captureZoom.bitmapData.lock();
				captureZoom.bitmapData.draw(vid1, zoomMat);
				captureZoom.bitmapData.unlock();
				
				capture.bitmapData.lock();
				capture.bitmapData.draw(captureZoom, mat1);
				capture.bitmapData.unlock();
			}
		}
		
		/**
		 * Return the video reference.
		 */
		final public function get videoData() : Video {
			return vid1;
		}
		
		/**
		 * Return the capture bitmap reference.
		 */
		final public function get captureData() : Bitmap {
			return capture;
		}
		
		/**
		 * Return the capture bitmap reference.
		 */
		final public function get captureBitmapData() : BitmapData {
			return capture.bitmapData;
		}
	}
}
