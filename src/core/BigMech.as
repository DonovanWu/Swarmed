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
	public class BigMech extends Character
	{
		public var body:FlxSprite = new FlxSprite();
		public var limbs:FlxSprite = new FlxSprite();
		public var hitbox:FlxSprite = new FlxSprite();
		
		public var weapon1:BulletEmitter = new BulletEmitter( { } );
		public var weapon2:BulletEmitter = new BulletEmitter( { } );
		public var weapon3:BulletEmitter = new BulletEmitter( { } );
		public var weapon_offset1:FlxPoint = new FlxPoint();
		public var weapon_offset2:FlxPoint = new FlxPoint();
		public var weapon_offset3:FlxPoint = new FlxPoint();
		
		public var w1_lv:int;	// level for weapon 1
		public var w2_lv:int;	// level for weapon 2
		
		public const weaponMapping:Object = [["Light Machine Gun"],
											["RocketLauncher"]];
											
		public var weaponSlot:int = 0;
		public var reloading:Boolean = false;
		public var ammunition:Array = [ { mag: 1, ammo: 1 }, { mag: 1, ammo: 1 } ];
		public var init:Boolean = false;
		
		private var reload_time:int = 120;
		private var ct_reload_time:int = 0;
		
		public var dead:Boolean = false;
		
		protected var exp:Array = [[false], [false]];
		
		// ai specs: more in super class
		private var _ct:int = 0;
		private var step:int = 0;
		private var wait:int = -1;
		public var waypoint:FlxPoint;
		
		public function BigMech(x:Number = 0, y:Number = 0, w1lv:int = 0, w2lv:int = 0, human:Boolean = false) {
			// character data
			player_controlled = human;
			walkSpeed = 1.0;
			sprintSpeed = 1.2;
			w1_lv = w1lv;
			w2_lv = w2lv;
			max_hp = 1500;
			regen_amount = 0;
			giant = true;
			
			if (!player_controlled) {
				shoot_span = Util.int_random(45, 75);
			}
			
			body.loadGraphic(Imports.BIGMECH_BODY);
			limbs.visible = false;
			
			hitbox.loadGraphic(Imports.IMPORT_HITBOX_80x80);
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
			
			this.add(weapon1);
			this.add(weapon2);
			this.add(weapon3);
		}
		
		override public function update_position():void {
			body.set_position(x() - body.width / 2, y() - body.height / 2);
			hitbox.set_position(x() - hitbox.width / 2 + 10, y() - hitbox.height / 2);
			limbs.set_position(body.x, body.y);
			
			body.angle = ang;
			hitbox.angle = ang;
			limbs.angle = ang;
			
			update_mobility();
			// update_limb_anim();
		}
		
		override protected function update_weapon():void {
			if (reloading) {
				stance = "hip";
				ct_reload_time++;
				if (ct_reload_time >= reload_time) {
					ct_reload_time = 0;
					if (weaponSlot == 0) {
						weapon1.reload();
						weapon2.reload();
					} else {
						weapon3.reload();
					}
					reloading = false;
				}
			} else {
				if (weaponSlot == 0) {
					weapon1.update_emitter(_g, this);
					weapon2.update_emitter(_g, this);
				} else {
					weapon3.update_emitter(_g, this);
				}
			}
		}
		
		protected function update_mobility():void {
			if (stance == "hip") {
				mobility = weapon1.mobility;
			} else {	// aim
				mobility = weapon1.mobility * weapon1.ads_multi;
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
						ang += dtheta;
					}
					update_position();
					break;
					
				case 2:
					// shoot for some while
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
					
					// _g.debug_text.text = _ct + "";
					
					break;
					
				case 3:
					// choose to rest for a random while
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
			
			var weapon:BulletEmitter;
			if (weaponSlot == 0) {
				weapon = weapon1;
			} else {
				weapon = weapon2;
			}
			
			if (Util.is_key(Util.RELOAD, true) && weapon.needReload()) {
				// toggle reload
				reloadOp();
			}
		}
		
		protected function update_ammunition():void {
			var weapon:BulletEmitter;
			if (weaponSlot == 0) {
				weapon = weapon1;
			} else {
				weapon = weapon3;
			}
			
			ammunition[weaponSlot].mag = weapon.mag;
			ammunition[weaponSlot].ammo = weapon.ammo;
		}
		
		override public function getWeapon():BulletEmitter {
			if (weaponSlot == 0) {
				return weapon1;
			} else {
				return weapon3;
			}
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
			return new FlxPoint(dx, dy);
		}
		
		override public function muzzle_position():FlxPoint {
			var dx:Number = weapon_offset3.x;
			var dy:Number = weapon_offset3.y;
			
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
			
			weapon1 = Util.weapon_map_emitter("Light Machine Gun");
			weapon2 = Util.weapon_map_emitter("Light Machine Gun");
			weapon3 = Util.weapon_map_emitter("Rocket Launcher");
			weapon1.setAmmo(ammunition[0].ammo, ammunition[0].mag);
			weapon3.setAmmo(ammunition[1].ammo, ammunition[1].mag);
			
			/*
			weapon1.setMuzzlePosInfo(Util.calibrate_pos(x(), y(), weapon_offset1.x, weapon_offset1.y, ang*Util.DEG2RAD));
			weapon2.setMuzzlePosInfo(Util.calibrate_pos(x(), y(), weapon_offset2.x, weapon_offset2.y, ang*Util.DEG2RAD));
			*/
			weapon1.setMuzzlePosInfo(weapon_offset1);
			weapon2.setMuzzlePosInfo(weapon_offset2);
			
			weapon_offset1 = weapon_offset1.make(64, -10);
			weapon_offset2 = weapon_offset2.make(64, 10);
			weapon_offset3 = weapon_offset3.make(80, 0);
		}
		
		protected function init_ammunition():void {
			var name1:String = "Light Machine Gun";
			var name2:String = "Rocket Launcher";
			
			var weapon1:BulletEmitter = Util.weapon_map_emitter(name1);
			var weapon2:BulletEmitter = Util.weapon_map_emitter(name1);
			var	weapon3:BulletEmitter = Util.weapon_map_emitter(name2);
			
			ammunition[0].mag = weapon1.gunstat.mag_size;
			ammunition[0].ammo = weapon1.gunstat.ammo;
			ammunition[1].mag = weapon3.gunstat.mag_size;
			ammunition[1].ammo = weapon3.gunstat.ammo;
		}
		
		override public function reloadOp():void {
			reloading = true;
		}
		
		override public function getHitBox():FlxSprite {
			return hitbox;
		}
		
		override public function die():void {
			var explosion:Explosion = new Explosion(this.x(), this.y(), 0)
			_g._particles.add(explosion);
			explosion.explode();
			
			// only 25 percent chance to spawn corpse on stage
			if (Util.int_random(0,3) == 0) {
				_g.corpses.add(new BigMechCorpse(this.x(), this.y(), this.ang));
			}
			
			if (!player_controlled) {
				// big mech gives an ammo pack
				_g.packets.add(new Packet(this.x(), this.y(), 2));
			}
			
			dead = true;
		}
		
		override public function gainExp(amount:int, which:int):void {
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
					if (which == 0) {
						w1_lv++;
					} else {
						w2_lv++;
					}
					weaponSlot = which;
					switch_weapon();
				}
			}
		}
		
		override public function should_remove():Boolean {
			return dead;
		}
	}

}