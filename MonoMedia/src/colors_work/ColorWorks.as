package colors_work
{
	//import colorsWork.*;
	import flash.display.*;
	import flash.events.*;
	
	public class ColorWorks extends Sprite
	{
		//public var webCam:WebCam;
		private	var colorPro:ColorProcessing = new ColorProcessing();
		
		private var capture				:Bitmap;
		private var captureW			:int;
		private var captureH			:int;
		private var captureL			:int;
		
		// Color Processing
		//public	var detectionCounter:int = 0;
		//public	var detectionCounterMax:int = 4;
		
		//public var colorPoints:Vector.<uint> = new <uint>[0, 0, 0, 0, 0];
		//public var colorPointPosX:Vector.<Number> = new <Number>[170, 170, 170, 150, 190];
		//public var colorPointPosY:Vector.<Number> = new <Number>[60, 110, 140, 110, 110];
		
		//public var colorCentersX:Vector.<uint> = new <uint>[0, 0, 0, 0, 0];
		//public var colorCentersY:Vector.<uint> = new <uint>[0, 0, 0, 0, 0];
		
		private var colorVector:Vector.<uint>;
		private var grayVector:Vector.<uint>;
		private var grayVectorTmp:Vector.<uint>;
		private var colorVectorTmp:Vector.<uint>;
		private var colorMotionVector:Vector.<uint>;
		//private var findColorVector:Vector.<Number>;
		private var luminosityVector:Vector.<uint>;
		
		private	var motionCount:int = 0;
		private	var motionX:Number = 0;
		private	var motionY:Number = 0;
		private	var luminosityCount:int = 0;
		
		private	var prevFrameGetCounter:int = 0;
		private	var prevFrameGetCounterMax:int = 3;
		
		private	var motionColorTreshold:Number = 15;
		//public	var targetColorTreshold:Number = 5;
		
		//public	var colorCenterX:Number = 0;
		//public	var colorCenterY:Number = 0;
		
		// Debug
		private  var debugCapture:Bitmap;
		//public  var debugSprite:Sprite = new Sprite;
		//public  var target:Sprite = new Sprite;
		//public	var isDebug:Boolean = false;
		
		public function ColorWorks()
		{
		}
		
		public function setCapture(_capture:Bitmap):void {
			capture = _capture;
		}
		
		public function keyboardHandlers( e:KeyboardEvent ):void {
			//if ( e.keyCode == 32 ){			// space
				/*for ( var i:uint = 0; i < colorPoints.length; i++ ) {
					debugSprite.graphics.lineStyle(2, 0xff0000);
					colorPoints[i] = webCam.capture.bitmapData.getPixel(colorPointPosX[i], colorPointPosY[i]);
					debugSprite.graphics.drawCircle(colorPointPosX[i], colorPointPosY[i], 2);
					
					debugSprite.graphics.lineStyle();
					debugSprite.graphics.beginFill(colorPoints[i], 1);
					debugSprite.graphics.drawRect((30+3)*i, 280, 30, 30);
				}*/
			//}
		}
		
		//public function init():void {
			/*webCam = new WebCam();
			webCam.addEventListener(WebCamEvent.WEB_CAM_ADDED, initApp);
			webCam.addEventListener(WebCamEvent.WEB_CAM_ADDED_ERROR, initAppWithoutWebCam);
			webCam.setupCamera();*/
		//}
		
		public function initApp():void {
			captureW = capture.width;
			captureH = capture.height;
			captureL = capture.width * capture.height;
			
			colorVector = new Vector.<uint>(captureL);
			colorVectorTmp = new Vector.<uint>(captureL);
			colorMotionVector = new Vector.<uint>(captureL);
			grayVector = new Vector.<uint>(captureL);
			luminosityVector = new Vector.<uint>(captureL);
			grayVectorTmp = new Vector.<uint>(captureL);
			//findColorVector = new Vector.<Number>(captureL);
			
			debugCapture = new Bitmap(new BitmapData(captureW, captureH) );
			
			this.dispatchEvent( new Event("ColorWorkInited") );
		}
		
		public function initAppWithoutWebCam(event:Event):void {
			this.dispatchEvent( new Event("ColorWorkInited WithoutWebCam") );
		}
		
		/*public function loop():void {
			if(detectionCounter > detectionCounterMax){
				webCam.webCamLoop();
				createColorVector();
				
				//detectionProcesing();
				
				//motionDetection();
				//findColorsCenters();
				
				if(isDebug)
					drawColorVector();
				
				detectionCounter = 0;
			}
			
			detectionCounter++;
		}*/
		
		public function createColorVector():void {
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					colorVector[k] = capture.bitmapData.getPixel(i, j);
					k++;
				}
			}
		}
		
		public function createColorVectorTmp():void {
			prevFrameGetCounter++;
			if(prevFrameGetCounter > prevFrameGetCounterMax){
				prevFrameGetCounter = 0;
				for ( var i:uint = 0; i < colorVector.length; i++ ) {
					colorVectorTmp[i] = colorVector[i];
				}
			}
		}
		
		public function createAdaptiveColorVectorTmp(_step:int):void {
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				colorVectorTmp[i] = adaptiveColorSum(colorVectorTmp[i], colorVector[i], _step);
			}
		}
		
		public function adaptiveColorSum(colorFirst:uint, colorSecond:uint, _step:int):uint {
			var currR:uint = (colorFirst >> 16) & 0xFF;
			var currG:uint = (colorFirst >> 8) & 0xFF;
			var currB:uint = colorFirst & 0xFF;
			
			var colorTemp_R:uint = (colorSecond >> 16) & 0xFF;
			var colorTemp_G:uint = (colorSecond >> 8) & 0xFF;
			var colorTemp_B:uint = colorSecond & 0xFF;
			
			var _stepIncr = _step + 1;
			
			var colorTemp_RAdaptive:uint = (currR * _step + colorTemp_R) / _stepIncr;
			var colorTemp_GAdaptive:uint = (currG * _step + colorTemp_G) / _stepIncr;
			var colorTemp_BAdaptive:uint = (currB * _step + colorTemp_B) / _stepIncr;
			
			return colorTemp_RAdaptive << 16 | colorTemp_GAdaptive << 8 | colorTemp_BAdaptive;
		}
		
		public function createColorVectorTmpImmediately():void {
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				colorVectorTmp[i] = colorVector[i];
			}
		}
		
		public function motionDetection():void {
			motionCount = 0;
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				if( !colorPro.isColourWithinRange(colorVector[i], colorVectorTmp[i], motionColorTreshold) ){
					colorMotionVector[i] = 1;
					motionCount++;
				}else{
					colorMotionVector[i] = 0;
				}
			}
		}
		
		public function motionDetectionWitnAdditionColor(_additionColor:uint):void {
			motionCount = 0;
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				if( !colorPro.isColourWithinRange(colorVector[i], colorVectorTmp[i], motionColorTreshold) &&
					colorPro.isColourWithinRange(colorVector[i], _additionColor, 150) ){
					colorMotionVector[i] = 1;
					motionCount++;
				}else{
					colorMotionVector[i] = 0;
				}
			}
		}
		
		public function motionDetectionWitnAdditionColorAndPosition(_additionColor:uint, _treshold:int, _x:int, _y:int):void {
			motionCount = 0;
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					if( !colorPro.isColourWithinRange(colorVector[k], colorVectorTmp[k], motionColorTreshold) &&
						colorPro.isColourWithinRange(colorVector[k], _additionColor, _treshold) &&
						Math.sqrt((i - _x)*(i - _x) + (j - _y)*(j - _y)) < 70 + (j/4) ){//j/3.5
						colorMotionVector[k] = 1;
						motionCount++;
					}else{
						colorMotionVector[k] = 0;
					}
					k++
				}
			}
		}
		
		public function motionDetectionWitnPosition(_x:int, _y:int):void {
			motionCount = 0;
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					if( !colorPro.isColourWithinRange(colorVector[k], colorVectorTmp[k], motionColorTreshold) &&
						Math.sqrt((i - _x)*(i - _x) + (j - _y)*(j - _y)) < 50 + (j/3.5) ){
						colorMotionVector[k] = 1;
						motionCount++;
					}else{
						colorMotionVector[k] = 0;
					}
					k++
				}
			}
		}
		
		public function motionPosition():void {
			var k:int = 0, _x:int = 0, _y:int = 0, _count:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					if( colorMotionVector[k] == 1 ){
						_x += i; _y += j;
						_count++;
					}
					k++;
				}
			}
			if(_count > 0){
				motionX = _x / _count;
				motionY = _y / _count;
			}
		}
		
		public function deleteNoiseInVector(_vector:Vector.<uint>, _steps:int):void {
			/*for ( var j:uint = 0; j < _steps; j++ ) {
				for ( var i:uint = 0; i < _vector.length-1; i++ ) {
					if(_vector[i] == 1 && _vector[i+1] != 1)
						_vector[i] = 0;
				}
			}*/
			colorPro.delBinarVectorNoise(_vector, _steps, captureW, 1);
		}
		
		public function rgbColorVectorToGrayscale():void {
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				grayVector[i] = colorPro.rgb2gray( colorPro.rgb2Pr(colorVector[i]) );
			}
		}
		
		public function createGrayVectorTmp():void {
			for ( var i:uint = 0; i < colorVector.length; i++ ) {
				grayVectorTmp[i] = (grayVectorTmp[i]*2 + grayVector[i]) / 3;
			}
		}
		
		public function luminosityDetection():void {
			luminosityCount = 0;
			for ( var i:uint = 0; i < grayVector.length; i++ ) {
				if( colorPro.isGrayColourWithinRange(grayVectorTmp[i], 255, 30) ){
					luminosityVector[i] = 1;
					luminosityCount++;
				}else{
					luminosityVector[i] = 0;
				}
			}
		}
		
		/*public function motionDetection():void {
			var i:uint = 0;
			var j:uint = 0;
			for ( i = 0; i < colorVector.length-webCam.videoWidth1; i++ ) {
				if( !colorPro.isColourWithinRange(colorVector[i], colorVectorTmp[i], motionColorTreshold) ){
					colorMotionVector[i] = 1;
				}else{
					colorMotionVector[i] = 0;
				}
				colorVectorTmp[i] = colorVector[i];
			}
			
			// Del Noise
			for ( j = 0; j < 20; j++ ) {
				for ( i = 0; i < colorMotionVector.length-webCam.videoWidth1; i++ ) {
					if(colorMotionVector[i] == 1 && colorMotionVector[i+1] != 1){
						colorMotionVector[i] = 0;
					}else if(colorMotionVector[i] == 1 && colorMotionVector[i+webCam.videoWidth1] != 1){
						colorMotionVector[i] = 0;
					}
				}
			}
			
			
		}
		
		public function findColorsCenters():void {
			var i:uint = 0;
			var j:uint = 0;
			var k:uint = 0;
			var p:uint = 0;
			
			colorCenterX = 0;
			colorCenterY = 0;
			
			for ( j = 0; j < colorCentersX.length;j++ ) {
				
				for ( i = 0; i < colorVector.length-webCam.videoWidth1; i++ ) {
					findColorVector[i] = 0;
					if(colorMotionVector[i] == 1){
						for ( p = 0; p < colorPoints.length; p++ ) {
							if( colorPro.isColourAdaptiveWithinRange(colorPoints[p], colorVector[i], targetColorTreshold) ){
								findColorVector[i] = 1;
								p = 1000; // Выход из цикла
							}
						}
					}
				}
				
				// Find Center
				var _xPos:Number = 0;
				var _yPos:Number = 0;
				var _count:Number = 0;
				k = 0;
				for ( p = 0; p < webCam.videoHeight1; p++ ) {
					for ( i = 0; i < webCam.videoWidth1; i++ ) {
						if(findColorVector[k] == 1){
							_xPos+=i;
							_yPos+=p;
							_count++;
						}
						k++;
					}
				}
				
				if(_count > 0){
					colorCenterX += _xPos/_count;
					colorCenterY += _yPos/_count;
				}
				
				
				
			}
			
			colorCenterX = colorCenterX/colorCentersX.length;
			colorCenterY = colorCenterY/colorCentersX.length;
			
			target.x = (target.x + colorCenterX)/2;
			target.y = (target.y + colorCenterY)/2;
		}*/
		
		/*public function detectionProcesing():void {
			var i:uint = 0;
			var j:uint = 0;
			var k:int = 0;
			
			for ( i = 0; i < colorVector.length-captureW; i++ ) {
				//if( !colorPro.isColourAdaptiveWithinRange(colorVector[i], colorVectorTmp[i], 20) ){
				if( !colorPro.isColourWithinRange(colorVector[i], colorVectorTmp[i], 20) ){
					colorMotionVector[i] = 1;
				}else{
					colorMotionVector[i] = 0;
				}
			}
			
			// Del Noise
			for ( j = 0; j < 5; j++ ) {
				for ( i = 0; i < colorMotionVector.length-captureW; i++ ) {
					if(colorMotionVector[i] == 1 && colorMotionVector[i+1] != 1){
						colorMotionVector[i] = 0;
					}else if(colorMotionVector[i] == 1 && colorMotionVector[i+captureW] != 1){
						colorMotionVector[i] = 0;
					}
				}
			}
			
			for ( i = 0; i < colorVector.length-captureW; i++ ) {
				findColorVector[i] = 0;
				if(colorMotionVector[i] == 1){
					
					var _identityCounts:int = 0;
					for ( j = 0; j < colorPoints.length; j++ ) {
						if( colorPro.isYBRColourWithinRange(colorPoints[j], colorVector[i], 35) ){
						//if( colorPro.isColourWithinRange(colorPoints[j], colorVector[i], 25) ){
							//findColorVector[i] = 1;
							_identityCounts++;
							//j = 1000; // Выход из цикла
						}else{
							//findColorVector[i] = 0.5;
						}
					}
					
					if(_identityCounts >= 2)
						findColorVector[i] = 1;
					else
						findColorVector[i] = 0.6;
					
				}
				
				colorVectorTmp[i] = colorVector[i];
			}
			
			// Del Noise
			for ( j = 0; j < 5; j++ ) {
				for ( i = 0; i < colorVector.length-captureW; i++ ) {
					if(findColorVector[i] == 1 && findColorVector[i+1] != 1){
						findColorVector[i] = 0.3;
					}else if(findColorVector[i] == 1 && findColorVector[i+captureW] != 1){
						findColorVector[i] = 0.3;
					}
				}
				//for ( i = webCam.videoWidth1; i < colorVector.length-webCam.videoWidth1; i++ ) {
					//findColorVector[i] = (findColorVector[i]+findColorVector[i+1]+findColorVector[i-1]+findColorVector[i+webCam.videoWidth1]+findColorVector[i-webCam.videoWidth1])/5;
				//}
			}
			
			// Find Center
			var _xPos:Number = 0;
			var _yPos:Number = 0;
			var _count:Number = 0;
			
			for ( j = 0; j < captureH; j++ ) {
				for ( i = 0; i < captureW; i++ ) {
					if(findColorVector[k] == 1){
						_xPos+=i;
						_yPos+=j;
						_count++;
					}
					k++;
				}
			}
			
			if(_count > 0){
				colorCenterX = _xPos/_count;
				colorCenterY = _yPos/_count;
			}
			
			target.x = colorCenterX;
			target.y = colorCenterY;
		}*/
		
		public function drawColorVector_old():void {
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					/*if(findColorVector[k] == 0){
						debugCapture.bitmapData.setPixel(i, j, 0);
					}else{
						debugCapture.bitmapData.setPixel(i, j, 0xffffff);
					}*/
					
					/*if(luminosityVector[k] == 0){
						debugCapture.bitmapData.setPixel(i, j, 0);
					}else{
						debugCapture.bitmapData.setPixel(i, j, 0xffffff);
					}*/
					
					//debugCapture.bitmapData.setPixel(i, j, colorPro.gray2rgb(findColorVector[k]*255) );
					//debugCapture.bitmapData.setPixel(i, j, colorPro.gray2rgb(colorMotionVector[k]*255) );
					
					//debugCapture.bitmapData.setPixel(i, j, colorVector[k] );
					//webCam.capture.bitmapData.setPixel(i, j, colorVector[k]);
					k++;
				}
			}
		}
		
		public function drawBinaryColorVector(_vector:Vector.<uint>):void {
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					if(_vector[k] == 0){
						debugCapture.bitmapData.setPixel(i, j, 0);
					}else{
						debugCapture.bitmapData.setPixel(i, j, 0xffffff);
					}
					k++;
				}
			}
		}
		
		public function drawColorVector(_vector:Vector.<uint>):void {
			var k:int = 0;
			for ( var j:uint = 0; j < captureH; j++ ) {
				for ( var i:uint = 0; i < captureW; i++ ) {
					debugCapture.bitmapData.setPixel(i, j, _vector[k]);
					k++;
				}
			}
		}
		
		public function getDebugCapture():Bitmap {
			return debugCapture;
		}
		
		public function getMotionCount():int {
			return motionCount;
		}
		
		public function getMotionX():int {
			return motionX;
		}
		
		public function getMotionY():int {
			return motionY;
		}
		
		public function getLuminosityCount():int {
			return luminosityCount;
		}
		
		public function getColorMotionVector():Vector.<uint> {
			return colorMotionVector;
		}
		
		public function getLuminosityVector():Vector.<uint> {
			return luminosityVector;
		}
		
		public function getGrayVector():Vector.<uint> {
			return grayVector;
		}
		
		public function getColorVectorTmp():Vector.<uint> {
			return colorVectorTmp;
		}
		
		public function getColorVector():Vector.<uint> {
			return colorVector;
		}
	}
}