package particles 
{
	import core.*;
	/**
	 * ...
	 * @author ...
	 */
	public class SprintShadow extends Particle
	{
		/*
		public function SprintShadow(name:String, x:Number = 0, y:Number = 0, ang:Number = 0) 
		{
			
		}
		*/
		private var alpha_decay:Number;
		
		public function SprintShadow(player:Character) {
			if (player is Knight) {
				this.loadGraphic(Imports.KNIGHT_BODY);
			} else if (player is Vanguard) {
				this.loadGraphic(Imports.VANGUARD_BODY);
			} else if (player is Scout) {
				this.loadGraphic(Imports.SCOUT_BODY);
			} else if (player is BigMech) {
				this.visible = false;
			}
			this.set_position(player.x() - this.width / 2, player.y() - this.height / 2);
			this.angle = player.ang;
			this.alpha = 0.75;
			alpha_decay = player.moveSpeed * player.mobility / 20;
		}
		
		override public function update_particle(game:GameEngine):void {
			this.alpha -= alpha_decay;
		}
		
		override public function should_remove():Boolean {
			return this.alpha < 0.1;
		}
	}

}