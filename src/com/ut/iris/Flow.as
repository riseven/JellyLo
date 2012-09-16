package com.ut.iris 
{
	import com.ut.collections.Iterator;
	import com.ut.collections.SLinkedList;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Flow 
	{
		private var _inbounds:SLinkedList = new SLinkedList();
		private var _filters:SLinkedList = new SLinkedList();
		private var _methodRouter:IMethodRouter;
		private var _agent:Agent;
		
		public function Flow() 
		{
		}
		
		public function get inbounds():SLinkedList { return _inbounds; }
		
		public function get agent():Agent { return _agent; }
		
		public function set agent(value:Agent):void 
		{
			_agent = value;
		}
		
		public function get filters():SLinkedList { return _filters; }
		
		public function get methodRouter():IMethodRouter { return _methodRouter; }
		
		public function set methodRouter(value:IMethodRouter):void 
		{
			_methodRouter = value;
		}
		
		public function receiveMessageFromForgeInboundQueue( msg : Message ):void {
			var inboundIterator:Iterator = inbounds.getIterator();
			var canReceive:Boolean = false ;
			while ( inboundIterator.hasNext() ) {
				var inbound:IInbound = inboundIterator.next() as IInbound;
				
				if ( inbound.canReceiveMessageFromForgeInboundQueue( msg ) ) {
					canReceive = true;
					break;
				}
			}
			
			if ( canReceive ) {
				var instanceIterator:Iterator = agent.instances.getIterator();
				while ( instanceIterator.hasNext() ) {
					var instance : Object = (instanceIterator.next() as Object);
					
					// Pass filter (could be instance dependent)
					
					var filtersPassed:Boolean = true;
					var filterIterator:Iterator = filters.getIterator();
					while ( filterIterator.hasNext() ) {
						if ( (filterIterator.next() as IFilter).evaluate(msg, instance) == false ) {
							filtersPassed = false;
							break;
						}
					}
					
					if ( filtersPassed ) {
						// Get the method router
						methodRouter.execute(msg, instance);
					}
				}
			}
		}
		
	}
	
}