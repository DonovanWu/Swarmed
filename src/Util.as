package  {
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import org.flixel.*;
	import flash.geom.*;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	// import particles.Bullet;
	
	public class Util {
		// Game Settings
		public static var WID:Number = 640;
		public static var HEI:Number = 640;
		
		// Keyboard Settings
		public static var MOVE_LEFT:Vector.<String> = Vector.<String>(["A","LEFT"]);
		public static var MOVE_RIGHT:Vector.<String> = Vector.<String>(["D","RIGHT"]);
		public static var MOVE_UP:Vector.<String> = Vector.<String>(["W", "UP"]);
		public static var MOVE_DOWN:Vector.<String> = Vector.<String>(["S", "DOWN"]);
		public static var MOVE_SPRINT:Vector.<String> = Vector.<String>(["SHIFT"]);
		public static var TOGGLE_AIM:Vector.<String> = Vector.<String>(["SPACE"]);
		public static var SELECT_FIRE:Vector.<String> = Vector.<String>(["F"]);
		public static var RELOAD:Vector.<String> = Vector.<String>(["R"]);
		
		public static var WEAPON_SWITCH:Vector.<String> = Vector.<String>(["ONE", "TWO", "THREE", "FOUR", "FIVE", "SIX"]);	
		
		// In-game Settings
		public static var TUTOR_TIMER:int = 300;
		
		// Math
		public static const RAD2DEG:Number = 180 / Math.PI;
		public static const DEG2RAD:Number = Math.PI / 180;
		
		public static function float_random(min:Number, max:Number):Number {
			return min + Math.random() * (max - min);
		}
		
		public static function int_random(min:int, max:int):int {
			return Math.floor(float_random(min,max)) as int;
		}
		
		public static function is_key(k:Vector.<String>,jp:Boolean=false):Boolean {
			for each (var i:String in k) {
				if (jp) {
					if (FlxG.keys.justPressed(i)) {
						return true;
					}
				} else {
 					if (FlxG.keys[i]) {
						return true;
					}
				}
			}
			return false;
		}
		
		// returns the index of the key pressed in the list given; default is justPressed
		// if the key isn't in the list, returns -1
		public static function key_index(k:Vector.<String>, jp:Boolean = true):int {
			var i:int = 0;
			for each (var key:String in k) {
				if (jp) {
					if (FlxG.keys.justPressed(key)) {
						return i;
					}
				} else {
 					if (FlxG.keys[key]) {
						return i;
					}
				}
				i++;
			}
			return -1;
		}
		
		public static function get_bounds(game_obj:FlxGroup):Rectangle {
			var o:Object;
			for each (var s:FlxSprite in game_obj.members) {
				if (!o) {
					o = new Object;
					o.min_x = s.x;
					o.min_y = s.y;
					o.max_x = s.x + s.width;
					o.max_y = s.y + s.height;
				} else {
					o.min_x = Math.min(s.x,o.min_x);
					o.min_y = Math.min(s.y,o.min_y);
					o.max_x = Math.max(s.x + s.width,o.max_x);
					o.max_y = Math.max(s.y + s.height,o.max_y);
				}
			}
			return new Rectangle(o.min_x, o.min_y, o.max_x - o.min_x, o.max_y - o.min_y);
		}
		
		public static function sig_n(chk:Number,val:Number=1):Number {
			if (chk < 0) {
				return -val;
			} else if (chk > 0) {
				return val;
			} else {
				return val;
			}
		}
		
		public static function distance(a:FlxObject,b:FlxObject):Number {
			return point_dist(a.x, a.y, b.x, b.y);
		}
		
		public static function point_dist(ax:Number, ay:Number, bx:Number, by:Number):Number {
			return Math.sqrt(Math.pow(by - ay, 2) + Math.pow(bx - ax, 2));
		}
		
		private static var _cur_song:Sound;
		private static var _cur_play:SoundChannel;
		public static function play_bgm(o:Sound):void {
			if (_mute) {
				_cur_song = o;
				return;
			}
			if (o != _cur_song) {
				_cur_song = o;
				if (_cur_song != null && _cur_play != null ) _cur_play.stop();
				_cur_play = _cur_song.play(0, int.MAX_VALUE);
			}
		}
		
		private static var _mute:Boolean = false;
		public static function mute_toggle():void {
			_mute = !_mute;
			FlxG.mute = _mute;
			if (_mute && _cur_play != null) {
				_cur_play.stop();
			} else if (!_mute && _cur_song != null) {
				_cur_play = _cur_song.play(0, int.MAX_VALUE);
			}
			
		}
		
		// ang is in radian
		public static function calibrate_pos(x:Number, y:Number, dx:Number, dy:Number, ang:Number):FlxPoint {
			var theta:Number = Math.atan2(dy, dx) + ang;
			var dr:Number = Math.sqrt(dx * dx + dy * dy);
			var new_x:Number = x + dr * Math.cos(theta);
			var new_y:Number = y + dr * Math.sin(theta);
			
			return new FlxPoint(new_x, new_y);
		}
		
		// ang is in radian; do this if you want to match up with center at left end of the sprite
		public static function repos2ctr(spr:FlxSprite, pos:FlxPoint, ang:Number):FlxPoint {
			var x:Number = pos.x + Math.sin(ang) * spr.height / 2;
			var y:Number = pos.y - Math.cos(ang) * spr.height / 2;
			
			return new FlxPoint(x, y);
		}
		
		public static function nextInt(min:int, max:int, curr:int):int {
			var nxt:int = curr + 1;
			if (nxt > max) {
				return min;
			} else {
				return nxt;
			}
		}
		
		public static function multi_trace(args:Array, names:Array, br:Boolean = false):void {
			var text:String = "";
			if (args != null && names != null && args.length == names.length) {
				for (var i:int = 0; i < args.length; i++ ) {
					text += names[i] + ": " + args[i];
					if (br) {
						text += "\n";
					} else {
						text += "; ";
					}
				}
			} else {
				text = "Input Error: null arguments and/or names or inputs' length doesn't match.";
			}
			trace(text);
		}
		
		// rotate a sprite in respect to its left end, ang should be in radian
		public static function rotate(spr:FlxSprite, ang:Number):void {
			spr.x -= spr.width / 2 * (1 - Math.cos(ang));
			spr.y += spr.width / 2 * Math.sin(ang);
			spr.angle = ang * RAD2DEG;
		}
		
		public static function is_out_of_bound(spr:FlxSprite, bound:FlxPoint):Boolean {
			return spr.x < 0 || spr.x > bound.x || spr.y < 0 || spr.y > bound.y;
		}
	}

}