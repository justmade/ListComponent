package
{
	import com.mybo.component.MyItemRender;
	import com.mybo.component.ScrollableList;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import net.hires.debug.Stats;
	
	[SWF(frameRate="60")]
	public class ListTest extends Sprite
	{
		
		private var list:ScrollableList;
		
		private var marginValue :int =20;
		
		public function ListTest()
		{
//			var imgContainer:ScrollableContainer = new ScrollableContainer();
//			imgContainer.setStyle("borderColor",0xCCCCCC); 
//			this.addChild(imgContainer);
//			var imgV:Bitmap = new Bitmap(new img.ValliantHearts());
//			imgContainer.addChild(imgV);
//			imgContainer.width = 200;
//			imgContainer.height = 200;
			this.addChild(new Stats());
			initList();
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xff00ff,1);
			sp.graphics.drawRect(0,0,100,200);
			sp.graphics.endFill();
			this.addChild(sp);
			sp.x = 300;
			sp.addEventListener(MouseEvent.CLICK , onClear);
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
			list.height = 200
			list.dataProvider = dataArr;
			//			list.addEventListener(DataChangeEvent.ITEM_CHANGE,itemChangeHandler);
			addChild(list);
			layoutChildren();
			stage.addEventListener(Event.RESIZE,layoutChildren);
//			addChild(new Stats());
			
		}
		private function layoutChildren(...args):void
		{
		}
		
		
	}
}