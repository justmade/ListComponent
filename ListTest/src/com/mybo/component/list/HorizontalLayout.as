package com.mybo.component.list
{
	import flash.display.Sprite;
	
	public class HorizontalLayout implements ILayout
	{
		/**项之间的间距*/ 
		public var gap:Number = 0;
		
		private var h:int ;
		
		public function HorizontalLayout(gap:Number=0)
		{
			this.gap = gap;
		}
		
		public function layoutChildren(needUpDateitems:Vector.<MyItemRender>, virtualItemArr:Array, itemWidth:Number, itemHeight:Number, 
									   parentWidth:Number, parentHeight:Number, container:Sprite, itemRenderer:Class):void
		{
			var d:Number = 0 ;
			var itemCounts:Number;
			if((itemWidth + gap) * virtualItemArr.length > parentWidth){
				itemCounts = Math.floor(parentWidth / (itemWidth + gap))+1;
				
			}else{
				itemCounts = virtualItemArr.length ; 
			}
			
			for(var i:int = 0 ; i < itemCounts ; i++){
				needUpDateitems.push(new itemRenderer());
				needUpDateitems[i].data = virtualItemArr[i].data;
				trace("hieight:",needUpDateitems[i].height)
				h = needUpDateitems[i].height > h?needUpDateitems[i].height:h;
				needUpDateitems[i].y = parentHeight - needUpDateitems[i].height;
				needUpDateitems[i].x = d ;
				d += (itemWidth +gap) ;
				container.addChild(needUpDateitems[i]);
			}
			
		}
	}
}