package core 
{
	/**
	 * ...
	 * @author ...
	 */
	public class KnightCorpse extends Corpse
	{
		
		public function KnightCorpse(x:Number, y:Number, ang:Number) 
		{
			super(x, y, ang);
			
			name = "knight";
			this.loadGraphic(Imports.KNIGHT_CORPSE);
			_x = this.x;
			_y = this.y;
			this.set_position(x - this.width / 2, y - this.height / 2);
		}
		
		override public function revive_robot():void {
			super.revive_robot();
			_g.revive_knight(this._x, this._y, this);
		}
	}

}