package com.mybo.component
{
	
	import com.mybo.Main;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import gs.easing.Circ;
	
	public class ScrollControler
	{
		
		private var _horizontalScrollEnabled:Boolean=false; 
		
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
		
		private var fllowMouse:Boolean ;
		
		private var _virtualDataProvider:Array;
		
		private var _needUpDateItems:Vector.<MyItemRender>;
		
		public var itemHeight:Number ;
		
		public var itemWidth:Number ;		
		//显示单元首位的下标
		private var headIndex:int;
		//显示单元末尾的下标
		private var tailIndex:int ; 
		//鼠标最后经过位置
		private var mousePosVector:Vector.<Point> = new Vector.<Point>();
		
		private var _speed:Number;
		
		private var moveState:String;
		/**单元间距*/
		public var gap:Number ;
		//tween动画当前帧数
		private var animationFrames:int = 0 ;
		//鼠标释放时起始速度
		private var startSpeed:Number ;
		//加速度，速度变化量
		private var changeValue:Number ;
		//缓动时间
		private var duration:int ;
		//缓动是否完成
		private var tweenComplete:Boolean = true ;
		//起始速度
		private var lastSpeed:Number ;
		//缓动完成
		private var tweenCompleteFunction:Function ;
		//反弹的距离
		private var boundDistace:Number ;
		//是否已经反弹
		private var rebound:Boolean = false;
		//利用加速度得出的距离
		private var changeS:Number;
		//固定距离
		public var fixDistance:Boolean;
		
		//用于区分横屏还是竖屏
		private var firstItemsPostion:Number ;
		private var lastItemPostion:Number ;
		private var firstItemSize:Number;
		private var lastItemSize:Number;
		private var parentSize:Number;
		
		
		
		
		
		public function ScrollControler(contentGroup:Sprite, parent:Sprite)
		{
			this.container=contentGroup;
			this.parent=parent;
			initContainer();
			resetMouseVector();
		}
		
		
		/**单元数据*/
		public function get virtualDataProvider():Array
		{
			return _virtualDataProvider;
		}
		
		/**
		 * @private
		 */
		public function set virtualDataProvider(value:Array):void
		{
			_virtualDataProvider = value;
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
			container.addEventListener(Main.downEvent, containerMouseHandler);
			//			container.stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveHandler);
		}
		
		public function upDateDataProvider(value:Array):void{
			
			if(virtualDataProvider){
				for( var i:int = virtualDataProvider.length -1 ; i >= 0 ; i --){
					virtualDataProvider.splice(i,1);
					virtualDataProvider[i] = null;
				}
				virtualDataProvider = null
			}
			
			virtualDataProvider = value;
			updateListItem();
		}
		
		private function updateListItem():void{
			for(var i:int = headIndex ; i < (tailIndex - headIndex) ; i++ ){
				needUpDateItems[i - headIndex].data = virtualDataProvider[i].data;
			}
		}
		
		
		private function containerMouseHandler(event:Event):void
		{
			if (event.type == Main.downEvent)
			{
				tweenHasComplete();
				startX=parent.mouseX;
				startY=parent.mouseY;
				startTime=getTimer();
				currentMouseOffsetX=parent.mouseX - container.x;
				currentMouseOffsetY=parent.mouseY - container.y;
				fllowMouse=true;
				
				
				
				Main.sceneManager.stage.addEventListener(Main.upEvent,containerMouseHandler);
				Main.sceneManager.stage.addEventListener(Main.moveEvent,containerMouseHandler);
			}
				
			else if(event.type == Main.moveEvent){
				recordMousePos(parent.mouseX , parent.mouseY);
				speed = horizontalScrollEnabled?parent.mouseX - startX:parent.mouseY - startY ;
				if(speed > 0){
					moveState = "DOWN"
				}else{
					moveState = "UP";
				}
				changeMoveSpeed();
				startY = parent.mouseY;
				startX = parent.mouseX;
				listMove();
			}
				
			else if (event.type == Main.upEvent)
			{
				Main.sceneManager.stage.removeEventListener(Main.upEvent,containerMouseHandler);
				Main.sceneManager.stage.removeEventListener(Main.moveEvent,containerMouseHandler);
				container.addEventListener(Main.downEvent, containerMouseHandler);
				
				
				if(verticalScrollEnabled){
					var l:int = mousePosVector.length - 1 ;
					var m:int = Math.max(mousePosVector.length - 2,0);
					
					var p2p1:Number = int((mousePosVector[l].y - mousePosVector[m].y) * 100)/100;
					//					var p1p0:Number = int((mousePosVector[1].y - mousePosVector[0].y) * 100)/100;
					//					var p2p0:Number = int((mousePosVector[2].y - mousePosVector[0].y) * 100)/100;	
				}else if(horizontalScrollEnabled){
					if(mousePosVector && mousePosVector.length>=2){
						p2p1 = int((mousePosVector[mousePosVector.length - 1 ].x - mousePosVector[mousePosVector.length - 2].x) * 100)/100;
					}
					//					p1p0 = int((mousePosVector[1].x - mousePosVector[0].x) * 100)/100;
					//					p2p0 = int((mousePosVector[2].x - mousePosVector[0].x) * 100)/100;	
				}
				
				
				
				var s:Number = Math.max(Math.min(20 , p2p1),-20);
				var v:Number = s * -1.5 ;
				if(Math.abs(v) - Math.abs(s) >0){
					v = -s;
				}
				var d:Number = Math.abs(v / 7 * 30);
				getMoveValue(s/5,d);
				//			trace("startSpeed:",startSpeed,changeValue,duration)
				startTween();
			}
		}
		
		/**
		 *移动过程中，如果已经需要反弹则先减速 
		 * 
		 */
		private function changeMoveSpeed():void{
			if(firstItemsPostion >=0){
				speed/=3;
			}else if(lastItemPostion + lastItemSize + gap <= parentSize){
				speed/=3;
			}
		}
		
		/**
		 *记录最后进过的3个位置 
		 * @param _mouseX
		 * @param _mouseY
		 * 
		 */
		private function recordMousePos(_mouseX:Number,_mouseY:Number):void{
			if(mousePosVector.length >= 3){
				mousePosVector.push(new Point(_mouseX , _mouseY));
				mousePosVector.shift();
			}else{
				mousePosVector.push(new Point(_mouseX , _mouseY));
			}
		}
		
		/**
		 *重置鼠标进过位置的数组 
		 * 
		 */
		private function resetMouseVector():void{
			for(var i:int = mousePosVector.length -1 ; i>=0 ; i--){
				mousePosVector[i] = null ;
				mousePosVector[i] = new Point(0,0);
			}
			
		}
		
		/**
		 * 
		 * @param a 加速度
		 * @param d 时间 帧数
		 * 
		 */
		private function getMoveValue(a:Number,d:int):void{
			//可以移动的距离
			var distance:Number = 0 ;
			if(moveState == "UP"){
				distance = (virtualDataProvider.length - tailIndex - 1) * itemHeight;
				if(lastItemPostion + lastItemSize > parentSize){
					distance += (lastItemPostion + lastItemSize - parentSize);
				}
				a = -Math.abs(a);
				trace("distance",distance)
			}
			else if(moveState == "DOWN"){
				distance = (headIndex) * itemHeight; 
				if(firstItemsPostion < 0 ){
					distance += Math.abs(firstItemsPostion);
				}
				a = Math.abs(a);
			}
			changeS = Math.ceil((a * a * d /2) *100)/100 * (a / Math.abs(a));
			if(firstItemsPostion  > 0 && (distance == 0||headIndex==0)){
				rebound = true ;
				boundDistace = firstItemsPostion ;
				setTweenParameters(0,0,0,3);
			}
			else if(lastItemPostion + lastItemSize < parentSize && (distance == 0||tailIndex == virtualDataProvider.length -1)){
				
				var dis:Number = parentSize < virtualDataProvider.length * lastItemSize ? parentSize : virtualDataProvider.length * (lastItemSize+gap);
				rebound = true ;
				boundDistace = dis - (lastItemPostion + lastItemSize);
				setTweenParameters(0,0,0,3);
			}
				
			else if(Math.abs(changeS) > distance){
				boundDistace = Math.min((Math.abs(changeS) - distance),30);
				rebound = true ;
				setTweenParameters(0,changeS,-changeS,d);
			}else{
				rebound = false
				setTweenParameters(0,changeS,-changeS,d);
			}
			
			
			
		}
		
		/**
		 *开始执行缓动 
		 * 
		 */
		private function startTween():void{
			if(!container.hasEventListener(Event.ENTER_FRAME))container.addEventListener(Event.ENTER_FRAME , onRender);
			tweenComplete = false ;
			//			rebound = false;
			
			
		}
		/**
		 *缓动方法，获取速度变量 
		 * 
		 */
		private function tween():void{
			if(animationFrames < duration){
				var a:Number = Circ.easeOut(animationFrames,startSpeed,changeValue,duration);
				speed = Math.ceil((lastSpeed - a) * 100)/100 ;
				var p:int = speed / Math.abs(speed);
				speed = p * Math.min(Math.abs(speed),firstItemSize);
				lastSpeed = a;
			}
			else {
				tweenCompleteFunction.call();
			}
		}
		
		/**
		 *设置tween的参数 
		 * @param a 当前帧
		 * @param s 起始速度
		 * @param c 变化量
		 * @param d 时间
		 * 
		 */
		private function setTweenParameters(a:int,s:Number,c:Number,d:int,onComplete:Function = null):void{
			animationFrames = a ;
			startSpeed = s;
			changeValue = c ;
			duration = d ;
			lastSpeed = s;
			if(onComplete == null){
				tweenCompleteFunction = tweenHasComplete ; 
			}else{
				tweenCompleteFunction = onComplete ;
			}
		}
		
		/**
		 *完成缓动 
		 * 
		 */
		private function tweenHasComplete():void{
			rebound = false ;
			animationFrames = 0 ;
			speed = 0 ;
			tweenComplete = true ;
			if(container.hasEventListener(Event.ENTER_FRAME)){
				container.removeEventListener(Event.ENTER_FRAME,onRender);
				resetMouseVector();
				listMove();
			}
		}
		
		/**
		 *帧监听 
		 * @param event
		 * 
		 */
		protected function onRender(event:Event):void
		{
			listMove();
			animationFrames ++ ;
			
		}
		
		/**
		 *列表移动 
		 * 
		 */
		private function listMove():void{
			if(tweenComplete == false)tween();
			if(horizontalScrollEnabled){
				for(var i:int = 0 ; i < needUpDateItems.length ; i++){
					needUpDateItems[i].x += speed;
				}
				
			}
			else if(verticalScrollEnabled){
				for(i = 0 ; i < needUpDateItems.length ; i++){
					needUpDateItems[i].y += speed;
				}
			}
			
			listBound();
			updateItemData();
			
			if(moveState == "DOWN"){
				//判断最后一个的位置
				if(lastItemPostion > parentSize && headIndex > 0){
					var lpos:Number = firstItemsPostion - firstItemSize - gap;
					needUpDateItems.unshift(needUpDateItems.pop());
					if(horizontalScrollEnabled){
						needUpDateItems[0].x = lpos;
					}else if(verticalScrollEnabled){
						needUpDateItems[0].y = lpos;
					}
					headIndex -- ;
					tailIndex --;
					needUpDateItems[0].data = virtualDataProvider[headIndex].data;
				}
				
			}
			else if(moveState == "UP"){
				//判断第一个的位置
				if(firstItemsPostion + firstItemSize < 0 && tailIndex < virtualDataProvider.length -1){
					var pos:Number = lastItemPostion + lastItemSize + gap;
					var item:MyItemRender = needUpDateItems.shift();
					if(horizontalScrollEnabled){
						item.x = pos
					}else if(verticalScrollEnabled){
						item.y = pos
					}
					needUpDateItems.push(item);
					tailIndex ++ ;
					headIndex ++;
					needUpDateItems[needUpDateItems.length -1].data = virtualDataProvider[tailIndex].data;
				}
			}
			
		}
		
		
		
		/**
		 *更新item的位置信息 
		 * 
		 */
		private function updateItemData():void{
			if(horizontalScrollEnabled){
				firstItemsPostion = needUpDateItems[0].x ;
				lastItemPostion = needUpDateItems[needUpDateItems.length -1].x ;
				if(fixDistance){
					firstItemSize = Math.ceil(itemWidth);
					lastItemSize = Math.ceil(itemWidth);
				}else{
					firstItemSize = needUpDateItems[0].width;
					lastItemSize = needUpDateItems[needUpDateItems.length -1].width;
				}
				
			}else if(verticalScrollEnabled){
				firstItemsPostion = needUpDateItems[0].y ;
				lastItemPostion = needUpDateItems[needUpDateItems.length -1].y;
				if(fixDistance){
					firstItemSize = Math.ceil(itemHeight);
					lastItemSize = Math.ceil(itemHeight);
				}else{
					firstItemSize = needUpDateItems[0].height;
					lastItemSize = needUpDateItems[needUpDateItems.length -1].height;
				}
			}
			
//			trace("lastItemSize:",lastItemSize,itemHeight,itemWidth)
		}
		
		/**
		 *反弹 
		 * 
		 */
		private function listBound():void{
			if(firstItemsPostion >= boundDistace && rebound && headIndex == 0){
				rebound = false;
				setTweenParameters(0,-boundDistace,boundDistace,Math.min(boundDistace,30))
			}else if(lastItemPostion+ lastItemSize + gap <= parentSize && rebound && tailIndex == virtualDataProvider.length - 1){
				rebound = false;
				setTweenParameters(0,boundDistace,-boundDistace,Math.min(boundDistace,30))
			}
		}
		
		
		//		private function enterFrameHandler(event:Event):void
		//		{
		//			if (fllowMouse)
		//			{
		//				if(horizontalScrollEnabled)
		//					container.x=parent.mouseX - currentMouseOffsetX;
		//				if(verticalScrollEnabled)
		//					container.y=parent.mouseY - currentMouseOffsetY;
		////				scrollBarRef.update(container.x,container.y);
		//				return;
		//			}
		//			if (Math.abs(speedX) < 4)
		//				speedX=0;
		//			if (Math.abs(speedY) < 4)
		//				speedY=0;
		//			if(speedX == 0 && speedY == 0)
		//			{
		////				scrollBarRef.clear();
		//				container.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		//				return;
		//			}
		//			container.x+=speedX;
		//			container.y+=speedY;
		//			trace("s:",checkXRange());
		//			trace("s:",checkYRange());
		//			if (directionX == "left")
		//				speedX+=1;
		//			else
		//				speedX-=1;
		//			if (directionY == "up")
		//				speedY+=1;
		//			else
		//				speedY-=1;
		////			scrollBarRef.update(container.x,container.y);
		//		}
		
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
			if(contentHeight <= parentSize)
			{
				speedY=0;
				container.y=0;
				return true;
			}
			if (container.y + contentHeight <= parentSize)
			{
				speedY=0;
				container.y=parentSize - contentHeight;
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
		
		/**显示区域中的数据*/
		public function get needUpDateItems():Vector.<MyItemRender>
		{
			return _needUpDateItems;
		}
		
		/**
		 * @private
		 */
		public function set needUpDateItems(value:Vector.<MyItemRender>):void
		{
			_needUpDateItems = value;
			if(_needUpDateItems){
				headIndex = 0 ;
				tailIndex = _needUpDateItems.length - 1 ;
			}
		}
		
		/**速度*/
		public function get speed():Number
		{
			return _speed;
		}
		
		/**
		 * @private
		 */
		public function set speed(value:Number):void
		{
			_speed = Math.ceil(value * 100)/100;
		}
		
		/**
		 *销毁方法 
		 * 
		 */
		public function destroy():void{
			if(mousePosVector){
				for(var i:int = mousePosVector.length -1 ; i>=0 ; i--){
					mousePosVector[i] = null ;
					mousePosVector.splice(i,1);
				}
//				mousePosVector = null;
			}
			if(needUpDateItems){
				for(i = needUpDateItems.length -1 ; i >= 0 ; i --){
					needUpDateItems[i] = null;
					needUpDateItems.splice(i,1);
				}
//				needUpDateItems = null;
			}
			if(virtualDataProvider){
				for( i = virtualDataProvider.length -1 ; i >= 0 ; i --){
					virtualDataProvider[i] = null;
					virtualDataProvider.splice(i,1);
				}
//				virtualDataProvider = null
			}
			if(container){
				if(container.hasEventListener(Event.ENTER_FRAME)){
					container.removeEventListener(Event.ENTER_FRAME,onRender);
					
				}
				Main.sceneManager.stage.removeEventListener(Main.upEvent,containerMouseHandler);
				Main.sceneManager.stage.removeEventListener(Main.moveEvent,containerMouseHandler);
				container.removeEventListener(Main.downEvent, containerMouseHandler);
//				this.parent = null;
//				this.container = null;
			}
		}
		
		/**水平可滚动*/
		public function get horizontalScrollEnabled():Boolean
		{
			return _horizontalScrollEnabled;
		}
		
		/**
		 * @private
		 */
		public function set horizontalScrollEnabled(value:Boolean):void
		{
			_horizontalScrollEnabled = value;
			if(value){
				parentSize = parentWidth
			}
		}
		
		/**垂直可滚动*/
		public function get verticalScrollEnabled():Boolean
		{
			return _verticalScrollEnabled;
		}
		
		/**
		 * @private
		 */
		public function set verticalScrollEnabled(value:Boolean):void
		{
			_verticalScrollEnabled = value;
			if(value){
				parentSize = parentHeight
			}
		}
		
		
	}
}