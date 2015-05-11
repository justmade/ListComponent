package com.mybo.component
{
	import com.mybo.gui.Button;
	import com.mybo.gui.TextButton;
	import com.mybo.gui.ToggleButton;

	public class ToolTab
	{
		
		private var buttons:Array ;
		
		private var currentIndex:int = 0 ;
		
		private var changeFunction:Function;
		
		public var tabNames:Array ;
		
		private var _currentTabName:String="";
		
		
		public function ToolTab(buttons:Array,tabNames:Array,changeFunction:Function)
		{
			this.buttons = buttons;
			this.tabNames = tabNames ;
			this.changeFunction = changeFunction;
			initSkin();
		}
		
		private function initSkin():void{
			for(var i:int = 0 ; i < this.buttons.length ; i++){
				ToggleButton(buttons[i]).setClick(setButtonState,tabNames[i]);
			}
			currentTabName = tabNames[0];
			setButtonState(currentTabName);
		}
		
		private function setButtonState(name:String):void{
			for(var i:int = 0 ; i < buttons.length ; i++){
				if(tabNames[i] == name){
					currentIndex = i;
					ToggleButton(buttons[i]).setSelected(true);
				}else{
					if(ToggleButton(buttons[i]).isSelected()){
						ToggleButton(buttons[i]).setSelected(false);
					}
				}
			}
			_currentTabName = name;
			changeFunction();
		}

		/**当期页签*/
		public function get currentTabName():String
		{
			return _currentTabName;
		}

		/**
		 * @private
		 */
		public function set currentTabName(value:String):void
		{
			_currentTabName = value;
			setButtonState(value);
		}

		
	}
}