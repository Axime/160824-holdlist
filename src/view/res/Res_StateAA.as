package view.res {
	import d2.axime.display.StateAA;
	import d2.axime.events.AEvent;
	import d2.axime.resource.AssetMachine;
	import d2.axime.utils.AMath;
	
public class Res_StateAA extends StateAA {
	
	public function Res_StateAA( RM:AssetMachine, callback:Function ) {
		m_RM = RM;
		m_callback = callback;
	}
	
	override public function onEnter() : void {
		m_RM.addEventListener(AEvent.COMPLETE, onComplete);
	}
	
	
	
	private var m_RM:AssetMachine;
	private var m_callback:Function;
	
	
	
	private function onComplete(e:AEvent):void {
		m_RM.removeEventListener(AEvent.COMPLETE, onComplete);
		
//		trace(AMath.adverse(1,21));
		
		
		this.getView().kill();
		m_callback();
	}
}
}