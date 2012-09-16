package com.ut.games.jellylo.poc 
{
	import com.ut.games.jellylo.Game;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Manager 
	{
		public var a:Object;
		
		public function Manager() 
		{
			
		}
		
		public function run():void
		{
			Game.instance.mainMenu.background.visible = true;
			Game.instance.mainMenu.background.alpha = 0.5;
		}
		
	}
	
}