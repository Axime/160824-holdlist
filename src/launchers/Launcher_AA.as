package launchers {
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	
	import d2.axime.Axime;
	import d2.axime.display.AAFacade;
	import d2.axime.display.IRootLauncher;
	import d2.axime.display.RootAA;
	import d2.axime.events.AEvent;
	import d2.axime.launch.DesktopPlatform;
	import d2.axime.launch.IAximeLauncher;
	import d2.axime.launch.IPlatform;
	import d2.axime.launch.MobilePlatform;
	import d2.axime.resource.AssetMachine;
	import d2.axime.resource.converters.AtfAssetConvert;
	import d2.axime.resource.converters.AtlasAssetConvert;
	import d2.axime.resource.converters.SwfClassAssetConverter;
	import d2.axime.utils.Stats;
	
	import view.Entry_ViewAA;
	import view.Res_ViewAA;
	
public class Launcher_AA implements IAximeLauncher, IRootLauncher {
	
	public function platform() : IPlatform {
		if(Multitouch.maxTouchPoints == 0){
			return new DesktopPlatform(false);
		}
		return new MobilePlatform(false, true);
	}
	
	public function onLaunch() : void {
//		var d:TheMiner;
		
//		d = new TheMiner;
//		d.y = 20;
//		stage.addChild(d);
		
//		Axime.getWindow().getStage().addChild(new Stats());
		
		Axime.getWindow().getKeyboard().getKey(Keyboard.BACK).setPreventDefault(true);
		
		AssetMachine.activate(SwfClassAssetConverter);
		AssetMachine.activate(AtlasAssetConvert);
		AssetMachine.activate(AtfAssetConvert);
		
//		Axime.getWindow().getKeyboard().getKey(Keyboard.BACK).setPreventDefault(true);
		//_winA.getTouch().autoUnbindingWhenLeaving = true;
		
		//AAFacade.requestRoot(this, true);
		AAFacade.requestRoot(this, false,0xFFFFFF);
	}
	
	private var _rootA:RootAA;
	private var coreRes:AssetMachine;
	
	public function onRootCreated( root:RootAA ) : void {
		
		var resView:Res_ViewAA;
		
//		AAFacade.setAntiAlias(16);
		_rootA = root;
		coreRes = Res_ViewAA.getRes();
		resView = new Res_ViewAA(coreRes, function() : void {
			root.addView(new Entry_ViewAA);
		});
		root.addView(resView);
		
		root.addEventListener(AEvent.INTERRUPT, ____onInterrupt);
	}
	
	private function ____onInterrupt(e:AEvent):void{
		coreRes.addEventListener(AEvent.COMPLETE, ____onAssetReset);
		coreRes.restartAll();
		_rootA.setVisibleForAllViews(false);
		Axime.getTick().timeScale = 0.0;
	}
	
	private function ____onAssetReset(e:AEvent):void{
		coreRes.removeEventListener(AEvent.COMPLETE, ____onAssetReset);
		
		_rootA.setVisibleForAllViews(true);
		Axime.getTick().timeScale = 1.0;
	}
}
}