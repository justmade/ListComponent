package  com.mybo.component.list
{
	import flash.events.IEventDispatcher;
	
	public interface IItemRenderer extends IEventDispatcher 
	{
		function get data():Object; 
		function set data(value:Object):void; 
		
		function get selected():Boolean; 
		function set selected(value:Boolean):void; 
		
		function clear():void; 
	}
}