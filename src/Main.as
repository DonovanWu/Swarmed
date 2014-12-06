package {
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	
	import flash.display.*;
	import flash.events.*;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	
	[SWF(backgroundColor = "#FFFFFF", frameRate = "60", width = "640", height = "640")]
	[Frame(factoryClass = "Preloader")]
	
	public class Main extends FlxGame {

		public function Main():void {
			super(640, 640, GameEngine);
		}
	}

}