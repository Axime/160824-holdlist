package view.comp
{
	import d2.axime.Axime;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.utils.AMath;
	
	public class Range_CompAA extends StateAA
	{
		
		public function get ratio() : Number {
			return _ratio;
		}
		
		public function set ratio(v:Number):void{
			_ratio = AMath.clamp(v,0,1);
			
			_holdLightImg.x = LIGHT_START_X + (LIGHT_END_X - LIGHT_START_X)*_ratio;
			_holdLightImg.y = START_Y + (END_Y - START_Y)*_ratio;
			_holdImg.y = START_Y + (END_Y - START_Y)*_ratio;
			
			_holdImg.alpha = _ratio;
		}
		
		
		
		private var LIGHT_START_X:Number;
		private var LIGHT_END_X:Number;
		
		private var START_Y:Number;
		private var END_Y:Number;
		
		
		
		override public function onEnter():void {
			
			_holdImg = new ImageAA;
			this.getFusion().addNode(_holdImg);
			_holdImg.textureId = "common/img/hold2.png";
			_holdImg.pivotY = _holdImg.sourceHeight / 2;
			_holdImg.x = -_holdImg.sourceWidth / 2;
			START_Y = 0.0;
			END_Y = 125;
			
			//_holdImg.alpha = 0.0;
			
			_holdLightImg = new ImageAA;
			this.getFusion().addNode(_holdLightImg);
			_holdLightImg.textureId = "common/img/holdLight.png";
			_holdLightImg.pivotY = _holdLightImg.sourceHeight / 2;
			
			LIGHT_START_X = -_holdImg.sourceWidth / 2 - _holdLightImg.sourceWidth;
			LIGHT_END_X = _holdImg.sourceWidth / 2;
			
			_holdLightImg.x = LIGHT_START_X;
			
			
			
		}
		
		
		
		protected var _holdImg:ImageAA;
		protected var _holdLightImg:ImageAA;
		
		protected var _ratio:Number;
		
		
	}
}