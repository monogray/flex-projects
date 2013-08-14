package game_impl
{
	import flash.display.*;
	
	import mono_core.ButtonCore;
	
	import screens.ScreenCore;
	
	public class Screen_4 extends ScreenCore
	{
		[Embed(source = '../../assets/global/cursor.png')]
		private var cursorClass		:Class;
		private var cursor			:Bitmap = new cursorClass();
		
		[Embed(source = '../../assets/global/bg.jpg')]
		private var bgClass		:Class;
		private var bg			:Bitmap = new bgClass();
		
		[Embed(source = '../../assets/global/back.png')]
		private var bt1Class	:Class;
		private var bt1			:Bitmap = new bt1Class();
		
		[Embed(source = '../../assets/global/next.png')]
		private var bt2Class	:Class;
		private var bt2			:Bitmap = new bt2Class();
		
		private var bt_1				:ButtonCore = new ButtonCore();
		private var bt_2				:ButtonCore = new ButtonCore();
		
		private var firstDelay			:int = 0;
		private var firstDelayMax		:int = 24;
		
		//private var motionCount			:int = 0;
		//private var motionCountMax		:int = 320*240*0.5;
		//private var motionCountMax2		:int = 320*240*0.95;
		
		private	var motionX				:Number = 0;
		private	var motionY				:Number = 0;
		
		private var objX				:Vector.<Number> = new Vector.<Number>();
		private var objY				:Vector.<Number> = new Vector.<Number>();
		private var isInCenter			:Vector.<Boolean> = new Vector.<Boolean>();
		
		private var objCavwas			:Sprite = new Sprite();
		private var drawCavwas			:Sprite = new Sprite();
		private var cursorCavwas		:Sprite = new Sprite();
		
		public function Screen_4() {
			this.setStepsCount(0);
			
			container.addChild(bg);
			
			bt_1.addBitmap(bt1).setPosition(25, 650).addEventListener("CLICK", clickPrev);
			bt_2.addBitmap(bt2).setPosition(640, 650).addEventListener("CLICK", clickNext);
			container.addChild(bt_1.getContainer());
			container.addChild(bt_2.getContainer());
			
			container.addChild(drawCavwas);
			container.addChild(objCavwas);
			container.addChild(cursorCavwas);
			cursorCavwas.addChild(cursor);
			cursor.x -= 5;
			
			objToStartPos();
		}
		
		private function objToStartPos():void {
			objX = new <Number>[400, 750, 400, 50];
			objY = new <Number>[80, 400, 750, 400];
			isInCenter = new <Boolean>[false, false, false, false];
		}
		
		private function drawObj():void {
			objCavwas.graphics.clear();
			objCavwas.graphics.beginFill(0x00ff22, 1);
			objCavwas.graphics.lineStyle(3, 0x00ff22, 0.6);
			for(var i:int = 0; i < objX.length; i++){
				if( Math.sqrt((motionX - objX[i])*(motionX - objX[i]) + (motionY - objY[i])*(motionY - objY[i])) < 150 &&
					!isInCenter[i] )
				{
					objCavwas.graphics.moveTo(motionX, motionY);
					objCavwas.graphics.lineTo(objX[i], objY[i]);
					
					objX[i] += (motionX - objX[i])*0.1;
					objY[i] += (motionY - objY[i])*0.1;
				}
				
				if( Math.sqrt((400 - objX[i])*(400 - objX[i]) + (400 - objY[i])*(400 - objY[i])) < 120 ){
					isInCenter[i] = true;
				}
				
				if( isInCenter[i] ){
					objX[i] += (400 - objX[i])*0.1;
					objY[i] += (400 - objY[i])*0.1;
				}
				
				objCavwas.graphics.drawCircle(objX[i], objY[i], 15);
			}
			objCavwas.graphics.endFill();
		}
		
		//public function next(e:MouseEvent):void {
		//this.nextStep();
		//}
		
		public override function beforShow():void {
			Globals.colorWorks.createColorVector();
			Globals.colorWorks.createAdaptiveColorVectorTmp(1);
			objToStartPos();
			motionX = 400;
			motionY = 400;
		}
		
		public override function loop():void {
			Globals.colorWorks.createColorVector();
			//Globals.colorWorks.motionDetectionWithPosition();
			//Globals.colorWorks.motionDetectionWitnAdditionColor(0xcdaaa2);
			Globals.colorWorks.motionDetectionWitnAdditionColorAndPosition(0xcdaaa2, 200, (motionX+170)/5, (motionY+170)/5);
			//Globals.colorWorks.motionDetectionWitnPosition((motionX+170)/5, (motionY+170)/5);
			
			Globals.colorWorks.deleteNoiseInVector(Globals.colorWorks.getColorMotionVector(), 10);
			Globals.colorWorks.motionPosition();
			//if(firstDelay < firstDelayMax){
				//Globals.colorWorks.createColorVectorTmpImmediately();
			//}else{
				//Globals.colorWorks.createAdaptiveColorVectorTmp();
			Globals.colorWorks.createAdaptiveColorVectorTmp(1);
			//}
			Globals.colorWorks.drawBinaryColorVector( Globals.colorWorks.getColorMotionVector() );
			//Globals.colorWorks.drawColorVector( Globals.colorWorks.getColorVectorTmp() );
			
			motionX = ( motionX * 25 + (Globals.colorWorks.getMotionX() * 5 - 170) ) / 26;
			motionY = ( motionY * 25 + (Globals.colorWorks.getMotionY() * 5 - 170) ) / 26;
			if(motionX < 0) motionX = 0;
			if(motionY < 0) motionY = 0;
			if(motionX > 750) motionX = 750;
			if(motionY > 750) motionY = 750;
			
			setPos(cursorCavwas, motionX, motionY);
			
			/*motionCount = (motionCount + Globals.colorWorks.getMotionCount()) / 2;
			if(motionCount > motionCountMax2)
				motionCount = 0;*/
			
			/*if(firstDelay < firstDelayMax){
				firstDelay++;
				motionCount = 0;
			}*/
			
			//drawCavwas.graphics.clear();
			//drawCavwas.graphics.beginFill(0xff2222, 1);
			//drawCavwas.graphics.drawRect(10, 250, motionCount*(790/motionCountMax), 20);
			//drawCavwas.graphics.drawCircle(motionX, motionY, 20);
			//drawCavwas.graphics.endFill();
			
			drawObj();
			
			/*if(motionCount > motionCountMax && motionCount < motionCountMax2){
				this.nextStep();
				motionCount = 0;
				firstDelay = 0;
			}*/
		}
	}
}