package com.mybo.component.flopView
{
	import com.mybo.component.list.MyItemRender;
	import com.mybo.component.list.VirtualItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class FlopView extends Sprite
	{
		
		private var itemRenderClass:Class;
		
		protected var container:FlopScrollableContainer;
		
		/**虚拟Item的数组*/
		private var virtualItemArr:Array ;
		
		private var needUpDateitems:Vector.<MyItemRender> ;
		
		public function FlopView(itemRender:Class)
		{
			super();
			
			this.itemRenderClass = itemRender;
			createChildren();
		}
		
		
		private function createChildren():void{
			container = new FlopScrollableContainer();
			super.addChild(container);
			needUpDateitems = new Vector.<MyItemRender>();
		}
		
	
		private var _dataProvider:Array;
		
		
		/**数据源*/
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			
			virtualItemArr = new Array(); 
			for (var i:int = 0; i < dataProvider.length; i++) 
			{ 
				var virtualItem:VirtualItemRenderer = new VirtualItemRenderer(dataProvider[i]); 
				virtualItemArr.push(virtualItem); 
			} 
			initList();
		}
		
		private function initList():void{
			if(virtualItemArr.length > 1){
				for( var i:int = 0 ; i < 2 ; i ++){
					var item:MyItemRender = new itemRenderClass();
					item.data = virtualItemArr[i]
					needUpDateitems.push(item);
				}
					container.addChild(needUpDateitems[0]);
			}
			else if(virtualItemArr.length == 1){
				item = new itemRenderClass();
				item.data = virtualItemArr[0];
				container.addChild(item);
			}
			container.setFlopControlerData(needUpDateitems,virtualItemArr);
		}
		/**@private*/
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return throwError();
		}
		/**@private*/
		override public function removeChildAt(index:int):DisplayObject
		{
			return throwError();
		}
		/**抛出错误*/
		private function throwError():*
		{
			throw new Error("List不是容器，禁止操作此方法");
			return null;
		}
		
		/**@private*/
		override public function get width():Number
		{
			return container.width;
		}
		override public function set width(value:Number):void
		{
			if (container.width == value)
				return;
			container.width = value;
		}
		/**@private*/
		override public function get height():Number
		{
			return container.height;
		}
		override public function set height(value:Number):void
		{
			if (container.height == value)
				return;
			container.height=value;
		}

		
		
	}
}