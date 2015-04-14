package com.mybo.component
{
	import flash.display.Sprite;

	public interface ILayout
	{
		/**布局子元件*/ 
		function layoutChildren(needUpDateitems:Vector.<MyItemRender>,virtualItemArr:Array,itemWidth:Number,itemHeight:Number,parentWidth:Number,parentHeight:Number,container:Sprite,itemRenderer:Class):void; 
		
	}
}