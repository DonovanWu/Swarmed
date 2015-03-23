package particles 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Ripple extends Particle
	{
		private var sc:Number = 1;
		private var sc_inc:Number = 0.08;
		
		public function Ripple(x:Number = 0, y:Number = 0) 
		{
			super(x, y);
			this.loadGraphic(Imports.IMPORT_RIPPLE, true, false, 100, 100);
			this.addAnimation("ripple", [0, 1, 2, 3, 4, 5], 20, false);
			this.set_position(x - this.width / 2, y - this.height / 2);
		}
		
		override public function update_particle(game:GameEngine):void {
			if (!this.finished) {
				this.play("ripple");
			}
			this.set_scale(sc);
			this.alpha *= 0.93;
			
			sc = sc + sc_inc * 0.96;
		}
		
		override public function should_remove():Boolean {
			return this.alpha < 0.05;
		}
	}

}