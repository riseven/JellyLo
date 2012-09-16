package com.ut.iris 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class SimpleMethodRouter implements IMethodRouter
	{
		private var _methodName:String; // TODO: Maybe saving a reference to the Function object would be better
		
		public function SimpleMethodRouter() 
		{
			
		}
		
		/* INTERFACE com.ut.iris.IMethodRouter */
		public function execute(msg:Message, instance:Object):void
		{
			var result:Object = instance[methodName]();
			if ( result != null )
		}
		
		public function get methodName():String { return _methodName; }
		
		public function set methodName(value:String):void 
		{
			_methodName = value;
		}
		
		
	}
	
}