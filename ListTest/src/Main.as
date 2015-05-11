package
{
	import com.mybo.component.flopView.FlopView;
	import com.mybo.component.list.HorizontalLayout;
	import com.mybo.component.list.MyItemRender;
	import com.mybo.component.list.ScrollableList;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import net.hires.debug.Stats;

	[SWF(frameRate="60")]
	public class Main extends Sprite
	{
		public static var sceneManager:Main;
		public static var downEvent: String;
		public static var upEvent:String;
		public static var moveEvent:String;
		public static var isMultiTouch: Boolean;
		public static var debug:Boolean=false;
		public var s:Stage ;
		private var list:ScrollableList;
		
		private var marginValue :int =20;
		
		private var flop:FlopView
		
		public function Main()
		{
			super();
			sceneManager = this;
		
			if (Multitouch.supportsTouchEvents)
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			isMultiTouch = (Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT);
			if (isMultiTouch) {
				downEvent = TouchEvent.TOUCH_BEGIN;
				upEvent = TouchEvent.TOUCH_END;
				moveEvent=TouchEvent.TOUCH_MOVE;
			} else {
				downEvent = MouseEvent.MOUSE_DOWN;
				upEvent = MouseEvent.MOUSE_UP;
				moveEvent = MouseEvent.MOUSE_MOVE;
			}
			
			this.addChild(new Stats());
//			initList();
//			
//			var sp:Sprite = new Sprite();
//			sp.graphics.beginFill(0xff00ff,1);
//			sp.graphics.drawRect(0,0,100,200);
//			sp.graphics.endFill();
//			this.addChild(sp);
//			sp.x = 300;
//			sp.addEventListener(MouseEvent.CLICK , onClear);
			
			initFlop();
			
		}
		protected function onClear(event:MouseEvent):void
		{
			if(list){
				list.destroy();
				this.removeChild(list);
				list = null
			}
			initList();
		}		
		
		private function initList():void{
			var dataArr:Array = new Array();
			for(var i:int = 0 ; i < 100 ; i ++){
				var obj:Object = new Object();
				obj.t = String("Title:"+i);
				obj.c = String("Description:" + i);
				dataArr.push(obj);
				
			}
			
			list = new ScrollableList(MyItemRender,10);
			list.x = marginValue;
			list.y = marginValue;
			list.setStyle("borderColor",0xCCCCCC);
			list.setStyle("bgColor",0x000000);
			list.setStyle("bgAlpha",0.5);
			list.width = 400 - 2*marginValue;
			list.height = 200;
			list.layout = new HorizontalLayout(10);
			list.verticalScrollEnabled = false;
			list.horizontalScrollEnabled = true;
			list.dataProvider = dataArr;
			//			list.addEventListener(DataChangeEvent.ITEM_CHANGE,itemChangeHandler);
			addChild(list);
			layoutChildren();
			stage.addEventListener(Event.RESIZE,layoutChildren);
			//			addChild(new Stats());
			
		}
		
		private function initFlop():void{
			var dataArr:Array = new Array();
			for(var i:int = 0 ; i < 100 ; i ++){
				var obj:Object = new Object();
				obj.t = String("Title:"+i);
				obj.c = String("Description:" + i);
				dataArr.push(obj);
				
			}
			flop = new FlopView(MyItemRender);
			flop.width = 400;
			flop.height = 200;
			flop.dataProvider = dataArr;
			this.addChild(flop);
			
		}
		private function layoutChildren(...args):void
		{
		}
		
	}
}