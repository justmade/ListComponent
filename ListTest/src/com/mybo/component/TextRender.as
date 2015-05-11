package com.mybo.component
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TextRender extends Sprite
	{
		
		
		public function TextRender(message:String,size:int)
		{
			var tf:TextField = new TextField();
			tf.text = message ;
			tf.width = tf.textWidth + 5;
			tf.height = tf.textHeight;
			tf.defaultTextFormat = new TextFormat(null,size,0xFF0000);
			tf.mouseEnabled = false ;
			tf.selectable = false ;
			this.addChild(tf);
		}
	}
}