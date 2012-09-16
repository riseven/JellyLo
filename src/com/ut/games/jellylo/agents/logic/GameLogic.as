package com.ut.games.jellylo.agents.logic 
{
	import com.ut.iris.Iris;
	import com.ut.vulcano.Vulcano;
	
	/**
	 * 
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class GameLogic 
	{
		private var _logicMenuId:String;
		
		/**
		 * When this object is created it assumes that Iris is up and running. Let's the game start
		 */
		public function GameLogic() 
		{
			trace("GameLogic created");
			
			// Create initial agents
			var myIris:Iris = Vulcano.instance.getForge("iris") as Iris;
			
			// TODO: Use Vulcano filled propertis to reference another forges, however GameLogic is 
			// a special case since it has logic in its constructor (very against Vulcano nature).
			// This is he only forge that requires to do so, and it would be removed in the future
			// maybe for a manually initial message stimulus.
			myIris.instantiateAgent("logic.menu");
		}
		
		public function get logicMenuId():String { return _logicMenuId; }
		
		public function set logicMenuId(value:String):void 
		{
			_logicMenuId = value;
		}
		
		public function gameInitialTrigger():void {
			trace("GameLogic.gameInitialTrigger");
		}
		
	}
	
}