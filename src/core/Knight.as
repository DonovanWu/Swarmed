package core 
{
	import guns.*;
	import org.flixel.*;
	/**
	 * This character can be only player-controlled
	 * @author Wenrui (Donovan) Wu
	 */
	public class Knight extends Character
	{
		public var body:FlxSprite = new FlxSprite();
		public var limbs:FlxSprite = new FlxSprite();
		public var hitbox:FlxSprite = new FlxSprite();
		
		public var weapon:BulletEmitter = new BulletEmitter( { } );
		public var weapon_spr:FlxSprite = new FlxSprite();
		public var weapon_offset:FlxPoint = new FlxPoint();
		
		public var w1_lv:int;	// level for weapon 1
		public var w2_lv:int;	// level for weapon 2
		
		public var w1_exp:int;
		public var w2_exp:int;
		
		/*
		private const weaponMapping:Object = { w1: ["Revolver", "Marksman Rifle", "Assualt Rifle"],
												w2: ["Handgun", "Machine Pistol", "Submachine Gun"]};
												*/
		public const weaponMapping:Array = [["Assualt Rifle", "Revolver", "Marksman Rifle"],
											["Double Barrel", "Handgun", "Submachine Gun"]];
		public var weaponSlot:int = 0;
		public var reloading:Boolean = false;
		public static var ammunition:Array = [ { mag: 1, ammo: 1 }, { mag: 1, ammo: 1 } ];
		public static var init:Boolean = false;
		
		public var dead:Boolean = false;
		
		protected var exp:Array = [[100, 200, false], [100, 200, false]];
		
		// ai specs: more in super class
		private var _ct:int = 0;
		private var step:int = 0;
		public var waypoint:FlxPoint;
		
		public function Knight(x:Number = 0, y:Number = 0, w1lv:int = 0, w2lv:int = 0, human:Boolean = false) {
			// character data
			player_controlled = human;
			walkSpeed = 1.5;
			sprintSpeed = 2.5;
			w1_lv = w1lv;
			w2_lv = w2lv;
			max_hp = 200;
			w1_exp = 0;
			w2_exp = 0;
			
			if (!player_controlled) {
				// if it is AI, then pick a random gun
				w1_lv = Util.int_random(0, 2);
				w2_lv = Util.int_random(0, 2);
				shoot_span = Util.int_random(45, 75);
			}
			
			body.loadGraphic(Imports.KNIGHT_BODY);
			
			limbs.loadGraphic(Imports.KNIGHT_LIMBS, true, false, 60, 45);
			limbs.origin.x = body.width / 2;
			limbs.origin.y = body.height / 2;
			limbs.addAnimation("reload_rifle", Util.consecutive_num(2, 14), 12, false);
			limbs.addAnimation("reload_pistol", Util.consecutive_num(15, 19), 10, false);
			
			hitbox.loadGraphic(Imports.IMPORT_HITBOX_25x30);
			hitbox.alpha = 0.3;
			hitbox.visible = false;
			
			if (!init) {
				init_ammunition();
				init = true;
			}
			
			this.add(limbs);
			add_weapons();
			this.add(body);
			this.add(hitbox);
			
			this.set_pos(x, y);
			
			// super code:
			moveSpeed = walkSpeed;
			hp = max_hp;
		}
		
		protected function add_weapons():void {
			// add weapons, corresponding bullet emitters and offset info
			switch_weapon();
			
			this.add(weapon);
			this.add(weapon_spr);
		}
		
		override public function update_position():void {
			body.set_position(x() - body.width / 2, y() - body.height / 2);
			hitbox.set_position(x() - hitbox.width / 2, y() - hitbox.height / 2);
			limbs.set_position(body.x, body.y);
			
			body.angle = ang;
			hitbox.angle = ang;
			limbs.angle = ang;
			
			// weapon position
			var wo_x:Number = weapon_offset.x;
			var wo_y:Number = weapon_offset.y;
			var weap_pos:FlxPoint = Util.calibrate_pos(x(), y(), wo_x, wo_y, ang * Util.DEG2RAD);
			weapon_spr.set_position(weap_pos.x, weap_pos.y);
			weapon_spr.angle = ang;
			
			update_mobility();
			// update_limb_anim();
		}
		
		override protected function update_weapon():void {
			if (reloading) {
				if (limbs.finished) {
					weapon.reload();
					limbs.finished = false;
					reloading = false;
				}
			} else {
				weapon.update_emitter(_g, this);
			}
		}
		
		protected function update_mobility():void {
			if (stance == "hip") {
				mobility = weapon.mobility;
			} else {	// aim
				mobility = weapon.mobility * weapon.ads_multi;
			}
		}
		
		override protected function update_ai():void {
			if (_g == null) {
				return;
			}
			
			if (_g.player == null) {
				roam();
				return;
			}
			
			var player:Character = _g.player;
			stance = "hip";
			
			// update AI
			switch(step) {
				case 0:
					// roam to a new position
					var reached:Boolean = roam();
					if (reached) {
						step++;
					}
					break;
					
				case 1:
					// aim to player: temporarily non-constant-speed rotation
					var goal_angle:Number = Math.atan2(player.y() - this.y(), player.x() - this.x()) * Util.RAD2DEG;
					var err:Number = ang - goal_angle;
					var err_tol:Number = rotation_spd * 1.2;
					
					if (Math.abs(err) <= err_tol) {
						// aimed successfully
						_g.debug_text.text = "aimed successfully";
						step++;
					} else {
						if (err >= 270) {
							ang = ang - 360;
						} else if (err <= -270 ) {
							ang = ang + 360;
						}
						var dtheta:Number = (goal_angle - ang) / 10;
						ang += dtheta;
					}
					update_position();
					break;
					
				case 2:
					// shoot for some while
					_g.debug_text.text = "shooting";
					_ct++;
					if (_ct <= shoot_span) {
						shoot_p = true;
						if (_ct % ai_trigger == 0) {
							shoot_jp = true;
						} else {
							shoot_jp = false;
						}
					} else {
						shoot_p = false;
						shoot_jp = false;
						
						_ct = 0;
						step = 0;
					}
					
					break;
					
				default:
					step = 0;
					break;
			}
		}
		
		override public function weapon_control():void {
			if (Util.is_key(Util.WEAPON_SWITCH, true) && !reloading) {
				var index:int = Util.key_index(Util.WEAPON_SWITCH);
				
				if (index != weaponSlot) {
					update_ammunition();
					weaponSlot = index;
					switch_weapon();
				}
			}
			
			if (Util.is_key(Util.RELOAD, true) && weapon.needReload()) {
				// toggle reload
				reloadOp();
			}
		}
		
		protected function update_ammunition():void {
			ammunition[weaponSlot].mag = weapon.mag;
			ammunition[weaponSlot].ammo = weapon.ammo;
		}
		
		override public function getWeapon():BulletEmitter {
			return weapon;
		}
		
		// set up a random goal position, walk to it and returns whether the destination has been reached
		override public function roam(renew:Boolean = false):Boolean {
			_g.debug_text.text = "roaming";
			
			if (renew) {
				waypoint = null;
			}
			
			shoot_p = false;
			shoot_jp = false;
			
			if (waypoint == null) {
				// make new waypoint
				waypoint = new FlxPoint(Util.int_random(100, 540), Util.int_random(100, 540));
				return false;
			} else {
				_ct++;
				
				var goal_angle:Number = Math.atan2(waypoint.y - this.y(), waypoint.x - this.x()) * Util.RAD2DEG;
				var err:Number = ang - goal_angle;
				var err_tol:Number = rotation_spd * 1.2;
				
				if (Math.abs(err) > err_tol) {
					if (err > 0) {
						// ang > goal_angle
						ang -= rotation_spd;
					} else {
						ang += rotation_spd;
					}
				}
				
				goal_angle = goal_angle * Util.DEG2RAD;
				var vx:Number = Math.cos(goal_angle) * moveSpeed;
				var vy:Number = Math.sin(goal_angle) * moveSpeed;
				this.x(vx);
				this.y(vy);
				
				err = Util.point_dist(waypoint.x, waypoint.y, this.x(), this.y());
				err_tol = 5;
				
				if (err <= err_tol || _ct > 300 ) {
					_ct = 0;
					waypoint = null;
					return true;
				} else {
					return false;
				}
			}
		}
		
		override protected function line_up_with_muzzle(dx:Number, dy:Number):FlxPoint {
			var wo_x:Number = weapon_offset.x;
			var wo_y:Number = weapon_offset.y;
			
			if (dy*dy + dx*dx > wo_x * wo_x + wo_y * wo_y) {
				// spin-prevented match-up to muzzle position
				var weap_pos:FlxPoint = Util.calibrate_pos(x(), y(), wo_x, wo_y, ang*Util.DEG2RAD);
				dy = FlxG.mouse.y - weap_pos.y;
				dx = FlxG.mouse.x - weap_pos.x;
			}
			
			return new FlxPoint(dx, dy);
		}
		
		override public function muzzle_position():FlxPoint {
			var dx:Number = weapon_offset.x + weapon_spr.width;
			var dy:Number = weapon_offset.y + weapon_spr.height / 2;
			
			return Util.calibrate_pos(x(), y(), dx, dy, ang*Util.DEG2RAD);
		}
		
		private function switch_weapon():void {
			stance = "hip";
			
			var name:String = "";
			if (weaponSlot == 0) {
				name = weaponMapping[0][w1_lv];
			} else {	// weaponSlot = 1
				name = weaponMapping[1][w2_lv];
			}
			
			weapon = Util.weapon_map_emitter(name);
			weapon.setAmmo(ammunition[weaponSlot].ammo, ammunition[weaponSlot].mag);
			
			/*
			var ammunition:Object = _g.ammunition[weaponSlot];
			weapon = Util.weapon_map_emitter(name);
			weapon.setAmmo(ammunition.ammo, ammunition.mag);
			*/
			
			weapon_spr.loadGraphic(Util.weapon_map_import(name));
			weapon_spr.setOriginToCorner();
			
			weapon_offset = weapon_offset.make( -3, 9);
			limbs.frame = 0;
			
			if (weapon.type == "pistol") {
				weapon_offset = weapon_offset.make(25, 6);
				limbs.frame = 1;
			}
		}
		
		protected function init_ammunition():void {
			var name1:String = weaponMapping[0][w1_lv];
			var name2:String = weaponMapping[1][w2_lv];
			
			var weapon1:BulletEmitter = Util.weapon_map_emitter(name1);
			var	weapon2:BulletEmitter = Util.weapon_map_emitter(name2);
			
			ammunition[0].mag = weapon1.gunstat.mag_size;
			ammunition[0].ammo = weapon1.gunstat.ammo;
			ammunition[1].mag = weapon2.gunstat.mag_size;
			ammunition[1].ammo = weapon2.gunstat.ammo;
		}
		
		override public function reloadOp():void {
			reloading = true;
			limbs.play("reload_" + weapon.type);
		}
		
		override public function getHitBox():FlxSprite {
			return hitbox;
		}
		
		override public function die():void {
			// spawn a corpse on stage
			
			if (!player_controlled) {
				// randomly spawn a weapon upgrade
				var r:Number = Util.float_random(0, 100);
				if (r > 90) {
					// weapon 1 upgrade
				} else if (r < 10) {
					// weapon 2 upgrade
				}
			}
			
			dead = true;
		}
		
		public function gainExp1(amount:int):void {
			w1_exp += amount;
			if (exp[0][w1_lv] && w1_exp > exp[0][w1_lv]) {
				// upgrade!
				
			}
		}
		
		public function gainExp2(amount:int):void {
			return;
		}
		
		override public function should_remove():Boolean {
			return dead;
		}
	}

}