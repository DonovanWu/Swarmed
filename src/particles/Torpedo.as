package particles 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Torpedo extends Bullet
	{
		private var _g:GameEngine;
		
		private var _ct:Number = 0;
		private var _vel:Number;
		private var _ang:Number;
		
		private var _hp:int = 45;
		
		public function Torpedo(x:Number = 0, y:Number = 0, ang:Number = 0) 
		{
			super(x, y, ang, 4.5, 40);
			
			this._vel = 0;
			this.loadGraphic(Imports.IMPORT_TORPEDO);
			
			this.angle = ang;
			
			_ang = (Util.random_float(0, 2) <= 1) ? -0.1:0.1;
		}
		
		override public function update_particle(game:GameEngine):void {
			_g = game;
			
			_ct++;
			this.angle += Util.random_float( -0.05, 0.05) + _ang;
			
			if (_vel < _speed) {
				_vel += 0.15;
			}
			this.x += _vel * Math.cos(this.angle * Util.DEG2RAD);
			this.y += _vel * Math.sin(this.angle * Util.DEG2RAD);
			
			if (_ct % 5 == 0) {
				// add trail smoke to game
				var bubble:Bubble = new Bubble(this.x + this.width / 2, this.y, this.angle - 180);
				_g.particles.add();
			}
			
			// may add a test of overlapping with other bullets
			/*
			for (var i:int = 0; i < g._iceblocks.members.length; i++ ) {
				var itr_ice:IceBlocks = g._iceblocks.members[i];
				if (itr_ice.alive) {
					var ice_axis:Number = itr_ice.x + 20;
					if (Math.abs(this.x - ice_axis) <= g.POS_TOL*1.5) {
						itr_ice.kill();
					}
				}
			}
			*/
		}
		
		override public function should_remove():Boolean {
			return _ct >= 300 || _distance >= _range || _hp < 0;
		}
		
		override public function do_remove():void {
			if (_g != null) {
				var explosion:Explosion = new Explosion(itr_bubble.x, itr_bubble.y, 0)
				_explosions.add(explosion);
				explosion.explode();
			}
		}
	}

}