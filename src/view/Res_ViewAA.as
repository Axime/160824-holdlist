package view {
	import d2.axime.display.ViewAA;
	import d2.axime.events.AEvent;
	import d2.axime.resource.AssetMachine;
	import d2.axime.resource.EmbeddedBundle;
	import d2.axime.resource.FilesBundle;
	import d2.axime.resource.handlers.TextureAA_BundleHandler;
	
	import res.ResCoreUtil;
	
	import view.res.Res_StateAA;
	
public class Res_ViewAA extends ViewAA {
	
	public function Res_ViewAA( RM:AssetMachine, callback:Function, preRM:AssetMachine = null ) {
		m_RM = RM;
		m_callback = callback;
		m_preRM = preRM;
	}
	
	public static var g_AM:AssetMachine;
	public static function getRes() : AssetMachine {
		var filenameList:Vector.<String>;
		
		if(!g_AM) {
			g_AM = new AssetMachine("common/", false);
//			
			
			filenameList = new <String>[
				"img/frame.png", 
				"img/top.jpg",
				"img/list_A.jpg",
				"img/list_B.jpg", 
				"img/hold.jpg", 
				
				"btn/a0.png", 
				"btn/a1.png", 
				"btn/b0.png", 
				"btn/b1.png", 
			];
			
			g_AM.addBundle(new FilesBundle(filenameList), new TextureAA_BundleHandler(1.0));
		}
		
		return g_AM;
	}
	
	override public function onViewAdded() : void {
		if(m_preRM != null) {
			m_preRM.addEventListener(AEvent.COMPLETE, ____preCompleted);
		}
		else {
			this.____doStartLoad();
		}
	}
	
	
	
	private var m_RM:AssetMachine;
	private var m_callback:Function;
	private var m_preRM:AssetMachine;
	
	
	
	private function ____preCompleted( e:AEvent ) : void {
		m_preRM.removeEventListener(AEvent.COMPLETE, ____preCompleted);
		
		this.____doStartLoad();
	}
	
	private function ____doStartLoad() : void {
		this.setState(new Res_StateAA(m_RM, m_callback));
	}
}
}