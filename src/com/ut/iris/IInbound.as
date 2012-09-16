package com.ut.iris 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public interface IInbound 
	{
		function canReceiveMessageFromForgeInboundQueue(msg:Message):Boolean;
	}
	
}