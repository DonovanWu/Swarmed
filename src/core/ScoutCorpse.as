package core 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ScoutCorpse extends Corpse
	{
		
		public function ScoutCorpse(x:Number, y:Number, ang:Number) 
		{
			super(x, y, ang);
			
			name = "scout";
			this.loadGraphic(Imports.SCOUT_CORPSE);
			_x = this.x;
			_y = this.y;
			this.set_position(x - this.width / 2, y - this.height / 2);
		}
		
		override public function revive_robot():void {
			_g.revive_scout(this._x, this._y, this);
		}
	}

}