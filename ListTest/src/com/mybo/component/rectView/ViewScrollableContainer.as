package com.mybo.component.rectView
{
	import com.mybo.component.list.ScrollControler;
	import com.mybo.component.list.ScrollableContainer;
	import com.mybo.gui.FalseData;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class ViewScrollableContainer extends ScrollableContainer
	{
		
		private var viewScrollControler:ViewScrollControler
		
		public function ViewScrollableContainer()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
//			maskShape=new Shape(); 
//			super.addChild(maskShape); 
//			contentGroup.mask=maskShape
		}
		
		
		override protected function createControler():void
		{
			viewScrollControler = new ViewScrollControler(contentGroup,this);
		}
		
		public function scrollToTop(_per:Number):void{
			viewScrollControler.toTop(_per);
			
		}
		
		override public function get horizontalScrollEnabled():Boolean
		{
			// TODO Auto Generated method stub
			return super.horizontalScrollEnabled;
		}
		
		override public function set horizontalScrollEnabled(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.horizontalScrollEnabled = value;
			viewScrollControler.horizontalScrollEnabled = value;
		
		}
		
		override public function get verticalScrollEnabled():Boolean
		{
			// TODO Auto Generated method stub
			return super.verticalScrollEnabled;
		}
		
		override public function set verticalScrollEnabled(value:Boolean):void
		{
			// TODO Auto Generated method stub
			super.verticalScrollEnabled = value;
			viewScrollControler.verticalScrollEnabled = value;
		}
		
		
		
		override public function destroy():void
		{
			viewScrollControler.destroy();
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, updateDisplayList); 
			}
			for(var i:int = this.numChildren -1 ; i >=0 ; i --){
				this.removeChildAt(i);
			}
			
		}
		
		
		override protected function setSize():void
		{
			viewScrollControler.parentWidth = width; 
			viewScrollControler.parentHeight = height; 
			viewScrollControler.contentWidth = contentWidth; 
			viewScrollControler.contentHeight = contentHeight;
		}
		
		/**下面对于尺寸的定义，会被容器更改默认行为*/
		
		/**@private*/
		override public function get width():Number
		{
			return containerWidth;
		}
		
		/**@private*/
		override public function set width(value:Number):void
		{
			if (containerWidth == value)
				return;
			containerWidth=value;
			needUpdate=true;
			setSize();
		}
		
		/**@private*/
		override public function get height():Number
		{
			return containerHeight;
		}
		
		/**@private*/
		override public function set height(value:Number):void
		{
			if (containerHeight == value)
				return;
			containerHeight=value;
			needUpdate=true;
			setSize();
		}
		
	}
}