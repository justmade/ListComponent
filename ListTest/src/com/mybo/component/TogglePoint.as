package com.mybo.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class TogglePoint extends MovieClip
	{
		private var _isChoose:Boolean;
		
		public function TogglePoint()
		{
			super();
			this.gotoAndStop("unchoose");
		}
		
		public function get isChoose():Boolean
		{
			return _isChoose;
		}

		public function set isChoose(value:Boolean):void
		{
			_isChoose = value;
			if(value){
				this.gotoAndStop("choose");
			}
			else{
				this.gotoAndStop("unchoose");
			}
		}

	}
}