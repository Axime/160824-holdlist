package view.entry
{
	import d2.axime.Axime;
	import d2.axime.animate.ATween;
	import d2.axime.animate.TweenMachine;
	import d2.axime.animate.easing.Quad;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.utils.AMath;
	import d2.axime.window.Touch;
	
	import view.ViewConfig;
	import view.comp.Range_CompAA;
	
	public class TabItem_StateAA extends StateAA
	{
		
		public function TabItem_StateAA(bgTex:String) {
			_bgTex = bgTex;
		}
		
		
		
		public function revert() : void{
			var tween:ATween;
			
			tween = TweenMachine.to(_dragFN, _ratio * 0.3,{y: 0});
//			Axime.getWindow().getTouch().touchEnabled = false;
//			tween.onComplete = function():void{
//				Axime.getWindow().getTouch().touchEnabled = true;
//			}
			
			tween.easing = Quad.easeOut;
			
			TweenMachine.to(_holdState, _ratio * 0.3, {ratio:0});
		}
		
		
		
		override public function onEnter():void {
			var stateFN:StateFusionAA;
			
			stateFN = new StateFusionAA;
			this.getFusion().addNode(stateFN);
			stateFN.setState(new Range_CompAA);
			_holdState = stateFN.getState() as Range_CompAA;
			stateFN.x = Axime.getWindow().rootWidth / 2;
			stateFN.y = 300;
			
			
			
			_dragFN = new FusionAA;
			this.getFusion().addNode(_dragFN);
			
			_bg = new ImageAA;
			_bg.textureId = _bgTex;
			_dragFN.addNode(_bg);
			
			_bg.y = 220;
			
			
			this.getFusion().addEventListener(NTouchEvent.PRESS, onStartDrag);
		}
		
		
		
		protected var _dragFN:FusionAA;
		protected var _bgTex:String;
		protected var _bg:ImageAA;
		protected var _currTouch:Touch;
		protected var _ratio:Number = 0.0;
		

		protected var _startY:Number;
		protected var _holdState:Range_CompAA;
		
		
		private function onStartDrag(e:NTouchEvent):void{
			_currTouch = e.touch;
			
			_currTouch.addEventListener(AEvent.CHANGE, onTouchChange);
			_currTouch.addEventListener(AEvent.COMPLETE, onTouchComplete);
			
			TweenMachine.getInstance().stopTarget(_dragFN);
			
			
			_startY = _dragFN.y;
		}
		
		private function onTouchChange(e:AEvent):void{
			var tmpRatio:Number;
			var offsetY:Number;
			var coordY:Number;
			var tween:ATween;
			
			_ratio = _currTouch.rootY / Axime.getWindow().rootHeight / 1.25;
			tmpRatio = 1.0 - _ratio * _ratio;
			_startY = _startY + (_currTouch.rootY - _currTouch.prevRootY) * tmpRatio;
			if(_startY < 0){
				_startY = 0;
			}
			tween = TweenMachine.to(_dragFN, 0.05,{y: _startY});
			
//			offsetY = _currTouch.rootY - _startY;
//			offsetY = offsetY * (1 - Math.abs(offsetY) / Axime.getWindow().rootHeight);
//			coordY = _startY + offsetY;
//			if(coordY < 0){
//				coordY = 0;
//			}
//			TweenMachine.to(_dragFN, 0.05,{y: coordY});
			
			//_holdState.ratio = AMath.calcRatio(_ratio * 1.25, 0.25, 0.45);
			tween.onUpdate = function() :void{
				_holdState.ratio = AMath.calcRatio(_dragFN.y / Axime.getWindow().rootHeight, 0.05, 0.22);
			}
		}
		
		
		private function onTouchComplete(e:AEvent):void{
//			if((_dragFN.y>ViewConfig.DRAG_LIMIT - 30 && _currTouch.velocityY > -115) || _currTouch.velocityY > 110){
				if((_dragFN.y>ViewConfig.DRAG_LIMIT - 30 && _currTouch.velocityY > -110)){
				TweenMachine.to(_dragFN, 0.15,{y: ViewConfig.DRAG_LIMIT}).easing = Quad.easeOut;
			}
			else {
				this.revert();
			}
		}
	}
}