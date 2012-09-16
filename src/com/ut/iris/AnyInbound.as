package com.ut.iris 
{
	
	/**
	 * ...
	 * @author Andres Sanchis
	 */
	public class AnyInbound implements IInbound
	{		
		public function AnyInbound() 
		{
			
		}
		
		/* INTERFACE com.ut.iris.IInbound */
		public function canReceiveMessageFromForgeInboundQueue(msg:Message):Boolean
		{
			return true;
		}
		
	}
	
}