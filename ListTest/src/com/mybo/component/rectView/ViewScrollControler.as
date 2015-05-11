package com.mybo.component.rectView
{
	import com.mybo.Main;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import gs.TweenMax;
	
	public class ViewScrollControler
	{
		
		private var _horizontalScrollEnabled:Boolean=true; 
		
		private var _verticalScrollEnabled:Boolean=false; 
		/**实际内容宽度*/ 
		public var contentWidth:Number = 0; 
		/**实际内容高度*/ 
		public var contentHeight:Number = 0; 
		/**组件可用宽度*/ 
		public var parentWidth:Number = 0; 
		/**组件可用高度*/ 
		public var parentHeight:Number = 0;
		
		/**包含内容的容器*/
		private var container:Sprite;
		/**容器的父级，即ScrollableContainer*/
		private var parent:Sprite;
		
		/**X轴速度*/
		private var speedX:int=0;
		/**Y轴速度*/
		private var speedY:int=0;
		/**手指的水平方向，即内容的水平滚动方向*/
		private var directionX:String="left"; //or right,手指方向
		/**手指的垂直方向，即内容的垂直滚动方向*/
		private var directionY:String="up"; //or down,手指方向
		
		/**光标坐标点距离起点的位移X*/
		private var currentMouseOffsetX:Number=0;
		/**光标坐标点距离起点的位移Y*/
		private var currentMouseOffsetY:Number=0;
		/**启动拖放时的坐标点X*/
		private var startX:Number;
		/**启动拖放时的坐标点Y*/
		private var startY:Number;
		/**结束拖放时的坐标点X*/
		private var endX:Number;
		/**结束拖放时的坐标点Y*/
		private var endY:Number;
		/**启动拖放时的时间*/
		private var startTime:Number;
		/**结束拖放时的时间*/
		private var endTime:Number;
		
		private var fllowMouse:Boolean;
		
		private var tween:TweenMax;
		
		
		public function ViewScrollControler(contentGroup:Sprite, parent:Sprite)
		{
			
			this.container=contentGroup;
			this.parent=parent;
			initContainer();
		}
		
		private function initContainer():void
		{
			container.addEventListener(Event.ADDED_TO_STAGE,addListeners);
			//			container.addEventListener(Event.REMOVED_FROM_STAGE,clear);
		}
		/**
		 * 当容器添加到显示列表，则注册事件侦听
		 * @param event
		 */        
		protected function addListeners(event:Event):void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE,addListeners);
			container.addEventListener(Main.downEvent, containerMouseHandler);
		}
		
		
		private function containerMouseHandler(event:Event):void{
			if (event.type == Main.downEvent)
			{
				startX=parent.mouseX;
				startY=parent.mouseY;
				startTime=getTimer();
				currentMouseOffsetX=parent.mouseX - container.x;
				currentMouseOffsetY=parent.mouseY - container.y;
				fllowMouse=true;
				
				Main.sceneManager.stage.addEventListener(Main.upEvent,containerMouseHandler);
				//				Main.sceneManager.stage.addEventListener(Main.moveEvent,containerMouseHandler);
				container.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
				
				//			else if(event.type == Main.moveEvent){
				//			}
				
			else if (event.type == Main.upEvent)
			{
				endX=parent.mouseX;
				endY=parent.mouseY;
				endTime=getTimer();
				var timeOffset:Number=endTime - startTime;
				directionX=(endX <= startX) ? "left" : "right";
				directionY=(endY <= startY) ? "up" : "down";
				speedX=(endX - startX) / (timeOffset / 20);
				speedY=(endY - startY) / (timeOffset / 20);
				currentMouseOffsetX=0;
				currentMouseOffsetY=0;
				fllowMouse=false;
				checkXRange();
				checkYRange();
				Main.sceneManager.stage.removeEventListener(Main.upEvent,containerMouseHandler);
			}
		}
		
		public function toTop(_per:Number):void{
			var toX:int = _per
			tween = TweenMax.to(container,0.6,{x:toX});
		}
		
		private function enterFrameHandler(event:Event):void
		{
			if(!horizontalScrollEnabled && !verticalScrollEnabled){
				return;
			}
			if (fllowMouse)
			{
				if(horizontalScrollEnabled)
					container.x=parent.mouseX - currentMouseOffsetX;
				if(verticalScrollEnabled)
					container.y=parent.mouseY - currentMouseOffsetY;
				checkXRange();
				checkYRange();
			//	scrollBarRef.update(container.x,container.y);
				return;
			}
		
			if (Math.abs(speedX) < 4)
				speedX=0;
			if (Math.abs(speedY) < 4)
				speedY=0;
			if(speedX == 0 && speedY == 0)
			{
				//scrollBarRef.clear();
				container.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
				return;
			}
			container.x+=speedX;
			container.y+=speedY;
			checkXRange();
			checkYRange();
			if (directionX == "left")
				speedX+=1;
			else
				speedX-=1;
			if (directionY == "up")
				speedY+=1;
			else
				speedY-=1;
			//scrollBarRef.update(container.x,container.y);
		}
		/**检查X值，确定不超出允许范围*/
		private function checkXRange():Boolean
		{
			if(contentWidth <= parentWidth)
			{
				speedX=0;
				container.x=0;
				return true;
			}
			if (container.x + contentWidth <= parentWidth)
			{
				speedX=0;
				container.x=parentWidth - contentWidth;
				return true; 
			}
			if (container.x >= 0)
			{
				speedX=0;
				container.x=0;
				return true;
			}
			return false;
		}
		
		/**检查Y值，确定不超出允许范围*/
		private function checkYRange():Boolean
		{
			if(contentHeight <= parentHeight)
			{
				speedY=0;
				container.y=0;
				return true;
			}
			if (container.y + contentHeight <= parentHeight)
			{
				speedY=0;
				container.y=parentHeight - contentHeight;
				return true;
			}
			if (container.y >= 0)
			{
				speedY=0;
				container.y=0;
				return true;
			}
			return false ;
		}
		
		public function destroy():void{
			if(container){
				if(tween){
					tween.clear();
					tween = null;
				}
				if(container.hasEventListener(Event.ENTER_FRAME)){
					container.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
					
				}
				Main.sceneManager.stage.removeEventListener(Main.upEvent,containerMouseHandler);
				container.removeEventListener(Main.downEvent, containerMouseHandler);
			}
		}

		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}

		public function set horizontalScrollEnabled(value:Boolean):void
		{
			_horizontalScrollEnabled = value;
		}

		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}

		public function set verticalScrollEnabled(value:Boolean):void
		{
			_verticalScrollEnabled = value;
		}

		
	}
}