package com.ut.iris 
{
	import com.ut.collections.HashMap;
	import com.ut.collections.Iterator;
	import com.ut.collections.LinkedQueue;
	import com.ut.collections.SLinkedList;
	import com.ut.vulcano.Vulcano;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Iris 
	{
		private var firstIteration:Boolean = true;
		private var remainigFilesToRead:int = 0;
		private var imports:SLinkedList = new SLinkedList();
		private var instances:HashMap = new HashMap();
		private var forgeInboundQueues:HashMap = new HashMap();
		private var agents:HashMap = new HashMap();
		
		private var _contextFiles:Array;	
		
		public function Iris() {
		}
		
		public function get contextFiles():Array { return _contextFiles; }
		
		public function set contextFiles(value:Array):void 
		{
			if ( firstIteration == false ) {
				throw new Error("Iris context files cannot be changed adhoc");
			}
			_contextFiles = value;
		}
		
		private function loadContextFiles():void {
			for each ( var contextFile:String in contextFiles ) {
				remainigFilesToRead++;
				
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, function(e:Event):void {
					remainigFilesToRead--;
					
					var xmlInput:XML = XML(e.target.data);
					loadContextFile(xmlInput);
				});
				loader.load(new URLRequest(contextFile));
			}
		}
		
		private function loadContextFile(input:XML):void {
			loadImports(input);
			loadAgents(input);
		}
		
		private function loadImports(input:XML):void {
			for each ( var importNode:XML in input["import"] ) {
				imports.append( importNode.toString() );
			}
		}
		
		private function loadAgents(input:XML):void {
			for each ( var agent:XML in input.agent ) {
				registerForge( agent.@forge );
				
				var agentDesc:Agent = new Agent();
				
				for each ( var flow:XML in agent.flow) {
					var flowDesc:Flow = new Flow();
					
					// Inbounds
					for each ( var anyInbound:XML in flow.anyInbound ) {
						flowDesc.inbounds.append( new AnyInbound() );
					}
					
					// Filters
					for each ( var payloadTypeFilter:XML in flow.payloadTypeFilter ) {
						var filter : PayloadTypeFilter = new PayloadTypeFilter();
						filter.type = getDefinitionByNameAndImports(payloadTypeFilter["@class"].toString());
						flowDesc.filters.append( filter );
					}
					
					// Method(s?)
					for each ( var simpleMethod:XML in flow.simpleMethod ) {
						var methodRouter : SimpleMethodRouter = new SimpleMethodRouter();
						methodRouter.methodName = simpleMethod.@name.toString();
						flowDesc.methodRouter = methodRouter;
					}
					
					// Outbounds
					
					agentDesc.addFlow(flowDesc);
				}
				agents.insert(agent.@forge.toString(), agentDesc);
			}
		}
		
		public function getDefinitionByNameAndImports(className:String):Class {
			try {
				var classObj:Class = getDefinitionByName(className) as Class;
				return classObj;
			} catch ( error : Error){
				// Now try with imports
				var importIterator : Iterator = imports.getIterator();
				while ( importIterator.hasNext() ) {
					var fullClassName:String = importIterator.next() + "." + className;
					
					try {
						var classObj2:Class = getDefinitionByName(fullClassName) as Class;
						return classObj2;
					} catch (error2 : Error) {
						// Nothing, continue the loop to try another import prefix
					}
				}
				
				// If no single import allowed to find class, rethrow original error (the one without import)
				error.message += " " + className;
				throw error;
			}
			return null;
		}
		
		/**
		 * Instantiates a new agent, returning a proxy object
		 * @param	forgeId	forge id to instantiate through Vulcano
		 * @return 	Agent proxy
		 */
		public function instantiateAgent(forgeId:String) : Object {
			var obj:Object = Vulcano.instance.getForge(forgeId);
			
			// Register instance
			(agents.find(forgeId) as Agent).instances.append(obj);
			//(instances.find(forgeId) as SLinkedList).append(obj);
			
			return null; // TODO: Return an agent proxy
		}
		
		public function get ready():Boolean { 
			return firstIteration == false && remainigFilesToRead < 1;
		}
		
		public function executeIteration():void {
			if ( firstIteration ) {
				loadContextFiles();
				firstIteration = false ;
			}
			if ( remainigFilesToRead < 1 ) {
				reallyExecuteIteration();
			} else {
				//trace("not ready");
			}
		}
		
		private function reallyExecuteIteration():void {
			processForgeInboundQueues();			
		}
		
		private function processForgeInboundQueues():void {
			for each ( var forgeId:String in forgeInboundQueues.getKeySet() ) {
				var agent:Agent = agents.find(forgeId);
				
				var queue : LinkedQueue = forgeInboundQueues.find(forgeId);
				
				while ( queue.isEmpty() == false ) {
					var msg : Message = queue.dequeue() as Message;
					agent.receiveMessageFromForgeInboundQueue(msg);
					//dispatchToForge(forgeId, msg);
				}
			}
		}
		
		private function dispatchToForge(forgeId:String, msg:Message):void {			
			var instanceIterator : Iterator = (instances.find(forgeId) as SLinkedList).getIterator();
			while ( instanceIterator.hasNext() ) {
				var instance:Object = instanceIterator.next() ;
				instance.gameInitialTrigger();
			}
		}
		
		private function registerForge(forgeId:String):void {
			// Register forge
			if ( instances.containsKey(forgeId) == false ) {
				instances.insert(forgeId, new SLinkedList());
				forgeInboundQueues.insert(forgeId, new LinkedQueue());
			} else {
				throw new Error("Forge already registered: " + forgeId);
			}
		}
		
		/**
		 * Sends a message to every existing instance of the specified forge
		 * @param	forgeId
		 */
		public function sendToForge(sender:Object, forgeId:String, payload:Object):void {			
			var msg : Message = new Message();
			msg.sender = sender;
			msg.payload = payload;
			
			(forgeInboundQueues.find(forgeId) as LinkedQueue).enqueue(msg);
		}
	}
	
}