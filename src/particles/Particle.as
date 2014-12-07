package particles 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class Particle extends FlxSprite	{
		
		public function Particle(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		
		public function bullet_update(game:GameEngine):void { }
		public function should_remove():Boolean { return true; }
		public function do_remove():void { }
	}

}