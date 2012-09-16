package com.ut.games.jellylo.agents.presentation 
{
	import flash.display.Shape;
	import com.ut.games.jellylo.Game;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class MainMenu 
	{
		private const BACKGROUND_COLOR : int = 0xff0000;
		public var background : Shape;
		
		public function MainMenu() 
		{
			background = new Shape();
			background.graphics.beginFill(BACKGROUND_COLOR);
			background.graphics.drawRect(0, 0, Game.instance.stage.stageWidth, Game.instance.stage.stageHeight);
			background.graphics.endFill();
			background.visible = false;
			background.alpha = 0;
			Game.instance.stage.addChild(background);
			Game.instance.mainMenu = this;
		}
		
	}
	
}