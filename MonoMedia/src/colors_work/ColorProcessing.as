/*
��������: ColorProcessing;
�����: Monogray;
Version: 1.0

Functions: none Yet
*/

package colors_work
{
	
	public class ColorProcessing
	{
		
		public function ColorProcessing(){
			
		}
		
		
		/* ------- Color Detect Chapter ------- */
		
		public function isColourWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:Number):Boolean {
			var currR:uint = (colorFirst >> 16) & 0xFF;
			var colorTemp_R:uint = (colorSecond >> 16) & 0xFF;
			if ( (currR > (colorTemp_R + colorThreshold)) || (currR < (colorTemp_R - colorThreshold)) )
				return false;
			
			var currG:uint = (colorFirst >> 8) & 0xFF;
			var colorTemp_G:uint = (colorSecond >> 8) & 0xFF;
			if ( (currG > (colorTemp_G + colorThreshold)) || (currG < (colorTemp_G - colorThreshold)) )
				return false;
			
			var currB:uint = colorFirst & 0xFF;
			var colorTemp_B:uint = colorSecond & 0xFF;
			if ( (currB > (colorTemp_B + colorThreshold)) || (currB < (colorTemp_B - colorThreshold)) )
				return false;
			
			return true;
		}
		
		public function isColourAdaptiveWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:int):Boolean {
			var currR:uint = (colorFirst >> 16) & 0xFF;
			var currG:uint = (colorFirst >> 8) & 0xFF;
			var currB:uint = colorFirst & 0xFF;
			
			var currRAdaptive:uint = currR/(currR+currG+currB)*255;
			var currGAdaptive:uint = currG/(currR+currG+currB)*255;
			var currBAdaptive:uint = currB/(currR+currG+currB)*255;
			
			var colorTemp_R:uint = (colorSecond >> 16) & 0xFF;
			var colorTemp_G:uint = (colorSecond >> 8) & 0xFF;
			var colorTemp_B:uint = colorSecond & 0xFF;
			
			var colorTemp_RAdaptive:uint = colorTemp_R/(colorTemp_R+colorTemp_G+colorTemp_B)*255;
			var colorTemp_GAdaptive:uint = colorTemp_G/(colorTemp_R+colorTemp_G+colorTemp_B)*255;
			var colorTemp_BAdaptive:uint = colorTemp_B/(colorTemp_R+colorTemp_G+colorTemp_B)*255;
			
			if ( (currRAdaptive > (colorTemp_RAdaptive + colorThreshold)) || (currRAdaptive < (colorTemp_RAdaptive - colorThreshold)) )
				return false;
			if ( (currGAdaptive > (colorTemp_GAdaptive + colorThreshold)) || (currGAdaptive < (colorTemp_GAdaptive - colorThreshold)) )
				return false;
			if ( (currBAdaptive > (colorTemp_BAdaptive + colorThreshold)) || (currBAdaptive < (colorTemp_BAdaptive - colorThreshold)) )
				return false;
			return true;
		}
		
		public function isGrayColourWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:int):Boolean {
			if ( Math.abs(colorFirst-colorSecond) > colorThreshold )
				return false;
			return true;
		}
		
		public function isHSVWithinRange(resultHSV:Vector.<int>, 
										 minHueValue:int = 0, maxHueValue:int = 360,
										 minSValue:int = 0, maxSValue:int = 100,
										 minVValue:int = 0, maxVValue:int = 100):Boolean {
			if ( (resultHSV[0] > minHueValue) && (resultHSV[0] < maxHueValue) &&
				(resultHSV[1] > minSValue) && (resultHSV[1] < maxSValue)&&
				(resultHSV[2] > minVValue) && (resultHSV[2] < maxVValue))
				return true;
			
			return false;
		}
		
		public function isHSVColorsWithinRange(resultHSV1:Vector.<int>, resultHSV2:Vector.<int>,
											   hueRange :int = 0, sRange :int = 0, vRange :int = 0 ):Boolean {
			//if ( (Math.abs(resultHSV1[0]-resultHSV2[0]) < hueRange || Math.abs((resultHSV1[0]+hueRange-360)-resultHSV2[0]) < hueRange || Math.abs(resultHSV1[0]-(resultHSV2[0]+hueRange-360)) < hueRange )&&
			//(Math.abs(resultHSV1[1]-resultHSV2[1]) < sRange || Math.abs((resultHSV1[1]+sRange-100)-resultHSV2[1]) < sRange || Math.abs(resultHSV1[1]-(resultHSV2[1]+sRange-100)) < sRange ) && 
			//(Math.abs(resultHSV1[2]-resultHSV2[2]) < vRange || Math.abs((resultHSV1[2]+vRange-100)-resultHSV2[2]) < vRange || Math.abs(resultHSV1[2]-(resultHSV2[2]+vRange-100)) < vRange)){
			if ( Math.abs(resultHSV1[0]-resultHSV2[0]) < hueRange &&
				Math.abs(resultHSV1[1]-resultHSV2[1]) < sRange  && 
				Math.abs(resultHSV1[2]-resultHSV2[2]) < vRange ){
				return true;
			}
			return false;
		}
		
		public function isHueWithinRange(resultHSV1:Vector.<int>, resultHSV2:Vector.<int>,
										 hueRange :int = 0, sRange :int = 0, vRange :int = 0 ):Boolean {
			if ( Math.abs(resultHSV1[0]-resultHSV2[0]) < hueRange || Math.abs((resultHSV1[0]+hueRange-360)-resultHSV2[0]) < hueRange || Math.abs(resultHSV1[0]-(resultHSV2[0]+hueRange-360)) < hueRange ){
				return true;
			}else{
				return false;
			}
		}
		public function isSaturationWithinRange(resultHSV1:Vector.<int>, resultHSV2:Vector.<int>,
												hueRange :int = 0, sRange :int = 0, vRange :int = 0 ):Boolean {
			if ( Math.abs(resultHSV1[1]-resultHSV2[1]) < sRange || Math.abs((resultHSV1[1]+sRange-100)-resultHSV2[1]) < sRange || Math.abs(resultHSV1[1]-(resultHSV2[1]+sRange-100)) < sRange ){
				return true;
			}else{
				return false;
			}
		}
		
		public function isHSWithinRange(resultHSV1:Vector.<int>, resultHSV2:Vector.<int>,
										hueRange :int = 0, sRange :int = 0, vRange :int = 0 ):Boolean {
			if ( (Math.abs(resultHSV1[0]-resultHSV2[0]) < hueRange || Math.abs((resultHSV1[0]+hueRange-360)-resultHSV2[0]) < hueRange || Math.abs(resultHSV1[0]-(resultHSV2[0]+hueRange-360)) < hueRange )&&
				(Math.abs(resultHSV1[1]-resultHSV2[1]) < sRange || Math.abs((resultHSV1[1]+sRange-100)-resultHSV2[1]) < sRange || Math.abs(resultHSV1[1]-(resultHSV2[1]+sRange-100)) < sRange ) ){
				return true;
			}
			
			return false;
		}
		
		public function isYBRColourWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:int):Boolean {
			var currR:uint = (colorFirst >> 16) & 0xFF;
			var currG:uint = (colorFirst >> 8) & 0xFF;
			var currB:uint = colorFirst & 0xFF;
			
			var currY:uint = 0.299*currR + 0.587*currG + 0.114*currB;
			var currPB:uint = -0.168736*currR - 0.331264*currG + 0.5*currB;
			var currPP:uint = 0.5*currR - 0.418688*currG - 0.081312*currB;
			
			var colorTemp_R:uint = (colorSecond >> 16) & 0xFF;
			var colorTemp_G:uint = (colorSecond >> 8) & 0xFF;
			var colorTemp_B:uint = colorSecond & 0xFF;
			
			var colorTemp_Y:uint = 0.299*colorTemp_R + 0.587*colorTemp_G + 0.114*colorTemp_B;
			var colorTemp_PB:uint = -0.168736*colorTemp_R - 0.331264*colorTemp_G + 0.5*colorTemp_B;
			var colorTemp_PP:uint = 0.5*colorTemp_R - 0.418688*colorTemp_G - 0.081312*colorTemp_B;
			
			if ( Math.abs(currY - colorTemp_Y) > colorThreshold )
				return false;
			if ( Math.abs(currPB - colorTemp_PB) > colorThreshold )
				return false;
			if ( Math.abs(currPP - colorTemp_PP) > colorThreshold )
				return false;
			
			return true;
		}
		
		public function isDeltaEWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:Number):Boolean {
			var CIE_Lab1:Vector.<Number> = hex2CIE_Lab(colorFirst);
			var CIE_Lab2:Vector.<Number> = hex2CIE_Lab(colorSecond);
			
			/*if ( Math.abs(CIE_Lab1[0] - CIE_Lab2[0]) > colorThreshold )
			return false;
			if ( Math.abs(CIE_Lab1[1] - CIE_Lab2[1]) > colorThreshold )
			return false;
			if ( Math.abs(CIE_Lab1[2] - CIE_Lab2[2]) > colorThreshold )
			return false;
			
			return true;
			*/
			
			/*var DeltaE:Number = Math.sqrt( 
			( ( CIE_Lab1[0] - CIE_Lab2[0] ) * ( CIE_Lab1[0] - CIE_Lab2[0] ) )
			+ ( ( CIE_Lab1[1] - CIE_Lab2[1] ) * ( CIE_Lab1[1] - CIE_Lab2[1] ) )
			+ ( ( CIE_Lab1[2] - CIE_Lab2[2] ) * ( CIE_Lab1[2] - CIE_Lab2[2] ) ) 
			);*/
			
			//if(DeltaE < colorThreshold) return true;
			//else return false;
			
			
			var xDE:Number =   Math.sqrt( ( CIE_Lab2[1]*CIE_Lab2[1] ) + ( CIE_Lab2[2]*CIE_Lab2[2] ) )
				- Math.sqrt( ( CIE_Lab1[1]*CIE_Lab1[1] )  + ( CIE_Lab1[2]*CIE_Lab1[2] ) );
			
			var DeltaH:Number = Math.sqrt( ( CIE_Lab2[1] - CIE_Lab1[1] ) * ( CIE_Lab2[1] - CIE_Lab1[1] )
				+ ( CIE_Lab2[2] - CIE_Lab1[2] ) * ( CIE_Lab2[2] - CIE_Lab1[2] )
				- ( xDE * xDE ) );
			
			if(DeltaH < colorThreshold ) return true;
				//if(DeltaH < colorThreshold && DeltaE < colorThreshold*3) return true;
				//if( (DeltaH + DeltaE)/2 < colorThreshold ) return true;
			else return false;
		}
		
		public function isDeltaCMCWithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:int):Boolean {
			var CIE_Lab1:Vector.<Number> = hex2CIE_Lab(colorFirst);
			var CIE_Lab2:Vector.<Number> = hex2CIE_Lab(colorSecond);
			
			//CIE-L*1, CIE-a*1, CIE-b*1          //Color #1 CIE-L*ab values
			//CIE-L*2, CIE-a*2, CIE-b*2          //Color #2 CIE-L*ab values
			//WHT-L, WHT-C                       //Wheight factor
			var WHT_L:Number = 1;
			var WHT_C:Number = 1; 
			
			var xC1:Number = Math.sqrt( ( CIE_Lab1[1]*CIE_Lab1[1] ) + ( CIE_Lab1[2]*CIE_Lab1[2] ) );
			var xC2:Number = Math.sqrt( ( CIE_Lab2[1]*CIE_Lab2[1] ) + ( CIE_Lab2[2]*CIE_Lab2[2] ) )
			var xff:Number = Math.sqrt( ( xC1*xC1*xC1*xC1 ) / ( ( xC1*xC1*xC1*xC1 ) + 1900 ) );
			var xH1:Number = CieLab2Hue( CIE_Lab1[1], CIE_Lab1[2] );
			
			var xTT:Number;
			if ( xH1 < 164 || xH1 > 345 ) xTT = 0.36 + Math.abs( 0.4 * Math.cos( dtor( 35 + xH1 ) ) );
			else                          xTT = 0.56 + Math.abs( 0.2 * Math.cos( dtor( 168 + xH1) ) );
			
			var xSL:Number;
			if ( CIE_Lab1[0] < 16 ) xSL = 0.511;
			else                xSL = ( 0.040975 * CIE_Lab1[0] ) / ( 1 + ( 0.01765 * CIE_Lab1[0] ) );
			
			var xSC:Number = ( ( 0.0638 * xC1 ) / ( 1 + ( 0.0131 * xC1 ) ) ) + 0.638;
			var xSH:Number = ( ( xff * xTT ) + 1 - xff ) * xSC;
			var xDH:Number = Math.sqrt( ( CIE_Lab2[1] - CIE_Lab1[1] ) * ( CIE_Lab2[1] - CIE_Lab1[1] ) + ( CIE_Lab2[2] - CIE_Lab1[2] ) * ( CIE_Lab2[2] - CIE_Lab1[2] ) - ( xC2 - xC1 ) * ( xC2 - xC1 ) );
			xSL = ( CIE_Lab2[0] - CIE_Lab1[0] ) / WHT_L * xSL;
			xSC = ( xC2 - xC1 ) / WHT_C * xSC;
			xSH = xDH / xSH;
			
			var DeltaCMC:Number = Math.sqrt( xSL ^ 2 + xSC ^ 2 + xSH ^ 2 );
			
			if( DeltaCMC < colorThreshold ) return true;
			else return false;
		}
		
		
		public function isDeltaE2000WithinRange(colorFirst:uint, colorSecond:uint, colorThreshold:int):Boolean {
			var CIE_Lab1:Vector.<Number> = hex2CIE_Lab(colorFirst);
			var CIE_Lab2:Vector.<Number> = hex2CIE_Lab(colorSecond);
			
			//CIE-L*1, CIE-a*1, CIE-b*1          //Color #1 CIE-L*ab values
			//CIE-L*2, CIE-a*2, CIE-b*2          //Color #2 CIE-L*ab values
			//WHT-L, WHT-C, WHT-H                //Wheight factor
			
			var WHT_L:Number = 1;
			var WHT_C:Number = 1; 
			var WHT_H:Number = 1; 
			
			var xC1:Number  = Math.sqrt( CIE_Lab1[1] * CIE_Lab1[1] + CIE_Lab1[2] * CIE_Lab1[2] );
			var xC2:Number = Math.sqrt( CIE_Lab2[1] * CIE_Lab2[1] + CIE_Lab2[2] * CIE_Lab2[2] );
			var xCX:Number = ( xC1 + xC2 ) / 2;
			var xGX:Number = 0.5 * ( 1 - Math.sqrt( ( Math.pow(xCX,7) / ( ( Math.pow(xCX,7) ) + ( Math.pow(25,7) ) ) ) ) );
			var xNN:Number = ( 1 + xGX ) * CIE_Lab1[1];
			xC1 = Math.sqrt( xNN * xNN + CIE_Lab1[2] * CIE_Lab1[2] );
			var xH1:Number = CieLab2Hue( xNN, CIE_Lab1[2] );
			xNN = ( 1 + xGX ) * CIE_Lab2[1];
			xC2 = Math.sqrt( xNN * xNN + CIE_Lab2[2] * CIE_Lab2[2] );
			var xH2:Number = CieLab2Hue( xNN, CIE_Lab2[2] );
			var xDL:Number = CIE_Lab2[0] - CIE_Lab1[0];
			var xDC:Number = xC2 - xC1;
			
			var xDH:Number;
			if ( ( xC1 * xC2 ) == 0 ) {
				xDH = 0;
			}
			else {
				xNN = Math.round( xH2 - xH1 );//, 12 );
				if ( Math.abs( xNN ) <= 180 ) {
					xDH = xH2 - xH1;
				}
				else {
					if ( xNN > 180 ) xDH = xH2 - xH1 - 360;
					else             xDH = xH2 - xH1 + 360;
				}
			}
			xDH = 2 * Math.sqrt( xC1 * xC2 ) * Math.sin( dtor( xDH / 2 ) );
			var xLX:Number = ( CIE_Lab1[0] + CIE_Lab2[0] ) / 2;
			var xCY:Number = ( xC1 + xC2 ) / 2;
			
			var xHX:Number;
			if ( ( xC1 *  xC2 ) == 0 ) {
				xHX = xH1 + xH2;
			}
			else {
				xNN = Math.abs( Math.round( xH1 - xH2 ) );//, 12 ) )
				if ( xNN >  180 ) {
					if ( ( xH2 + xH1 ) <  360 ) xHX = xH1 + xH2 + 360;
					else                        xHX = xH1 + xH2 - 360;
				}
				else {
					xHX = xH1 + xH2;
				}
				xHX /= 2;
			}
			
			var xTX:Number = 1 - 0.17 * Math.cos( dtor( xHX - 30 ) ) + 0.24
				* Math.cos( dtor( 2 * xHX ) ) + 0.32
				* Math.cos( dtor( 3 * xHX + 6 ) ) - 0.20
				* Math.cos( dtor( 4 * xHX - 63 ) );
			var xPH:Number = 30 * Math.exp( - ( ( xHX  - 275 ) / 25 ) * ( ( xHX  - 275 ) / 25 ) );
			var xRC:Number = 2 * Math.sqrt( (  Math.pow(xCY,7) ) / ( ( Math.pow(xCY,7) ) + ( Math.pow(25,7) ) ) );
			var xSL:Number = 1 + ( ( 0.015 * ( ( xLX - 50 ) * ( xLX - 50 ) ) )
				/  Math.sqrt( 20 + ( ( xLX - 50 ) * ( xLX - 50 ) ) ) );
			var xSC:Number = 1 + 0.045 * xCY;
			var xSH:Number = 1 + 0.015 * xCY * xTX;
			var xRT:Number = - Math.sin( dtor( 2 * xPH ) ) * xRC;
			xDL = xDL / ( WHT_L * xSL );
			xDC = xDC / ( WHT_C * xSC );
			xDH = xDH / ( WHT_H * xSH );
			
			var DeltaE200:Number = Math.sqrt( xDL*xDL + xDC*xDC + xDH*xDH + xRT * xDC * xDH );
			
			if( DeltaE200 < colorThreshold ) return true;
			else return false;
		}
		
		public function CieLab2Hue( var_a:Number, var_b:Number ):Number {          //Function returns CIE-H° value
			var var_bias:Number = 0;
			if ( var_a >= 0 && var_b == 0 ) return 0;
			if ( var_a <  0 && var_b == 0 ) return 180;
			if ( var_a == 0 && var_b >  0 ) return 90;
			if ( var_a == 0 && var_b <  0 ) return 270;
			if ( var_a >  0 && var_b >  0 ) var_bias = 0;
			if ( var_a <  0               ) var_bias = 180;
			if ( var_a >  0 && var_b <  0 ) var_bias = 360;
			
			return ( (180/3.14)*( Math.atan( var_b / var_a ) ) + var_bias );
		}
		
		public function dtor( val:Number ):Number {  
			return val * (Math.PI / 180);
		}
		
		public function isLightnessWithinRange(rgb1:uint, rgb2:uint, threshold:int = 20):Boolean {
			if ( Math.abs(rgb2Lightness(rgb1)-rgb2Lightness(rgb2)) < threshold ){
				return true;
			}else{
				return false;
			}
		}
		
		public function findColorCenterInVector(imgColorVector:Vector.<uint>, targetColor:uint, imgWidth:uint, imgHeight:uint):Vector.<uint> {
			var xPos:uint = 0;
			var yPos:uint = 0;
			var sum:uint = 0;
			var k:uint = 0;
			
			var minX:uint = 2000;
			var maxX:uint = 0;
			var minY:uint = 2000;
			var maxY:uint = 0;
			
			for ( var i:uint = 0; i < imgHeight; i++ ) {
				for ( var j:uint = 0; j < imgWidth; j++ ) {
					if(imgColorVector[k] == targetColor){
						xPos += j;
						yPos += i;
						sum++;
						
						if(minX > j)
							minX = j;
						if(minY > i)
							minY = i;
						if(maxX < j)
							maxX = j;
						if(maxY < i)
							maxY = i;
					}
					k++;
				}
			}
			var resultXY:Vector.<uint> = new <uint>[xPos/sum, yPos/sum, maxX-minX, maxY-minY];
			return resultXY;
		}
		
		/* ------- END Color Detect Chapter ------- */
		
		public function tresholdColorVector(imgColorVector:Vector.<uint>, threshold:uint, 
											isCangeTrueColor:Boolean=false, trueNewColor:uint=0x000000,
											isCangeFlaseColor:Boolean=false, falseNewColor:uint=0x00ff00):void 
		{
			for ( var i:uint = 0; i < imgColorVector.length; i++ ) {
				if( imgColorVector[i] < threshold ){
					if(isCangeTrueColor){
						imgColorVector[i] = trueNewColor;
					}
				}else{
					if(isCangeFlaseColor){
						imgColorVector[i] = falseNewColor;
					}
				}
			}
		}
		
		
		/* ------- Colors Convert Chapter ------- */
		// YPbPr
		public function rgb2gray(colorRGB:uint):uint {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			return 0.299*currR + 0.587*currG + 0.114*currB;
		}
		
		public function rgb2Pb(colorRGB:uint):uint {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			return -0.168736*currR - 0.331264*currG + 0.5*currB;
		}
		
		public function rgb2Pr(colorRGB:uint):uint {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			return 0.5*currR - 0.418688*currG - 0.081312*currB;
		}
		
		public function gray2rgb(colorGray:uint):uint {
			return (colorGray << 16 | colorGray << 8 | colorGray);
		}
		
		public function rgb2Lightness(colorRGB:uint):uint {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			
			var var_R:Number = ( currR / 255 );                     //RGB from 0 to 255
			var var_G:Number = ( currG / 255 );
			var var_B:Number = ( currB / 255 );
			
			var var_Min:Number = Math.min( var_R, var_G, var_B );    //Min. value of RGB
			var var_Max:Number = Math.max( var_R, var_G, var_B );    //Max. value of RGB
			
			return (1/2 * (var_Min + var_Max))*100;		// [0, 100]
		}
		
		public function rgb2hsv(colorRGB:uint):Vector.<int> {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			
			var var_R:Number = ( currR / 255 );                     //RGB from 0 to 255
			var var_G:Number = ( currG / 255 );
			var var_B:Number = ( currB / 255 );
			
			var var_Min:Number = Math.min( var_R, var_G, var_B );    //Min. value of RGB
			var var_Max:Number = Math.max( var_R, var_G, var_B );    //Max. value of RGB
			var del_Max:Number = var_Max - var_Min;             //Delta RGB value 
			
			var H:Number = 0;                               //HSV results from 0 to 1
			var S:Number = 0;
			var V:Number = var_Max;
			
			//if ( del_Max == 0 )                     //This is a gray, no chroma...
			//{
			//H = 0                                //HSV results from 0 to 1
			//S = 0
			//}
			//else                                    //Chromatic data...
			if ( del_Max != 0 )
			{
				S = del_Max / var_Max;
				
				var del_R:Number = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_G:Number = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				var del_B:Number = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max;
				
				if      ( var_R == var_Max ) H = del_B - del_G;
				else if ( var_G == var_Max ) H = ( 1 / 3 ) + del_R - del_B;
				else if ( var_B == var_Max ) H = ( 2 / 3 ) + del_G - del_R;
				
				if ( H < 0 ) H += 1;
				if ( H > 1 ) H -= 1;
			}
			
			var resultHSV:Vector.<int> = new <int>[H*360, S*100, V*100];
			return resultHSV;
		}
		
		public function rgb2hsl(colorRGB:uint):Vector.<int> {
			var currR:uint = (colorRGB >> 16) & 0xFF;
			var currG:uint = (colorRGB >> 8) & 0xFF;
			var currB:uint = colorRGB & 0xFF;
			
			var var_R:Number = ( currR / 255 );                     //RGB from 0 to 255
			var var_G:Number = ( currG / 255 );
			var var_B:Number = ( currB / 255 );
			
			var var_Min:Number = Math.min( var_R, var_G, var_B );    //Min. value of RGB
			var var_Max:Number = Math.max( var_R, var_G, var_B );    //Max. value of RGB
			var del_Max:Number = var_Max - var_Min;             //Delta RGB value 
			
			var H:Number = 0;                               //HSV results from 0 to 1
			var S:Number = 0;
			var L:Number = ( var_Max + var_Min ) / 2;
			
			if ( del_Max == 0 )                     //This is a gray, no chroma...
			{
				H = 0                                //HSL results from 0 to 1
				S = 0
			}
			else                                    //Chromatic data...
			{
				if ( L < 0.5 ) S = del_Max / ( var_Max + var_Min )
				else           S = del_Max / ( 2 - var_Max - var_Min )
				
				var del_R:Number = ( ( ( var_Max - var_R ) / 6 ) + ( del_Max / 2 ) ) / del_Max
				var del_G:Number = ( ( ( var_Max - var_G ) / 6 ) + ( del_Max / 2 ) ) / del_Max
				var del_B:Number = ( ( ( var_Max - var_B ) / 6 ) + ( del_Max / 2 ) ) / del_Max
				
				if      ( var_R == var_Max ) H = del_B - del_G
				else if ( var_G == var_Max ) H = ( 1 / 3 ) + del_R - del_B
				else if ( var_B == var_Max ) H = ( 2 / 3 ) + del_G - del_R
				
				if ( H < 0 ) H += 1
				if ( H > 1 ) H -= 1
			}
			
			var resultHSV:Vector.<int> = new <int>[H*360, S*100, L*100];
			return resultHSV;
		}
		
		public function hex2CIE_Lab(colorFirst:uint):Vector.<Number> {
			var currR:uint = (colorFirst >> 16) & 0xFF;
			var currG:uint = (colorFirst >> 8) & 0xFF;
			var currB:uint = colorFirst & 0xFF;
			
			// RGB —> XYZ
			var var_R:Number = ( currR / 255 );                     //RGB from 0 to 255
			var var_G:Number = ( currG / 255 );
			var var_B:Number = ( currB / 255 );
			
			if ( var_R > 0.04045 ) var_R = Math.pow ( ( var_R + 0.055 ) / 1.055, 2.4 );
			else                   var_R = var_R / 12.92;
			if ( var_G > 0.04045 ) var_G = Math.pow ( ( var_G + 0.055 ) / 1.055, 2.4 );
			else                   var_G = var_G / 12.92;
			if ( var_B > 0.04045 ) var_B = Math.pow ( ( var_B + 0.055 ) / 1.055, 2.4 );
			else                   var_B = var_B / 12.92;
			
			var_R = var_R * 100;
			var_G = var_G * 100;
			var_B = var_B * 100;
			
			
			//XYZ —> CIE-L*ab
			
			//Observer. = 2°, Illuminant = D65
			var X:Number = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805;
			var Y:Number = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722;
			var Z:Number = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505;
			
			
			var var_X:Number = X / 95.047;			//ref_X =  95.047   Observer= 2°, Illuminant= D65
			var var_Y:Number = Y / 100;				//ref_Y = 100.000
			var var_Z:Number = Z / 108.883;			//ref_Z = 108.883
			
			if ( var_X > 0.008856 ) var_X = Math.pow ( var_X, 1/3 );
			else                    var_X = ( 7.787 * var_X ) + ( 16 / 116 );
			if ( var_Y > 0.008856 ) var_Y = Math.pow ( var_Y, 1/3 );
			else                    var_Y = ( 7.787 * var_Y ) + ( 16 / 116 );
			if ( var_Z > 0.008856 ) var_Z = Math.pow ( var_Z, 1/3 );
			else                    var_Z = ( 7.787 * var_Z ) + ( 16 / 116 );
			
			var CIE_L:Number = ( 116 * var_Y ) - 16;
			var CIE_a:Number = 500 * ( var_X - var_Y );
			var CIE_b:Number = 200 * ( var_Y - var_Z );
			
			var result_CIE_Lab:Vector.<Number> = new <Number>[CIE_L, CIE_a, CIE_b];
			return result_CIE_Lab;
		}
		
		// IntergralMatrix
		public function setupIntergralMatrix(srcVector:Vector.<uint>, targetVector:Vector.<uint>, imgWidth:uint, imgHeight:uint):void {
			var i:uint = 0;
			var j:uint = 0;
			
			targetVector[0] = srcVector[0];
			
			for (i = 1; i < imgWidth; i++){
				targetVector[i] =  srcVector[i]+targetVector[i-1];
			}
			
			for (i = 1; i < imgHeight; i++){
				targetVector[i*imgWidth] = srcVector[i*imgWidth] + targetVector[i*imgWidth-imgWidth];
			}
			
			
			var n:uint = imgWidth; // +1
			
			for (i = 1; i < imgHeight; i++){
				n++;
				for (j = 1; j < imgWidth; j++){
					//integralImg[n] = rgbToGray( srcBitmapData.getPixel(j, i) )  + integralImg[n-1] + integralImg[n-imgWidth] + integralImg[n-imgWidth-1];
					targetVector[n] = srcVector[n] + targetVector[n-1] + targetVector[n-imgWidth] + targetVector[n-imgWidth-1]
					n++;
				}
			}
		}
		
		/* ------- END Colors Convert Chapter ------- */
		
		
		
		/* ------- VectorImage Processing Chapter ------- */
		
		// НЕ РАБОТАЕТ!
		public function delNoise(imgColorVector:Vector.<uint>, fonValue:int, iterations:uint):void {
			for (var j:uint = 0; j < iterations; j++){
				for (var i:uint = 1; i < imgColorVector.length-1; i++){
					if( (imgColorVector[i] != fonValue) && (imgColorVector[i+1] == fonValue) && (imgColorVector[i-1] == fonValue) ){
						imgColorVector[i] = fonValue;
					}
				}
			}
		}
		
		public function delBinarVectorNoise(imgVector:Vector.<uint>, n:uint, videoWidth:int, targetValueToDel:uint = 0):void {
			var lasrRowValue:int = imgVector.length-videoWidth;
			for( var i:uint = 0; i < n; i++ ) {
				for( var j:uint = 0; j < imgVector.length; j++ ) {
					if( j < lasrRowValue ){
						if( (imgVector[j] == targetValueToDel && imgVector[j+1] != targetValueToDel) ||
							(imgVector[j] == targetValueToDel && imgVector[j+videoWidth] != targetValueToDel )){
							if(targetValueToDel == 0)
								imgVector[j] = 1;
							else
								imgVector[j] = 0;
						}
					}else {
						if(targetValueToDel == 0)
							imgVector[j] = 1;
						else
							imgVector[j] = 0;
					}
				}
			}
		}
		
		private function findColorsBlobs(imgColorVector:Vector.<uint>, color:int, threshold:uint,
										 videoWidth:uint, videoHeight:uint):void {
			var i:uint = 0;
			var j:uint = 0;
			var k:int = 0;
			
			var mainCoordsArr:Vector.<Number> = new Vector.<Number>(videoWidth*videoHeight);
			for ( i = 0; i < mainCoordsArr.length; i++ ) {
				mainCoordsArr[i] = -1;
			}
			
			var blobsCounter:int = 1;
			
			for ( i = 0; i < videoHeight; i++ ) {
				for ( j = 0; j < videoWidth; j++ ) {
					
					
					if( (k-1) >= 0 && (k+1) < imgColorVector.length &&
						(k-videoHeight) >= 0 && (k+videoHeight) < imgColorVector.length){
						
						//if( isColourWithinRangeValue( imgColorVector[k], color, threshold ) ){
						//if( hex2hsv(imgColorVector[k], 60, 200 ) ){
						if( imgColorVector[k] == 0xffffff ){
							
							//imgColorVector[k] = 0xff0000;
							
							if( mainCoordsArr[k-1] != -1 ){
								mainCoordsArr[k] = mainCoordsArr[k-1];
							}
							else if( mainCoordsArr[k+1] != -1 ){
								mainCoordsArr[k] = mainCoordsArr[k+1];
							}
							else if( mainCoordsArr[k-videoHeight] != -1 ){
								mainCoordsArr[k] = mainCoordsArr[k-videoHeight];
							}
							else if( mainCoordsArr[k+videoHeight] != -1 ){
								mainCoordsArr[k] = mainCoordsArr[k+videoHeight];
							}
							else{
								mainCoordsArr[k] = blobsCounter;
								blobsCounter++;
							}
							
						}
					}
					
					k++;
				}
				
			}
			
			var xCoordsArr:Vector.<Number> = new Vector.<Number>(blobsCounter);
			var yCoordsArr:Vector.<Number> = new Vector.<Number>(blobsCounter);
			var coordsCounterArr:Vector.<Number> = new Vector.<Number>(blobsCounter);
			
			k = 0;
			for ( i = 0; i < videoHeight; i++ ) {
				for ( j = 0; j < videoWidth; j++ ) {
					
					if(mainCoordsArr[k] != -1){
						xCoordsArr[mainCoordsArr[k]] += j;
						yCoordsArr[mainCoordsArr[k]] += i;
						coordsCounterArr[mainCoordsArr[k]] += 1;
					}
					
					k++;
				}
			}
			
			for ( i = 0; i < xCoordsArr.length; i++ ) {
				xCoordsArr[i] = xCoordsArr[i]/coordsCounterArr[i];
				yCoordsArr[i] = yCoordsArr[i]/coordsCounterArr[i];
				coordsCounterArr[i] = coordsCounterArr[i]*0.9;
				if(coordsCounterArr[i] < 4){
					coordsCounterArr[i] = -1;
				}
			}
			
			
			var xCoordsArrNew:Vector.<int> = new Vector.<int>(blobsCounter);
			var yCoordsArrNew:Vector.<int> = new Vector.<int>(blobsCounter);
			var blobSizesNew:Vector.<int> = new Vector.<int>(blobsCounter);
			
			var xSumer:int;
			var ySumer:int;
			var sizeSumer:int;
			var xSumerCounter:int;
			
			k = 0;
			for ( i = 0; i < xCoordsArr.length; i++ ) {
				xSumer = 0;
				ySumer = 0;
				sizeSumer = 0;
				xSumerCounter = 0;
				
				for ( j = i+1; j < xCoordsArr.length; j++ ) {
					
					if( coordsCounterArr[j] > 0 ){
						if( Math.sqrt( (xCoordsArr[i]-xCoordsArr[j])*(xCoordsArr[i]-xCoordsArr[j]) + (yCoordsArr[i]-yCoordsArr[j])*(yCoordsArr[i]-yCoordsArr[j]) ) < coordsCounterArr[i] ){
							xSumer += xCoordsArr[j];
							ySumer += yCoordsArr[j];
							sizeSumer += coordsCounterArr[j];
							xSumerCounter++;
							
							coordsCounterArr[j] = -1;
						}
					}
					
				}
				
				
				if(xSumerCounter != 0){
					xCoordsArrNew[k] = (xCoordsArr[i]+xSumer/xSumerCounter)/2;
					yCoordsArrNew[k] = (yCoordsArr[i]+ySumer/xSumerCounter)/2;
					blobSizesNew[k] = (coordsCounterArr[i]+sizeSumer/xSumerCounter)/2;
				}else{
					xCoordsArrNew[k] = xCoordsArr[i];
					yCoordsArrNew[k] = yCoordsArr[i];
					blobSizesNew[k] = coordsCounterArr[i];
				}
				
				if(blobSizesNew[k] > 2){
					k++;
				}
				
				
			}
			//detectorContainer.graphics.lineStyle(1, 0x00ff00, 0.5);
			//for ( i = 0; i < xCoordsArr.length; i++ ) {
			//detectorContainer.graphics.drawCircle(xCoordsArrNew[i], yCoordsArrNew[i], blobSizesNew[i]);
			//}
		}
		/* ------- END VectorImage Processing Chapter ------- */
	}
}


