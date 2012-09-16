package com.ut.games.jellylo 
{
	import com.ut.games.jellylo.agents.presentation.MainMenu;
	import flash.display.Stage;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Game 
	{
		private static var _instance:Game = new Game(SingletonLock);
		private var _stage:Stage = null;
		private var _mainMenu:MainMenu = null;
		
		public function Game(lock:Class) 
		{
			if ( lock != SingletonLock ) {
				throw new Error("Singleton violation");
			}
		}
		
		public static function get instance():Game { 
			return _instance; 
		}
		
		public function get stage():Stage { 
			return _stage; 
		}
		
		public function set stage(value:Stage):void 
		{
			if ( _stage != null ) {
				throw new Error("Stage can be assigned only once");
			}
			_stage = value;
		}
		
		public function get mainMenu():MainMenu { return _mainMenu; }
		
		public function set mainMenu(value:MainMenu):void 
		{
			_mainMenu = value;
		}
	}
	
}

