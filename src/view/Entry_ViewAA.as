package view {
	import d2.axime.Axime;
	import d2.axime.display.ViewAA;
	import d2.axime.window.AWindow;
	
	import view.entry.Entry_StateAA;
	
public class Entry_ViewAA extends ViewAA {
	
	override public function onViewAdded() : void {
		_winA = Axime.getWindow();
		
		this.setState(new Entry_StateAA);
		
		
	}
	
	
	
	private var _winA:AWindow;
	
	
	
}
}