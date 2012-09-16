package com.ut.games.jellylo.agents.control 
{
	import com.ut.games.jellylo.messages.RequestCreditsMenu;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class MainMenuController 
	{
		
		public function MainMenuController() 
		{
			public function viewCredits_Click() {
				send(new RequestCreditsMenu());
			}
			
			
		}
	}
}