package {
	import flash.display.Sprite;
	
	import d2.axime.Axime;
	import d2.axime.logging.DebugLogger;
	import d2.axime.logging.FlashTextLogger;
	import d2.axime.logging.Logger;
	
	import launchers.Launcher_AA;
	
	[SWF(width = "450", height = "800", backgroundColor = "0x0", frameRate = "60")]
public class Render_01____Node extends Sprite {
	
	public function Render_01____Node() {
		var logger_A:Logger;
		var isDebugger:Boolean;
		
//		logger_A = new FlashTextLogger(stage, false, 80, 465, 400, true);
//		isDebugger = true;
		logger_A = new DebugLogger;
		Axime.startup(1080, 1920, stage, Launcher_AA, logger_A, isDebugger, false);
	}
}
}