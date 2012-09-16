package com.ut.games.jellylo
{
	import com.ut.games.jellylo.agents.logic.GameLogic;
	import com.ut.games.jellylo.agents.logic.MenuLogic;
	import com.ut.games.jellylo.agents.presentation.MainMenu;
	import com.ut.games.jellylo.messages.GameInitialTrigger;
	import com.ut.games.jellylo.messages.RequestCreditsMenu;
	import com.ut.games.jellylo.poc.Manager;
	import com.ut.iris.Iris;
	import com.ut.vulcano.Vulcano;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Main extends Sprite
	{
		private var vulcanoContext:Vulcano;
		private var logicGameInstantiated:Boolean = false ;
		
		public function Main():void 
		{
			XML.ignoreWhitespace = true;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			// This is required to make the compiler include this classes
			var a1:GameLogic;
			var a2:MenuLogic;
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				Vulcano.instance.loadContextFromString( e.target.data );
				addEventListener(Event.ENTER_FRAME, enterFrame);
			});
			loader.load(new URLRequest("conf/prueba.xml"));
		}
		
		public function enterFrame(e:Event = null):void {
			var myIris:Iris = Vulcano.instance.getForge("iris") as Iris;
			myIris.executeIteration();
			
			if ( myIris.ready && ! logicGameInstantiated ) {
				logicGameInstantiated = true;
				myIris.instantiateAgent("logic.game");
				myIris.sendToForge(this, "logic.game", new GameInitialTrigger());
			}
			if ( logicGameInstantiated ) {
				
			}
		}
	}
	
}