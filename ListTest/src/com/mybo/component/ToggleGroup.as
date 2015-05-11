package com.mybo.component
{
	
	import flash.display.Sprite;
	
	public class ToggleGroup extends Sprite
	{
		
		private var toggleSkin:Class;
		
		private var toggleLength:int
		
		private var toggleArr:Vector.<TogglePoint>;
		public function ToggleGroup(_toggleSkin:Class,_length:int)
		{
			super();
			toggleSkin = _toggleSkin ;
			
			toggleLength = _length;
			
			init();
		}
		
		private function init():void{
			toggleArr = new Vector.<TogglePoint>();
			for(var i:int =0 ; i < toggleLength ; i ++){
				toggleArr.push(new toggleSkin());
				toggleArr[i].x = (toggleArr[i].width*3) * i;
				this.addChild(toggleArr[i]);
			}
			setChooseToggle(0);
		}
		
		public function setChooseToggle(_index:int):void{
			for(var i:int =0 ; i < toggleLength ; i ++){
				toggleArr[i].isChoose = false;
				if(i == _index){
					toggleArr[i].isChoose = true;
				}
			}
		}
	}
}