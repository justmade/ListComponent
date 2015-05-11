package com.mybo.component.list
{
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ScrollableContainer extends Sprite
	{
		/**@private*/
		private var _horizontalScrollEnabled:Boolean=false;
		/**@private*/
		private var _verticalScrollEnabled:Boolean=false;
		/**添加到内部的显示对象，实际上添加到这个容器中*/ 
		protected var contentGroup:Sprite;
		/**遮罩*/ 
		protected var maskShape:Shape;
		
		/**容器约束宽度*/ 
		protected var containerWidth:Number=0; 
		/**容器约束高度*/ 
		protected var containerHeight:Number=0; 
		/**子元件宽度*/ 
		protected var contentWidth:Number=0; 
		/**子元件高度*/ 
		protected var contentHeight:Number=0;
		/**样式对象*/
		private var style:Object;
		/**需要更新*/
		private var _needUpdate:Boolean ;
		
		private var scrollControler:ScrollControler ;
		
		private var _fixDistance:Boolean = true;
		
		public function ScrollableContainer()
		{
			super();
			createChildren();
			createControler();
		}
		
		protected function createControler():void{
			scrollControler = new ScrollControler(contentGroup,this);
			
		}
		
		public function setScrllControlerData(needUpDateItems:Vector.<MyItemRender> , virtuallItems:Array , itemWidht:Number , itemHeight:Number,itemGap:Number = 0):void{
			scrollControler.needUpDateItems = needUpDateItems;
			trace("setScrllControlerDataneedUpDateItems",needUpDateItems.length)
			scrollControler.virtualDataProvider = virtuallItems;
			scrollControler.itemWidth = itemWidht ;
			scrollControler.itemHeight = itemHeight ;
			scrollControler.gap = itemGap ;
			scrollControler.horizontalScrollEnabled = horizontalScrollEnabled;
			scrollControler.verticalScrollEnabled = verticalScrollEnabled;
			scrollControler.fixDistance = fixDistance;
		}
		
		public function upDateDataProvider(value:Array):void{
			scrollControler.upDateDataProvider(value);
		}
		
		
		
		/**是否需要更新显示列表*/ 
		public function get needUpdate():Boolean 
		{ 
			return _needUpdate; 
		} 
		public function set needUpdate(value:Boolean):void 
		{ 
			_needUpdate=value; 
//			if (_needUpdate) 
//			{ 
//				if (!hasEventListener(Event.ENTER_FRAME)) 
//					addEventListener(Event.ENTER_FRAME, updateDisplayList); 
////				if (stage != null) 
////					stage.invalidate(); 
//			} 
//			else 
//			{ 
//				removeEventListener(Event.ENTER_FRAME, updateDisplayList); 
//			} 
		}
		
		protected function updateDisplayList(e:Event = null):void 
		{ 
//			if (stage == null || width <= 0 || height <= 0) 
//				return; 
			//background 
//			drawBackground(); 
			//scroller 
//			contentGroup.x=0; 
//			contentGroup.y=0; 
			
			
		}
		
		protected function setSize():void{
			scrollControler.parentWidth = width; 
			scrollControler.parentHeight = height; 
			scrollControler.contentWidth = contentWidth; 
			scrollControler.contentHeight = contentHeight;
		}
		
		public function validateNow():void 
		{ 
			measure(); 
			updateDisplayList(); 
		}
		
		/** 
		 * 获取样式属性的值 
		 * @param styleName 
		 * @return 
		 */ 
		public function getStyle(styleName:String):* 
		{ 
			return style[styleName]; 
		} 
		
		/** 
		 * 设置样式，目前只支持borderColor,bgColor,bgAlpha 
		 * @param styleName 
		 * @param value 
		 */ 
		public function setStyle(styleName:String, value:*):void 
		{ 
			if (style[styleName] == value) 
				return; 
			style[styleName]=value; 
//			needUpdate=true; 
		}
		
		/** 
		 * 计算子元素的尺寸 
		 */ 
		protected function measure():void 
		{ 			
			var startWidth:Number=0; 
			var startHeight:Number=0; 
			for (var i:int=0; i < contentGroup.numChildren; i++) 
			{ 
				var child:DisplayObject = contentGroup.getChildAt(i); 
				var childPoint:Point = new Point(child.x + child.width, child.y + child.height); 
				if (childPoint.x > startWidth) 
					startWidth=childPoint.x; 
				if (childPoint.y > startHeight) 
					startHeight=childPoint.y; 
			} 
			
			contentWidth=startWidth; 
			contentHeight=startHeight; 
			
			
//			if(_layout != null) 
//				_layout.layoutChildren(contentGroup,containerWidth,containerHeight);
			
			
		}
		
		/** 
		 * 创建内部所需的对象 
		 */ 
		protected function createChildren():void 
		{ 
			contentGroup=new Sprite(); 
			super.addChild(contentGroup); 
			style={bgColor: 0xFFFFFF, bgAlpha: 1}; 
		}
		
		/** 
		 * 绘制背景和边框 
		 */ 
		protected function drawBackground():void 
		{ 
			var g:Graphics=this.graphics; 
			
//			g.clear(); 
//			if (style["borderColor"] != null) 
//			{ 
//				g.lineStyle(1, style["borderColor"], 1); 
//			} 
//			g.beginFill(style["bgColor"], style["bgAlpha"]); 
//			g.drawRect(0, 0, width, height); 
//			g.endFill(); 
			//draw mask 
			g=maskShape.graphics; 
			g.clear(); 
			g.beginFill(0x000000, 1); 
			g.drawRect(1, 1, width - 2, height - 2); 
			g.endFill(); 
		}
		
		/**
		 *销毁 
		 * 
		 */
		public function destroy():void{
			scrollControler.destroy();
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, updateDisplayList); 
			}
			for(var i:int = this.numChildren -1 ; i >=0 ; i --){
				this.removeChildAt(i);
			}
//			scrollControler = null;
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
//			needUpdate=true;
			contentGroup.scrollRect = new Rectangle(0,0,value,height);
			setSize();
			trace("contentGroup.scrollRect",contentGroup.scrollRect)
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
//			needUpdate=true;
			contentGroup.scrollRect = new Rectangle(0,0,width,value);
			setSize();
			trace("contentGroup.scrollRect",contentGroup.scrollRect)
		}
		
		/**下面override的这些方法，都是为了更正contentGroup可能导致的错误行为*/
		
		/**@private*/
		override public function addChild(child:DisplayObject):DisplayObject
		{
			contentGroup.addChild(child);
			measure();
			return child;
		}
		
		/**@private*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			contentGroup.addChildAt(child, index);
			measure();
			return child;
		}
		
		/**@private*/
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			contentGroup.removeChild(child);
			measure();
			return child;
		}
		
		/**@private*/
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject=contentGroup.removeChildAt(index);
			measure();
			return child;
		}
		
		/**@private*/
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			contentGroup.setChildIndex(child, index);
		}
		
		/**@private*/
		override public function getChildAt(index:int):DisplayObject
		{
			return contentGroup.getChildAt(index);
		}
		
		/**@private*/
		override public function getChildByName(name:String):DisplayObject
		{
			return contentGroup.getChildByName(name);
		}
		
		/**@private*/
		override public function getChildIndex(child:DisplayObject):int
		{
			return contentGroup.getChildIndex(child);
		}
		
		/**@private*/
		override public function get numChildren():int
		{
			return contentGroup.numChildren;
		}
		
		/**水平可滚动*/
		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}
		public function set horizontalScrollEnabled(value:Boolean):void
		{
			_horizontalScrollEnabled = value;
		}
		/**垂直可滚动*/
		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}
		public function set verticalScrollEnabled(value:Boolean):void
		{
			_verticalScrollEnabled = value;
		}
		
		
		
		/**@private*/
		private var _layout:ILayout;
		/**布局类实例，控制子元件的排列方式*/
		public function get layout():ILayout
		{
			return _layout;
		}
		public function set layout(value:ILayout):void
		{
			if(_layout == value)
				return;
			_layout = value;
			needUpdate = true;
		}

		/**固定长度*/
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
		}

	}
}