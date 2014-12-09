package particles 
{
	import org.flixel.FlxPoint;
	
	public class Bullet extends Particle {
		public var _speed:Number;
		public var _angle:Number;
		public var _distance:Number;
		protected var _range:Number;
		protected var _damage:int;
		
		public function Bullet(x:Number = 0, y:Number = 0, ang:Number = 0, speed:Number = 5, damage:int = 0, range:Number = 1200) {
			super(x, y);
			
			this._speed = speed;
			this._angle = ang;
			this._distance = 0;
			this._range = range;
			this._damage = damage;
			this.angle = ang;
			
			this.loadGraphic(Imports.BULLET_ROUND);
		}
		
		public function update_bullet(game:GameEngine):void {
			this.x += _speed * Math.cos(_angle * Util.DEG2RAD);
			this.y += _speed * Math.sin(_angle * Util.DEG2RAD);
			_distance += _speed;
		}
		
		override public function should_remove():Boolean {
			return _distance >= _range;
		}
		
		public function get_damage():int {
			return _damage;
		}
	}
}