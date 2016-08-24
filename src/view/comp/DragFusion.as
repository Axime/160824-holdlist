package view.comp
{
		import flash.geom.Point;
		import flash.geom.Rectangle;
		
		import d2.axime.display.FusionAA;
		import d2.axime.events.AEvent;
		import d2.axime.logging.LogMachine;
		import d2.axime.utils.support.ns_axime;
		import d2.axime.window.Touch;
		
		import events.DragEvent;
		
		use namespace ns_axime;
		
		/** 开始拖拽时触发. */
		[Event(name = "startDrag", type = "d2.axime.events.DragEvent")]
		
		/** 正在拖拽进行中触发. */
		[Event(name = "dragging",  type = "d2.axime.events.DragEvent")]
		
		/** 拖拽结束时触发. */
		[Event(name = "stopDrag",  type = "d2.axime.events.DragEvent")]
		
	/**
	 * 拖拽式容器AA.
	 */
public class DragFusion extends FusionAA {
	
	/** @private */
	ns_axime static var g_dragEvt:DragEvent = new DragEvent(null);
	
	/** @private */
	ns_axime var m_isDragHappened:Boolean;
	
	/**
	 * 获取当前拖拽触摸.
	 */
	public function getDraggingTouch() : Touch {
		return m_touch;
	}
	
	/**
	 * 开始拖拽.
	 * 
	 * @param	touch
	 * @param	bounds	拖拽范围，以节点的中心点位置计算，坐标系相对于上一级节点.
	 * @param	offsetX
	 * @param	offsetY
	 * @param	isLockNodeOrigin	是否锁定节点原点.
	 */
	public function startDrag( touch:Touch, bounds:Rectangle = null, offsetX:Number = 0, offsetY:Number = 0, isLockNodeOrigin:Boolean = false ) : void {
		var global:Point;
		var localX:Number;
		var localY:Number;
		
		if (!m_view) {
			LogMachine.g_instance.error(this, "startDrag", "未加入到Root");
		}
		if (m_touch) {
			LogMachine.g_instance.error(this, "doReadyToDrag", "It has been dragging");
		}
		m_touch        =  touch;
		m_bounds       =  bounds;
		this.setOffset(offsetX, offsetY, isLockNodeOrigin);
		m_touch.addEventListener(AEvent.CHANGE,   ____onDragging,     2200);
		m_touch.addEventListener(AEvent.COMPLETE, ____onDragComplete, 2200);
	}
	
	public function setOffset( offsetX:Number, offsetY:Number, isLockNodeOrigin:Boolean = false ) : void {
		if(m_touch){
			g_cachedPoint_A  =  m_parent.globalToLocal(m_touch.rootX, m_touch.rootY, g_cachedPoint_A);
			if (isLockNodeOrigin) {
				m_draggingOffsetX  =  -offsetX;
				m_draggingOffsetY  =  -offsetY;
				this.x = g_cachedPoint_A.x + offsetX;
				this.y = g_cachedPoint_A.y + offsetY;
			}
			else {
				m_draggingOffsetX  =  g_cachedPoint_A.x - this.x - offsetX;
				m_draggingOffsetY  =  g_cachedPoint_A.y - this.y - offsetY;
				this.x += offsetX;
				this.y += offsetY;
			}
		}
	}
	
	/**
	 * 停止拖拽.
	 * 
	 * @param	fireEvent
	 */
	public function stopDrag( fireEvent:Boolean = false ) : void {
		if (m_touch) {
			m_touch.removeEventListener(AEvent.CHANGE,   ____onDragging);
			m_touch.removeEventListener(AEvent.COMPLETE, ____onDragComplete);
			m_touch = null;
			if (m_isDragHappened) {
				m_isDragHappened = false;
				if(fireEvent) {
					g_dragEvt.m_touch  =  m_touch;
					g_dragEvt.m_type   =  DragEvent.STOP_DRAG;
					this.dispatchEvent(g_dragEvt);
				}
			}
		}
	}
	
	
	
	/** @private */
	ns_axime var m_touch:Touch;
	/** @private */
	ns_axime var m_bounds:Rectangle;
	/** @private */
	ns_axime var m_draggingOffsetX:Number;
	/** @private */
	ns_axime var m_draggingOffsetY:Number;
	
	
	
	/** @private */
	override ns_axime function doDispose() : void {
		this.stopDrag();
		super.doDispose();
	}
	
	/** @private */
	ns_axime function ____onDragging( e:AEvent ) : void {
		var localX:Number;
		var localY:Number;
		var isInBounds:Boolean;
		
		g_cachedPoint_A  =  m_parent.globalToLocal(m_touch.rootX, m_touch.rootY, g_cachedPoint_A);
		localX         =  g_cachedPoint_A.x - m_draggingOffsetX;
		localY         =  g_cachedPoint_A.y - m_draggingOffsetY;
		isInBounds = !m_bounds || m_bounds.contains(localX, localY);
		if (isInBounds) {
			this.x = localX;
			this.y = localY;
		}
		else {
			if (localX < m_bounds.x) {
				localX = m_bounds.x;
			}
			else if (localX > m_bounds.right) {
				localX = m_bounds.right;
			}
			if (localY < m_bounds.y) {
				localY = m_bounds.y;
			}
			else if (localY > m_bounds.bottom) {
				localY = m_bounds.bottom;
			}
			this.x = localX;
			this.y = localY;
		}
		g_dragEvt.m_touch = e.m_eTarget as Touch;
		if (!m_isDragHappened) {
			m_isDragHappened  =  true;
			g_dragEvt.m_type  =  DragEvent.START_DRAG;
			this.dispatchEvent(g_dragEvt);
		}
		g_dragEvt.m_type = DragEvent.DRAGGING;
		this.dispatchEvent(g_dragEvt);
	}
	
	/** @private */
	ns_axime function ____onDragComplete( e:AEvent ) : void {
		m_touch = null;
		if(m_isDragHappened) {
			m_isDragHappened    =  false;
			g_dragEvt.m_touch   =  e.m_eTarget as Touch;
			g_dragEvt.m_type    =  DragEvent.STOP_DRAG;
			this.dispatchEvent(g_dragEvt);
		}
	}
}
}
