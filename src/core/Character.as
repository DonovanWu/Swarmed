package core 
{
	import guns.AssualtRifle;
	import guns.BulletEmitter;
	import misc.DamageGraph;
	import misc.FlxGroupSprite;
	import org.flixel.*;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class Character extends FlxGroupSprite
	{
		
		protected var _g:GameEngine;
		
		public var player_controlled:Boolean = false;
		// boolean alive
		
		// additional sprite info
		public var ang:Number = 0;	// angle for whole sprite in degree
		
		// movement mechanics
		public var moveSpeed:Number;
		protected var walkSpeed:Number = 3.0;
		protected var sprintSpeed:Number = 5.0;
		public var isMoving:Boolean = false;
		public var isSprinting:Boolean = false;
		public var stance:String = "hip";
		
		// character info
		public var hp:int;
		public var max_hp:int = 100;
		public var mobility:Number = 1.0;
		// public var weapons:Array = [];
		// public var weapon:BulletEmitter = new BulletEmitter({});
		
		public function Character() {
			moveSpeed = walkSpeed;
			hp = max_hp;
			// weapon = new AssualtRifle();
			// this.add(weapon);
		}
		
		public function update_character(game:GameEngine):void {
			_g = game;
			
			// update position
			if (player_controlled) {
				update_control();
			} else {
				update_ai();
			}
			
			update_weapon();
		}
		
		protected function update_control():void {
			if (_g == null) {
				return;
			}
			
			update_keyboard();
			update_mouse();
			
			update_position();
		}
		
		protected function update_keyboard():void {
			var bound:FlxPoint = new FlxPoint(Util.WID, Util.HEI);
			
			isMoving = false;
			isSprinting = false;
			
			if (Util.is_key(Util.MOVE_LEFT) && this.x() > 0) {
				this.x(-this.moveSpeed);
				isMoving = true;
				
			} else if (Util.is_key(Util.MOVE_RIGHT) && this.x() < bound.x) {
				this.x(this.moveSpeed);
				isMoving = true;
			} 
			
			if (Util.is_key(Util.MOVE_UP) && this.y() > 0) {
				this.y(-this.moveSpeed);
				isMoving = true;
				
			} else if (Util.is_key(Util.MOVE_DOWN) && this.y() < bound.y) {
				this.y(this.moveSpeed);
				isMoving = true;
			}
			
			if (Util.is_key(Util.MOVE_SPRINT)) {
				sprint();
				isSprinting = true;
				stance = "hip";
			} else {
				walk();
				isSprinting = false;
			}
			
			if (Util.is_key(Util.TOGGLE_AIM, true)) {
				if (stance != "aim") {
					stance = "aim";
					trace("changed stance to aim");
				} else {
					stance = "hip";
					trace("changed stance to hip");
				}
			}
			
			/*
			if (Util.is_key(Util.WEAPON_SWITCH, true)) {
				curr_weap = Util.key_index(Util.WEAPON_SWITCH);
				if (curr_weap > weapons.length - 1 || curr_weap < 0) {
					curr_weap = 0;
				}
				stance = "hip";
				trace("switched to weapon: " + weapons[curr_weap].name());
			}
			
			if (Util.is_key(Util.RELOAD, true)) {
				weapons[curr_weap].reload();
				trace("reload");
			}
			*/

		}
		
		protected function update_mouse():void {
			var dy:Number = FlxG.mouse.y - y();
			var dx:Number = FlxG.mouse.x - x();
			
			var dr:FlxPoint = line_up_with_muzzle(dx, dy);
			
			dy = dr.y;
			dx = dr.x;
			
			ang = Math.atan2(dy, dx) * Util.RAD2DEG;
		}
		
		override public function update_position():void {
			return;
		}
		
		public function walk():void {
			moveSpeed = walkSpeed * mobility;
			walkAnimation();
		}
		
		public function sprint():void {
			moveSpeed = sprintSpeed * mobility;
			sprintAnimation();
		}
		
		protected function walkAnimation():void {
			return;
		}
		
		protected function sprintAnimation():void {
			return;
		}
		
		protected function update_ai():void {
			if (_g == null) {
				return;
			}
			
			if (_g.player == null) {
				// roam?
			}
			
			// update AI
		}
		
		protected function update_weapon():void {
			return;
		}
		
		public function muzzle_position():FlxPoint {
			return new FlxPoint(x(), y());
		}
		
		public function getWeapon():BulletEmitter {
			return null;
		}
		
		protected function line_up_with_muzzle(dx:Number, dy:Number):FlxPoint {
			return new FlxPoint(dx, dy);
		}
	}

}