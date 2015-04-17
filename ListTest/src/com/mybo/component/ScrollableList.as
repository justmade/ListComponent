package  com.mybo.component
{
	import com.mybo.gui.model.GameData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	public class ScrollableList extends Sprite
	{
		
		/**用可滚动的容器来承载数据项*/ 
		protected var container:ScrollableContainer;
		
		protected var _layout:ILayout; 
		
		/**项目渲染器类*/ 
		public var itemRenderer:Class;
		
		private var itemGap:Number;
		
		protected var useVirtualScroll:Boolean = false;
		
		/**虚拟Item的数组*/
		private var virtualItemArr:Array ;
		
		private var _horizontalScrollEnabled:Boolean=false;
		
		private var _verticalScrollEnabled:Boolean=true;
		
		public var needUpDateitems:Vector.<MyItemRender> ;
		
		private var _fixDistance:Boolean = true;
		
		/**
		 *特殊item的位移 
		 */
		public var itemDisplacement:Number = 0;
		
		
		public function ScrollableList(itemRenderer:Class,itemGap:Number=0)
		{
			this.itemRenderer = itemRenderer; 
			this.itemGap = itemGap; 
			createChildren(); 
		}
		
		
		protected function createChildren():void 
		{ 
			container = new ScrollableContainer(); 
			super.addChild(container);  
		}
		
		private function initList():void{
			var itemRender:MyItemRender = new itemRenderer();
			itemRender.data = virtualItemArr[0].data;
			var itemHeight:Number = itemRender.height;
			var itemWidth:Number  = itemRender.width ; 
		
			needUpDateitems = new Vector.<MyItemRender>();
			layout.layoutChildren(needUpDateitems,virtualItemArr,itemWidth,itemHeight,width,height,container,itemRenderer);
			container.setScrllControlerData(needUpDateitems,virtualItemArr,itemWidth,itemHeight,itemGap);
			
			
		}
		
		public function destroy():void{
			if(container){
				container.destroy();
//				container = null;
			}
			clearVirtualItemArr();
			clearItemArr();
		}
		
		/**
		 * 清理virtualItemArr数据
		 * 
		 */
		private function clearVirtualItemArr():void{
			if(virtualItemArr){
				trace("clearVirtualItemArr",virtualItemArr);
				for(var i:int = virtualItemArr.length -1 ; i >= 0 ; i --){
					virtualItemArr[i] = null;
					virtualItemArr.splice(i,1);
				}
//				virtualItemArr= null;
			}
		}
		
		private function clearItemArr():void{
			trace("destroyclearItemArr")
			if(needUpDateitems){
				for(var i:int = needUpDateitems.length -1 ; i >= 0 ; i --){
					needUpDateitems[i] = null;
					needUpDateitems.splice(i,1);
				}
//				needUpDateitems= null;
			}
		}
		
		/**@private*/
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
			var itemHeight:Number = (itemRenderer as Object).itemHeight; 
			for (var i:int = 0; i < dataProvider.length; i++) 
			{ 
				if(itemDisplacement !=0)dataProvider[i].itemDisplacement =  itemDisplacement;
				var virtualItem:VirtualItemRenderer = new VirtualItemRenderer(dataProvider[i]); 
				virtualItem.y = i*(itemHeight+itemGap); 
				virtualItemArr.push(virtualItem); 
			} 
			createItemRenderer();
		}
		
		public function upDateDataProvider(value:Array):void{
//			clearVirtualItemArr();
			virtualItemArr = new Array(); 
			for (var i:int = 0; i < value.length; i++) 
			{ 
				var virtualItem:VirtualItemRenderer = new VirtualItemRenderer(value[i]); 
				virtualItemArr.push(virtualItem); 
			}
			container.upDateDataProvider(virtualItemArr);
		}
		
		/**
		 * 在开启虚拟滚动时，由这个方法计算虚拟的内容高度
		 * @return 
		 */        
		protected function measureFunction():Object
		{
			var cotentHeight:Number = _dataProvider.length*((itemRenderer as Object).itemHeight+itemGap);
			return {width:width,height:cotentHeight};
		}
		
		
		/**
		 * 根据数据源，创建列表项
		 */        
		protected function createItemRenderer():void
		{
			initList();
		}
		
		/** 
		 * 当数据列表项被点击，设置selectedItem 
		 * @param event 
		 */ 
		protected function itemClickHanlder(event:Event):void 
		{ 
			setTimeout(validateItemClick,200,event.currentTarget); 
		} 
		
		/** 
		 * 因为移动设备的屏幕，MouseDown和MouseMove经常同时触发，造成判断错误，所以需要延迟对于点击事件的判断 
		 * inScrollState是个布尔值，标记当前列表是否处于滚动状态，如何用户点击了某一项，同时触发了滚动，则“选择”这个操作是无效的，这样来避免事件的冲突 
		 * @param child 
		 */ 
		protected function validateItemClick(child:Object):void 
		{ 
			if( selectedItem == child.data) 
				return; 
			selectedItem = child.data; 
			//			var itemChangeEvent:DataChangeEvent = new DataChangeEvent(DataChangeEvent.ITEM_CHANGE); 
			//			itemChangeEvent.selectedItem = _selectedItem; 
			//			dispatchEvent(itemChangeEvent); 
		}
		
		/**@private*/
		private var _selectedItem:Object;
		/**当前选中项*/
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void
		{
			if(_selectedItem == value)
				return;
			_selectedItem = value;
			var currentItemNum:Number = container.numChildren;
			for (var i:int = 0; i < currentItemNum; i++) 
			{
				var child:IItemRenderer = container.getChildAt(i) as IItemRenderer;
				if(child.data == _selectedItem)
					child.selected = true;
				else
					child.selected = false;
			}
		}
		

		
		public function setStyle(styleName:String , value:*):void{
			container.setStyle(styleName,value);
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

		/**布局类*/
		public function get layout():ILayout
		{
			return _layout;
		}

		/**
		 * @private
		 */
		public function set layout(value:ILayout):void
		{
			_layout = value;
		}

		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}

		public function set horizontalScrollEnabled(value:Boolean):void
		{
			_horizontalScrollEnabled = value;
			container.horizontalScrollEnabled = value;
		}

		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}

		public function set verticalScrollEnabled(value:Boolean):void
		{
			_verticalScrollEnabled = value;
			container.verticalScrollEnabled = value;
		}

		/**固定距离*/
		public function get fixDistance():Boolean
		{
			return _fixDistance;
		}

		/**
		 * @private
		 */
		public function set fixDistance(value:Boolean):void
		{
			_fixDistance = value;
			container.fixDistance = value;
		}


	}
}