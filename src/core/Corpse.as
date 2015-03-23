package core 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import particles.Ripple;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class Corpse extends FlxSprite
	{
		protected var _g:GameEngine;
		public var name:String = "";
		public var _x:Number;
		public var _y:Number;
		
		public function Corpse(x:Number, y:Number, ang:Number) 
		{
			super(x, y);
			this.angle = ang;
			
			_x = x;
			_y = y;
		}
		
		public function update_corpse(game:GameEngine):void {
			_g = game;
			
			if (_g.game_status == "title") {
				FlxG.overlap(this, _g.reticle, function(corse:FlxSprite, reticle:FlxSprite):void {
					if (FlxG.mouse.justPressed()) {
						revive_robot();
						_g.game_status = "in-game";
					}
				});
			}
		}
		
		public function revive_robot():void {
			// add ripple as a particle
			_g._particles.add(new Ripple(this._x, this._y));
		}
		
	}

}