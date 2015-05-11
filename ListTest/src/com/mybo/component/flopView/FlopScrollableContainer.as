package com.mybo.component.flopView
{
	import com.mybo.component.list.MyItemRender;
	import com.mybo.component.list.ScrollableContainer;
	
	public class FlopScrollableContainer extends ScrollableContainer
	{
		
		private var flopControler:FlopControler;
		public function FlopScrollableContainer()
		{
			super();
		}
		
		override protected function createControler():void
		{
			flopControler = new FlopControler(contentGroup,this);
		}
		
		override protected function setSize():void
		{
//			flopControler.parentWidth = width; 
//			flopControler.parentHeight = height; 
//			flopControler.contentWidth = contentWidth; 
//			flopControler.contentHeight = contentHeight;
		}
		
		public function setFlopControlerData(needUpDateItems:Vector.<MyItemRender> , virtuallItems:Array):void{
			flopControler.needUpDateItems = needUpDateItems;
			flopControler.virtualDataProvider = virtuallItems;
				
			
		}
		
		
		
	}
}