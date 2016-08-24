package events
{
	import d2.axime.events.NTouchEvent;

	/**
	 * 拖拽事件.
	 */
public class DragEvent extends NTouchEvent {
	
	/**
	 * Constructor.
	 */
	public function DragEvent( type:String ) {
		super(type);
	}
	
	/** 開始拖動. */
	public static const START_DRAG : String     =  "startDrag";
	/** 正在拖動. */
	public static const DRAGGING : String       =  "dragging";
	/** 停止拖動. */
	public static const STOP_DRAG : String      =  "stopDrag";
}
}