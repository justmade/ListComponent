package com.mybo.component.flopView
{
	import com.mybo.Main;
	import com.mybo.component.list.MyItemRender;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import gs.TweenMax;

	public class FlopControler
	{
		private var _needUpDateItems:Vector.<MyItemRender>;
		
		private var _virtualDataProvider:Array;
		
		private var container:Sprite;
		
		private var parent:Sprite;
		
		private var startX:Number;
		
		private var startY:Number;
		
		private var speed:Number;
		
		private var moveState:String;
		
		private var tween:TweenMax;
		
		private var displayIndex:int ;
		
		
		public function FlopControler(contentGroup:Sprite, parent:Sprite)
		{
			this.container=contentGroup;
			this.parent=parent;
			initContainer();
		}
		
		private function initContainer():void
		{
			container.addEventListener(Event.ADDED_TO_STAGE,addListeners);
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
		
		private function containerMouseHandler(event:Event):void
		{
			if (event.type == Main.downEvent)
			{
				Main.sceneManager.stage.addEventListener(Main.upEvent,containerMouseHandler);
				Main.sceneManager.stage.addEventListener(Main.moveEvent,containerMouseHandler);
				startX=parent.mouseX;
				startY=parent.mouseY
			}
				
			else if (event.type == Main.upEvent)
			{
				
				Main.sceneManager.stage.removeEventListener(Main.upEvent,containerMouseHandler);
				Main.sceneManager.stage.removeEventListener(Main.moveEvent,containerMouseHandler);
				container.addEventListener(Main.downEvent, containerMouseHandler);
				
				speed = parent.mouseX - startX;
				if(speed > 0){
					moveState = "DOWN"
				}else{
					moveState = "UP";
				}
				startY = parent.mouseY;
				startX = parent.mouseX;
				flop();
			}
		}
		
		private function flop():void{
			if(moveState){
				tween = TweenMax.to(container,0.5,{scaleX:0,onComplete:firstFlop})
			}
		}
		
		private function firstFlop():void{
			displayIndex ++;
			if(displayIndex > virtualDataProvider.length -1){
				displayIndex = 0;
			}
			needUpDateItems[0].data = virtualDataProvider[displayIndex].data;
			tween = TweenMax.to(container,0.5,{scaleX:1,onComplete:secondFlop});
		}

		private function secondFlop():void{
			tween.clear();
		}
		
		
		public function get needUpDateItems():Vector.<MyItemRender>
		{
			return _needUpDateItems;
		}

		public function set needUpDateItems(value:Vector.<MyItemRender>):void
		{
			_needUpDateItems = value;
		}

		public function get virtualDataProvider():Array
		{
			return _virtualDataProvider;
		}

		public function set virtualDataProvider(value:Array):void
		{
			_virtualDataProvider = value;
		}


	}
}