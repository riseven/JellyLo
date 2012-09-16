package com.ut.iris 
{
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class PayloadTypeFilter implements IFilter
	{
		private var _type:Class;
		
		public function PayloadTypeFilter() 
		{
			
		}
		
		/* INTERFACE com.ut.iris.IFilter */
		public function evaluate(msg:Message, instance:Object):Boolean
		{
			return msg.payload is _type;
		}
		
		public function get type():Class { return _type; }
		
		public function set type(value:Class):void 
		{
			_type = value;
		}
		
	}
	
}