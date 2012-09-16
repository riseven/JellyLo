package com.ut.iris 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public interface IFilter 
	{
		function evaluate(msg:Message, instance:Object):Boolean;
	}
	
}