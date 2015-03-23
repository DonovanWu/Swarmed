package core 
{
	/**
	 * ...
	 * @author ...
	 */
	public class VanguardCorpse extends Corpse
	{
		
		public function VanguardCorpse(x:Number, y:Number, ang:Number) 
		{
			super(x, y, ang);
			
			name = "vanguard";
			this.loadGraphic(Imports.VANGUARD_CORPSE);
			_x = this.x;
			_y = this.y;
			this.set_position(x - this.width / 2, y - this.height / 2);
		}
		
		override public function revive_robot():void {
			super.revive_robot();
			_g.revive_vanguard(this._x, this._y, this);
		}
	}

}