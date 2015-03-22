package particles 
{
	/**
	 * ...
	 * @author ...
	 */
	public class RailgunRound extends Bullet
	{
		
		public function RailgunRound(x:Number = 0, y:Number = 0, ang:Number = 0, speed:Number = 5, damage:int = 0, range:Number = 1200) 
		{
			super(x, y, ang, speed, damage, range);
			this.loadGraphic(Imports.BULLET_RAILGUN);
		}
		
	}

}