package misc {
	import org.flixel.FlxGroup;
	
	public class FlxGroupSprite extends FlxGroup {
		
		private var _x:Number = 0, _y:Number = 0;
		public function set_pos(x:Number,y:Number):FlxGroupSprite {
			_x = x; _y = y;
			update_position();
			return this;
		}
		public function x(dv:Number = 0):Number { if (dv!=0){_x = _x + dv;update_position();} return _x; }
		public function y(dv:Number = 0):Number { if (dv!=0){_y = _y + dv;update_position();} return _y; }
		
		public function update_position():void {}
		
	}

}