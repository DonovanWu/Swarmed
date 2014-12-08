package particles {
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Explosion extends Particle {
		private var _delay:Number;
		private var _ct:Number;
		public var _explode:Boolean;
		public const BOOM:String = "BOOM";
		
		public function Explosion(x:Number = 0, y:Number = 0, delay:Number = 0) {
			this.loadGraphic(Imports.IMPORT_EXPLOSION, true, false, 60, 60);
			this.addAnimation(BOOM, [0, 1, 2, 3, 4, 5, 6, 7], 12, false);
			this.scale.x = 2;
			this.scale.y = 2.4;
			this.alpha = 0.8;
			this.set_position(x, y);
			this.visible = false;
			this._delay = delay;
			this._ct = 0;
			this._explode = false;
		}
		
		public function explode():void {
			_explode = true;
		}
		
		override public function update_particle(game:GameEngine):void {
			if (_ct > _delay) {
				this.visible = true;
				this.play(BOOM);
				FlxG.play(Imports.SOUND_EXPLOSION, 4);
				FlxG.camera.shake(0.02);
				_ct = 0;
				_explode = false;
			} else if (_explode) {
				_ct++;
			}
		}
		
		override public function should_remove():Boolean {
			return this.finished;
		}
		
		public function set_location(x:Number, y:Number):Explosion {
			this.set_position(x, y);
			return this;
		}
	}

}