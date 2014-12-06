package core 
{
	import misc.FlxGroupSprite;
	import org.flixel.*;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class Character extends FlxGroupSprite
	{
		/*
		public var body:FlxSprite = new FlxSprite();
		public var limbs:FlxSprite = new FlxSprite();
		public var hitbox:FlxSprite = new FlxSprite();
		*/
		
		private var _g:GameEngine;
		
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
		public var stance:int = 0;	// 0 for hip, 1 for aim
		
		// item info
		public var weapons:Array = [];
		
		public function Character() {
			moveSpeed = walkSpeed;
		}
		
		public function update_character(game:GameEngine):void {
			_g = game;
			
			if (player_controlled) {
				update_control();
			} else {
				update_ai();
			}
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
				stance = 0;
			} else {
				walk();
				isSprinting = false;
			}
			
			if (Util.is_key(Util.TOGGLE_AIM, true)) {
				if (stance != 1) {
					stance = 1;	// aim
					trace("changed stance to aim");
				} else {
					stance = 0;	// hip
					trace("changed stance to hip");
				}
			}
			
			/*
			if (Util.is_key(Util.WEAPON_SWITCH, true)) {
				curr_weap = Util.key_index(Util.WEAPON_SWITCH);
				if (curr_weap > weapons.length - 1 || curr_weap < 0) {
					curr_weap = 0;
				}
				stance = 0;
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
			/*
			if (dy*dy + dx*dx > _weap_off.x*_weap_off.x + _weap_off.y*_weap_off.y) {
				// spin-prevented match-up to muzzle position
				dy = FlxG.mouse.y - _weap_pos.y;
				dx = FlxG.mouse.x - _weap_pos.x;
			}
			*/
			
			ang = Math.atan2(dy, dx) * Util.RAD2DEG;
		}
		
		override public function update_position():void {
			
		}
		
		public function walk():void {
			moveSpeed = walkSpeed; // * weapon.mobility();
			toggleWalkAnimation();
		}
		
		public function sprint():void {
			moveSpeed = sprintSpeed; // * weapon.mobility();
			toggleSprintAnimation();
		}
		
		protected function toggleWalkAnimation():void {
			return;
		}
		
		protected function toggleSprintAnimation():void {
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
	}

}