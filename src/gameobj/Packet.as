package gameobj 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class Packet extends FlxSprite
	{
		
		public function Packet(x:int = 0, y:int = 0, frame:uint = 0) 
		{
			this.loadGraphic(Imports.IMPORT_PACKETS, true, false, 20, 30);
			this.frame = frame;
			this.set_position(x, y);
		}
		
		public function getAmount():int {
			return Util.int_random(20, 50);
		}
	}

}