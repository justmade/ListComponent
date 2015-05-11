package  com.mybo.component.list
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MyItemRender extends MovieClip implements IItemRenderer
	{
		
		private var labelTitle:TextField;
		private var labelContent:TextField;
		
		private var itemWidth:Number;
		
		
		public function MyItemRender()
		{
		
			super();
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			this.graphics.beginFill(0xff00ff);
			this.graphics.drawRect(-50,0,100,100);
			this.graphics.endFill();
		}
		
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)
				return;
			_selected = value;
			
		}
		
		override public function get height():Number
		{
			
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		
		override public function get width():Number
		{
			return super.width;
		}
		override public function set width(value:Number):void
		{
			super.width = value;
			
		}
		
		
		public function clear():void
		{
			//do nothing
		}
		
	}
}