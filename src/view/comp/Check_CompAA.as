package view.comp
{
	import flash.geom.Point;
	
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.utils.AMath;
	import d2.axime.window.Touch;
	
	public class Check_CompAA extends StateAA
	{
		public function Check_CompAA(texA:String, texB:String, isSelected:Boolean, callback:Function, customTouch:Boolean = false)
		{
			_texA = texA;
			_texB = texB;
			_isSelected = isSelected;
			_customTouch = customTouch;
			_callback = callback;
		}
		
		
		public function setTex(texA:String, texB:String):void{
			_texA = texA;
			_texB = texB;
			
			_img.textureId = "common/" + (_isSelected ? _texB : _texA);
		}
		
		public function setSelected(b:Boolean):void{
			_isSelected = b;
			_img.textureId = "common/" + (_isSelected ? _texB : _texA);
		}
		
		
		override public function onEnter() : void{
			_img = new ImageAA;
			_img.textureId = "common/" + (_isSelected ? _texB : _texA);
			this.getFusion().addNode(_img);
			
			_img.pivotX = _img.sourceWidth / 2;
			_img.pivotY = _img.sourceHeight / 2;
			
			if(_texText){
				_textImg = new ImageAA;
				_textImg.textureId = "common/" + _texText;
				this.getFusion().addNode(_textImg);
				
				_textImg.pivotX = _textImg.sourceWidth / 2;
				_textImg.pivotY = _textImg.sourceHeight / 2;
				
				
				if(_isTextHoriz){
					_textImg.x = 66;
				}
				else {
					_textImg.y = 99;
				}
				
				_textImg.touchable = false;
			}
			
			
			this.getFusion().addEventListener(NTouchEvent.PRESS, onPress);
		}
		
		
		
		private var _texA:String;
		private var _texB:String;
		private var _texText:String;
		
		private var _img:ImageAA;
		private var _textImg:ImageAA;
		private var _isSelected:Boolean;
		
		private var _rootCoordX:Number;
		private var _rootCoordY:Number;
		private var _touch:Touch;
		private var _customTouch:Boolean;
		private var _isTextHoriz:Boolean;
		private var _callback:Function;
		
		
		private function onPress(e:NTouchEvent):void{
			var p:Point;
			
			p = this.getFusion().localToGlobal(0,0);
			_rootCoordX = p.x;
			_rootCoordY = p.y;
			_touch = e.touch;
			
			this.doUpdateStatus();
			
			e.touch.addEventListener(AEvent.CHANGE, onTouchChange);
			e.touch.addEventListener(AEvent.COMPLETE, onTouchComplete);
		}
		
		private function onTouchChange(e:AEvent):void{
			this.doUpdateStatus();
		}
		
		private function onTouchComplete(e:AEvent):void{
			if(_isSelected){
				return;
			}
			_isSelected = (_img.textureId == ("common/" + _texB));
			
			_callback();
		}
		
		private function doUpdateStatus() : void{
			var inRange:Boolean;
			
			if(_isSelected){
				return;
			}
			if(_customTouch) {
				inRange = AMath.distance(_rootCoordX, _rootCoordY, _touch.rootX, _touch.rootY) < 330;
			}
			else {
				inRange = this.getFusion().hitTestPoint(_touch.rootX, _touch.rootY);
			}
			
			if(_isSelected) {
				if(inRange) {
					_img.textureId = "common/" + _texA;
//					_isSelected = false;
				}
				else {
					_img.textureId = "common/" + _texB;
//					_isSelected = true;
				}
			}
			else {
				if(inRange) {
					_img.textureId = "common/" + _texB;
//					_isSelected = true;
				}
				else {
					_img.textureId = "common/" + _texA;
//					_isSelected = false;
				}
			}
		}
		
		
	}
}