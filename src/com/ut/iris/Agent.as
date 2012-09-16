package com.ut.iris 
{
	import com.ut.collections.Iterator;
	import com.ut.collections.SLinkedList;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Agent 
	{
		private var flows : SLinkedList = new SLinkedList();
		private var _instances : SLinkedList = new SLinkedList();
		
		public function Agent() 
		{
			
		}
		
		public function addFlow(flow:Flow):void {
			flows.append(flow);
			flow.agent = this;
		}
		
		public function receiveMessageFromForgeInboundQueue( msg : Message ):void {
			trace("Agent.receiveMessageFromForgeInboundQueue");
			var flowIterator : Iterator = flows.getIterator();
			while ( flowIterator.hasNext() ) {
				(flowIterator.next() as Flow).receiveMessageFromForgeInboundQueue(msg);
			}
		}
		
		public function get instances():SLinkedList { return _instances; }
	}
	
}