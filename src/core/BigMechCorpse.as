package core 
{
	/**
	 * ...
	 * @author ...
	 */
	public class BigMechCorpse extends Corpse
	{
		
		public function BigMechCorpse(x:Number, y:Number, ang:Number) 
		{
			super(x, y, ang);
			
			name = "bigmech";
			this.loadGraphic(Imports.BIGMECH_CORPSE);
			_x = this.x;
			_y = this.y;
			this.set_position(x - this.width / 2, y - this.height / 2);
		}
		
		override public function revive_robot():void {
			super.revive_robot();
			_g.revive_bigmech(this._x, this._y, this);
		}
	}

}