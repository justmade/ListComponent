package  com.mybo.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class VerticalLayout implements ILayout 
	{ 
		/**项之间的间距*/ 
		public var gap:Number = 0; 
		/** 
		 * 构造方法 
		 * @param matchContainerWidth 
		 * @param gap 
		 * 
		 */ 
		public function VerticalLayout(gap:Number=0) 
		{ 
			this.gap = gap; 
		} 
		
	
		
		/** 
		 * 布局子元件 
		 * @param container 
		 * @param parentWidth 
		 * @param parentHeight 
		 * 
		 */ 
		public function layoutChildren(needUpDateitems:Vector.<MyItemRender>, virtualItemArr:Array, itemWidth:Number, itemHeight:Number, parentWidth:Number, parentHeight:Number,container:Sprite,itemRenderer:Class):void
		{
			var itemCounts:Number;
			if((itemHeight + gap) * virtualItemArr.length > parentHeight){
				itemCounts = Math.ceil(parentHeight / (itemHeight + gap))+1;
			}else{
				itemCounts = virtualItemArr.length ; 
			}
			for(var i:int = 0 ; i < itemCounts ; i++){
				needUpDateitems.push(new itemRenderer());
				needUpDateitems[i].data = virtualItemArr[i].data;
				needUpDateitems[i].y = (needUpDateitems[i].height +gap)*i ;
				needUpDateitems[i].x = 0
				container.addChild(needUpDateitems[i]);
			}
			
		}
		
	}
}