package core 
{
	import gameobj.Packet;
	import guns.*;
	import particles.Explosion;
	import org.flixel.*;
	/**
	 * 
	 * @author Wenrui (Donovan) Wu
	 */
	public class Scout extends Character
	{
		public var body:FlxSprite = new FlxSprite();
		public var limbs:FlxSprite = new FlxSprite();
		public var hitbox:FlxSprite = new FlxSprite();
		
		public var weapon:BulletEmitter = new BulletEmitter( { } );
		public var weapon_spr:FlxSprite = new FlxSprite();
		public var weapon_offset:FlxPoint = new FlxPoint();
		
		public var w1_lv:int;	// level for weapon 1
		public var w2_lv:int;	// level for weapon 2
		
		public const weaponMapping:Object = [["Hunting Rifle", "Sniper Rifle", "Railgun", "Anti-materiel Rifle"],
											["Handgun", "Machine Pistol", "Combat Shotgun", "AK47"]];
											
		public var weaponSlot:int = 0;
		public var reloading:Boolean = false;
		public var ammunition:Array = [ { mag: 1, ammo: 1 }, { mag: 1, ammo: 1 } ];
		public var init:Boolean = false;
		
		public var dead:Boolean = false;
		
		protected var exp:Array = [[75, 120, 450, false], [120, 210, 320, false]];
		
		// ai specs: more in super class
		private var _ct:int = 0;
		private var step:int = 0;
		private var wait:int = -1;
		public var waypoint:FlxPoint;
		
		public function Scout(x:Number = 0, y:Number = 0, w1lv:int = 0, w2lv:int = 0, human:Boolean = false) {
			// character data
			player_controlled = human;
			walkSpeed = 1.6;
			sprintSpeed = 2.5;
			w1_lv = w1lv;
			w2_lv = w2lv;
			max_hp = 240;
			regen_amount = 3;	// 45/s
			regen_wait = 100;	// 1.67s
			
			rotation_spd = 2;	// 120 degree/s
			
			if (!player_controlled) {
				// if it is AI, then pick a random gun
				w1_lv = Util.int_random(0, 2);
				w2_lv = Util.int_random(0, 3);
				shoot_span = Util.int_random(45, 75);
			}
			
			body.loadGraphic(Imports.SCOUT_BODY);
			
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
				stance = "hip";
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
			isMoving = false;
			
			if (_g == null) {
				return;
			}
			
			if (_g.player == null) {
				roam();
				return;
			}
			
			var player:Character = _g.player;
			stance = "hip";
			
			// _g.debug_text.text = step + "";
			
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
					var err_tol:Number = rotation_spd * 1.5;
					
					if (Math.abs(err) <= err_tol) {
						// aimed successfully
						// _g.debug_text.text = "aimed successfully";
						step++;
					} else {
						if (err >= 270) {
							ang = ang - 360;
						} else if (err <= -270 ) {
							ang = ang + 360;
						}
						var dtheta:Number = (goal_angle - ang) / 10;
						if (Math.abs(dtheta) < rotation_spd) dtheta = Util.sig_n(goal_angle - ang) * rotation_spd;
						ang += dtheta;
					}
					update_position();
					break;
					
				case 2:
					// shoot for some while
					stance = "aim";
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
						shoot_span += 3;
						
						_ct = 0;
						step = 3;
					}
					
					break;
					
				case 3:
					// choose to rest for a random while
					stance = "hip";
					if (wait < 0) {
						// initialize wait
						wait = Util.int_random(0, 4) * 20;
					}
					
					_ct++;
					if (_ct >= shoot_span) {
						_ct = 0;
						wait = -1;
						step++;
					}
					break;
					
				case 4:
					// randomly choose to switch gun
					var choice:int = Util.int_random(0, 3);
					if (choice == 0) {
						weaponSlot = 1 - weaponSlot;
						switch_weapon();
					}
					step++;
					
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
		
		override public function getWeaponLevel():Array {
			return [w1_lv, w2_lv];
		}
		
		// set up a random goal position, walk to it and returns whether the destination has been reached
		override public function roam(renew:Boolean = false):Boolean {
			// _g.debug_text.text = "roaming";
			
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
				isMoving = true;
				_ct++;
				
				var goal_angle:Number = Math.atan2(waypoint.y - this.y(), waypoint.x - this.x()) * Util.RAD2DEG;
				var err:Number = ang - goal_angle;
				var err_tol:Number = rotation_spd * 1.5;
				
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
				
				if (err <= err_tol ) {
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
		
		protected function init_ammunition(w:int = 0):void {
			var name1:String = weaponMapping[0][w1_lv];
			var name2:String = weaponMapping[1][w2_lv];
			
			var weapon1:BulletEmitter = Util.weapon_map_emitter(name1);
			var	weapon2:BulletEmitter = Util.weapon_map_emitter(name2);
			
			if (w != 2) {
				ammunition[0].mag = weapon1.gunstat.mag_size;
				ammunition[0].ammo = weapon1.gunstat.ammo;
			}
			if (w != 1) {
				ammunition[1].mag = weapon2.gunstat.mag_size;
				ammunition[1].ammo = weapon2.gunstat.ammo;
			}
		}
		
		override public function reloadOp():void {
			reloading = true;
			limbs.play("reload_" + weapon.type);
			FlxG.play(Imports.SOUND_RELOAD);
		}
		
		override public function getHitBox():FlxSprite {
			return hitbox;
		}
		
		override public function die():void {
			var explosion:Explosion = new Explosion(this.x(), this.y(), 0)
			_g._particles.add(explosion);
			explosion.explode();
			
			// spawn a corpse on stage
			// _g.corpses.add(new KnightCorpse(this.x(), this.y(), ang));
			_g.add_corpse(new ScoutCorpse(this.x(), this.y(), ang));
			
			if (!player_controlled) {
				if (_g.kills == 0) {
					// weapon 1 upgrade
					_g.packets.add(new Packet(this.x(), this.y(), 0));
				} else if (_g.kills == 1) {
					// weapon 2 upgrade
					_g.packets.add(new Packet(this.x(), this.y(), 1));
				} else {
					// randomly spawn a weapon upgrade
					var r:Number = Util.float_random(0, 100);
					if (r < 25) {
						// weapon 1 upgrade
						_g.packets.add(new Packet(this.x(), this.y(), 0));
					} else if (r > 75) {
						// weapon 2 upgrade
						_g.packets.add(new Packet(this.x(), this.y(), 1));
					}
				}
			}
			
			dead = true;
		}
		
		override public function gainExp(amount:int, which:int):void {
			// _g.debug_text.text = "xp gained!"
			
			FlxG.play(Imports.SOUND_SCORE);
			
			var w_lv:int = 0;
			if (which == 0) {
				w_lv = w1_lv;
			} else {
				w_lv = w2_lv;
			}
			
			if (exp[which][w_lv]) {
				exp[which][w_lv] -= amount;
				
				if (exp[which][w_lv] <= 0) {
					// upgrade!
					FlxG.play(Imports.SOUND_LEVELUP);
					if (which == 0) {
						w1_lv++;
						init_ammunition(1);
					} else {
						w2_lv++;
						init_ammunition(2);
					}
					weaponSlot = which;
					_g.update_progress(w1_lv, w2_lv, "scout");
					switch_weapon();
				}
			}
		}
		
		override public function should_remove():Boolean {
			return dead;
		}
	}

}