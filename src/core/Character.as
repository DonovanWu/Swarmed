package core 
{
	import guns.AssualtRifle;
	import guns.BulletEmitter;
	import misc.FlxGroupSprite;
	import org.flixel.*;
	import particles.SprintShadow;
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
		public var giant:Boolean = false;		// giant characters should not be affected by roadblocks
		
		// health regen
		protected var regen_rate:int = 4;		// 15 times/s
		protected var regen_amount:int = 3;		// 45 /s
		protected var regen_wait:int = 150;		// 2.5s
		protected var regen_wait_ctdown:int = 180;
		protected var regen_ct:int = 0;
		
		// ai specs
		public var rotation_spd:Number = 2;		// 120 degree / s
		public var ai_trigger:int = 15;	// 240 RPM
		public var aim_shoot:Boolean = false;
		public var shoot_span:int = 60;
		public var shoot_p:Boolean = false;
		public var shoot_jp:Boolean = false;
		
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
				update_health_regen();
			} else {
				// ai has no health regen!
				update_ai();
			}
			
			update_weapon();
			
			if (hp <= 0) {
				die();
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
			var bound:FlxPoint = _g.bounds;
			
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
			
			if (isSprinting && isMoving) {
				// spawn sprint shadow
				_g._particles.add(new SprintShadow(this));
			}
			
			weapon_control();
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
		
		protected function update_ai():void {
			return;
		}
		
		protected function update_health_regen():void {
			if (hp < max_hp && hp > 0) {
				// start wait timer
				if (regen_wait_ctdown > 0) {
					regen_wait_ctdown--;
				} else {
					// regen wait count down reached!
					if (regen_ct % regen_rate == 0) {
						regain_health(regen_amount);
					}
					regen_ct++;
				}
			} else {
				// practically: hp = max_hp or hp = 0
				reset_regen_timer();
			}
		}
		
		public function take_damage(pt:int):void {
			reset_regen_timer();
			hp -= pt;
			if (hp < 0) {
				hp = 0;
			}
		}
		
		public function regain_health(pt:int):void {
			hp += pt;
			if (hp > max_hp) {
				hp = max_hp;
			}
		}
		
		protected function reset_regen_timer():void {
			regen_wait_ctdown = regen_wait;
			regen_ct = 0;
		}
		
		/*
		 * "Blue print" section!
		 */
		
		public function walkAnimation():void {
			return;
		}
		
		public function sprintAnimation():void {
			return;
		}
		
		public function roam(renew:Boolean = false):Boolean {
			return false;
		}
		
		public function reloadOp():void {
			return;
		}
		
		protected function update_weapon():void {
			return;
		}
		
		public function weapon_control():void {
			return;
		}
		
		public function muzzle_position():FlxPoint {
			return new FlxPoint(x(), y());
		}
		
		public function getWeapon():BulletEmitter {
			return null;
		}
		
		public function getWeaponMapStat():Array {
			return [];
		}
		
		public function getWeaponLevel():Array {
			return [];
		}
		
		public function getHitBox():FlxSprite {
			return null;
		}
		
		public function gainExp(amount:int, which:int):void {
			return;
		}
		
		public function die():void {
			return;
		}
		
		protected function line_up_with_muzzle(dx:Number, dy:Number):FlxPoint {
			return new FlxPoint(dx, dy);
		}
		
		public function should_remove():Boolean {
			return false;
		}
	}

}