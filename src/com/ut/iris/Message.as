package com.ut.iris 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Message 
	{
		private var _sender:Object = null;
		private var _payload:Object = null;
		
		public function Message() 
		{
			
		}
		
		public function get sender():Object { return _sender; }
		
		public function set sender(value:Object):void 
		{
			_sender = value;
		}
		
		public function get payload():Object { return _payload; }
		
		public function set payload(value:Object):void 
		{
			_payload = value;
		}
		
	}
	
}