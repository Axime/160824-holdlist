package view.entry {
	import d2.axime.Axime;
	import d2.axime.animate.ATween;
	import d2.axime.animate.TweenMachine;
	import d2.axime.animate.easing.Cubic;
	import d2.axime.animate.easing.Quad;
	import d2.axime.display.FusionAA;
	import d2.axime.display.ImageAA;
	import d2.axime.display.StateAA;
	import d2.axime.display.StateFusionAA;
	import d2.axime.enum.EDirection;
	import d2.axime.enum.ETouchMode;
	import d2.axime.events.AEvent;
	import d2.axime.events.NTouchEvent;
	import d2.axime.gesture.GestureFacade;
	import d2.axime.gesture.SwipeGestureRecognizer;
	
	import view.ViewConfig;
	import view.comp.Check_CompAA;
	
	// touch -> value(tween) -> ...
	
public class Entry_StateAA extends StateAA {
	
	override public function onEnter() : void {
		Axime.getWindow().getTouch().touchMode = ETouchMode.SINGLE;
		Axime.getWindow().getTouch().velocityEnabled = true;
		
		this.doMakeTop();
		this.doMakeBottom();
		
		this.doMakeGesture();
		
	}
	
	override public function onExit() : void {
		
	}
	
	
	private var _topImg:ImageAA;
	
	
	private var _bottomFN:FusionAA;
	private var _stateA:Dialing_StateAA;
	private var _stateB:Contacts_StateAA;
	private var _currState:StateAA;
	
	private var _tabGesture:SwipeGestureRecognizer;
	private var _tabState1:Check_CompAA;
	private var _tabState2:Check_CompAA;
	
	
	
	
	private function doMakeTop() :void{
		var stateFN:StateFusionAA;
		
		_topImg = new ImageAA;
		_topImg.textureId = "common/img/top.jpg";
		this.getFusion().addNode(_topImg);
		
		stateFN = new StateFusionAA;
		this.getFusion().addNode(stateFN);
		stateFN.setState(new Check_CompAA("btn/a0.png","btn/a1.png",true, function():void{
		
			_tabState2.setSelected(false);
			
			doTurntoState(_stateA);
		
		}));
		_tabState1 = stateFN.getState() as Check_CompAA;
		stateFN.x = 250;
		stateFN.y = 145;
		
		
		stateFN = new StateFusionAA;
		this.getFusion().addNode(stateFN);
		stateFN.setState(new Check_CompAA("btn/b0.png","btn/b1.png",false,function():void{
			
			_tabState1.setSelected(false);
			
			doTurntoState(_stateB);
			
		}));
		_tabState2 = stateFN.getState() as Check_CompAA;
		stateFN.x = 445;
		stateFN.y = 145;
	}
	
	private function doMakeBottom() :void{
		var stateFN:StateFusionAA;
		
		_bottomFN = new FusionAA;
		this.getFusion().addNode(_bottomFN);
		
		stateFN = new StateFusionAA;
		_bottomFN.addNode(stateFN);
		stateFN.setState(new Dialing_StateAA("common/img/list_A.jpg"));
		_stateA = stateFN.getState() as Dialing_StateAA;
		
		stateFN = new StateFusionAA;
		_bottomFN.addNode(stateFN);
		stateFN.setState(new Contacts_StateAA("common/img/list_B.jpg"));
		_stateB = stateFN.getState() as Contacts_StateAA;
		
		stateFN.x = Axime.getWindow().rootWidth;
		
		
		_currState = _stateA;
		
	}
		
	private function doMakeGesture():void{
		_tabGesture = GestureFacade.recognize(_bottomFN, SwipeGestureRecognizer) as SwipeGestureRecognizer;
		_tabGesture.setDistance(80);
		
		_tabGesture.addEventListener(AEvent.COMPLETE, onTabSwipeComplete);
		
	}
	
	private function onTabSwipeComplete(e:AEvent):void{
		var direction:int;
		
		
		direction = _tabGesture.getDirection()
		if(direction == EDirection.LEFT) {
			if(_currState == _stateA){
				this.doTurntoState(_stateB);
			}
		}
		else if(direction == EDirection.RIGHT) {
			if(_currState == _stateB){
				this.doTurntoState(_stateA);
			}
		}
		
	}
	
	private function doTurntoState(nextState:StateAA):void{
		var tween:ATween;
		
		if(nextState == _stateB){
			tween = TweenMachine.to(_bottomFN, ViewConfig.TAB_DURA, {x:-Axime.getWindow().rootWidth});
			
			_tabState1.setSelected(false);
			_tabState2.setSelected(true);
		}
		else if(nextState == _stateA){
			tween = TweenMachine.to(_bottomFN, ViewConfig.TAB_DURA, {x:0});
			
			_tabState1.setSelected(true);
			_tabState2.setSelected(false);
		}
		_currState = nextState;
		Axime.getWindow().getTouch().touchEnabled = false;
		tween.onComplete = function():void{
			Axime.getWindow().getTouch().touchEnabled = true;
			
		}
			
		tween.easing = Quad.easeOut;
	}
	
	
}
}