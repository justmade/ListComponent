package  com.mybo.component
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class MyItemRender extends Sprite implements IItemRenderer
	{
		
		private var labelTitle:TextField;
		private var labelContent:TextField;
		
		private var itemWidth:Number;
		
		
		public function MyItemRender()
		{
			//创建标题
			labelTitle = new TextField();
			labelTitle.width = 100;
			labelTitle.height = 30;
			labelTitle.x = 10;
			labelTitle.y = 10;
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.size = 20;
			labelFormat.bold = true;
			labelTitle.defaultTextFormat = labelFormat;
			labelTitle.selectable = false;
			addChild(labelTitle);
			//创建摘要
			labelContent = new TextField();
			labelContent.width = 100;
			labelContent.height = 20;
			labelContent.x = 10;
			labelContent.y = 30;
			labelContent.wordWrap = true;
			labelContent.multiline = true;
			labelContent.selectable = false;
			addChild(labelContent);
			//
			this.mouseChildren = false;
			this.width = 100;
			
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			labelTitle.text = data.t;
			labelContent.text = data.c;
			if(parent != null)
				drawBackGround();
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
			if(parent != null)
				drawBackGround();
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
			return itemWidth;
		}
		override public function set width(value:Number):void
		{
			itemWidth = value;
			if(parent != null)
				drawBackGround();
		}
		/**
		 * 绘制背景
		 */        
		public function drawBackGround():void
		{
			labelTitle.width = itemWidth-20;
			labelContent.width = itemWidth-20;
			labelContent.height = labelContent.textHeight + 20;
			//bg
			var g:Graphics = this.graphics;
			g.clear();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(itemWidth,height,90,0,0);
			if(_selected)
				g.beginGradientFill(GradientType.LINEAR,[0xFF0000,0x00FF00],[1,1],[1,255],matrix);
			else
				g.beginGradientFill(GradientType.LINEAR,[0xFFFFFF,0xCCCCCC],[1,1],[1,255],matrix);
			g.drawRect(0,0,itemWidth,height);
			g.endFill();
		}
		
		public function clear():void
		{
			//do nothing
		}
		
	}
}
import com.sty.display;

