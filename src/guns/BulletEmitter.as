package guns 
{
	import core.Character;
	import org.flixel.*;
	import particles.Bullet;
	import particles.Torpedo;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class BulletEmitter extends FlxSprite
	{
		private var _g:GameEngine;
		private var _ch:Character;
		
		public var name:String = "";
		public var damage:int = 0;
		public var mobility:Number = 1;
		public var ads_multi:Number = 1;
		public var type:String = "rifle";
		
		public var gunstat:Object;
		
		protected var pellets:int;
		public var mag:int = 1;			// bullet left in magazine
		protected var mag_size:int;		// magazine size: set to 0 or negative for inf ammo
		public var ammo:int = 1;			// total ammo this gun has
		
		protected var bullet_spd:Number;
		protected var orpm:Number;
		protected var brpm:Number;
		
		private var ct_orpm:Number;
		private var ct_brpm:Number;
		private var ct_burst:int;
		private var burst:int;
		
		public function BulletEmitter(stat:Object) 
		{
			this.visible = false;
			
			gunstat = stat;
			
			burst = gunstat.burst;
			
			mag_size = gunstat.mag_size;
			mag = mag_size;
			ammo = gunstat.ammo;		// all ammo, i.e. in-mag ammo + backup ammo
			
			orpm = convertRPM(gunstat.orpm);
			if (orpm < 1) {
				orpm = 1;
			}
			if (gunstat.brpm != null) {
				brpm = convertRPM(gunstat.brpm);
				if (brpm < 1) {
					brpm = 1;
				}
			} else {
				brpm = orpm;
			}
			
			// frequently used stats
			bullet_spd = gunstat.speed;
			pellets = gunstat.pellets;
			damage = gunstat.damage;
			mobility = gunstat.mobility;
			ads_multi = gunstat.ads_multi;
			name = gunstat.name;
			if (gunstat.type != null) {
				type = gunstat.type;
			}
			
			reset_gun();
		}
		
		public function update_emitter(game:GameEngine, char:Character):void {
			_g = game;
			_ch = char;
			
			if (triggered()) {
				
				if (burst != 0 && ct_orpm >= orpm) ct_orpm -= orpm;
				
				if (mag > 0) {
					if (ct_brpm >= brpm) {
						ct_brpm -= brpm;
						decr_ammo();
						if (burst != 0) ct_burst++;
						
						
						if (name == "Rocket Launcher") {
							FlxG.play(Imports.SOUND_LAUNCHER);
						} else if (name == "Hunting Rifle" || name == "Sniper Rifle" || name == "Railgun" || name == "Anti-materiel Rifle") {
							FlxG.play(Imports.SOUND_SHOOT_3);
						} else {
							FlxG.play(Imports.SOUND_SHOOT_3);
						}
						
						for (var i:int = 1; i <= pellets; i++) {
							spawn_bullet();
						}
					}
					ct_orpm++;
					ct_brpm++;
				} // end if mag > 0
			} else {
				// capping the rpm
				if (ct_brpm < brpm) {
					ct_brpm++;
				} else {
					ct_brpm = brpm;
				}
				
				if (burst != 0) {
					if (ct_orpm < orpm) {
						ct_orpm++;
					} else {
						ct_orpm = orpm;
					}
				}
			}
			
			if (ct_burst >= Math.abs(burst) && ct_orpm >= orpm) ct_burst = 0;
			
			if (mag <= 0 && backup_ammo() > 0) {
				_ch.reloadOp();
			}
		}
		
		// differentiates types of triggering
		private function triggered():Boolean {
			if (_ch.isSprinting) return false;
			
			var p:Boolean = false;
			var jp:Boolean = false;
			if (_ch.player_controlled) {
				p = FlxG.mouse.pressed();
				jp = FlxG.mouse.justPressed();
			} else {
				// ai signal
				p = _ch.shoot_p;
				jp = _ch.shoot_jp;
			}
			
			if (burst == 0) {
				return p;
			} else if (burst < 0) {
				// interruptible burst
				if (ct_burst == 0) {
					return jp;
				} else {
					return p && ct_burst < Math.abs(burst);
				}
			} else {
				if (ct_burst == 0) {
					return jp;
				} else {
					return ct_burst < Math.abs(burst);
				}
			}
		}
		
		private function reset_gun():void {
			/*
			orpm = convertRPM(gunstat.orpm);
			brpm = convertRPM(gunstat.brpm);
			*/
			
			if (burst == 0 || burst == -1) {
				var temp:Number = orpm;
				orpm = brpm;
				brpm = temp;
			} else {
				orpm *= Math.abs(burst);
			}
			
			ct_orpm = orpm;
			ct_brpm = brpm;
			ct_burst = 0;
		}
		
		private function convertRPM(rpm:Number):Number {
			// assumes 60fps
			return 3600 / rpm;
		}
		
		private function decr_ammo():void {
			ammo--;
			mag--;
			
			if (ammo < 0) {
				ammo = 0;
			}
			
			if (mag < 0) {
				mag = 0;
			}
		}
		
		public function needReload():Boolean {
			return mag != mag_size && backup_ammo() > 0;
		}
		
		public function reload():void {
			var ammo_used:int = mag_size - mag;
			if (ammo < ammo_used) {
				mag = ammo;
			} else {
				mag = mag_size;
			}
			
			if (!_ch.player_controlled) {
				// ai doesn't consume backup ammo
				ammo += ammo_used;
			}
		}
		
		public function backup_ammo():int {
			return ammo - mag;
		}
		
		protected function spawn_bullet():void {
			// determine random angle difference
			var ds:Number = 0.0;
			switch (_ch.stance) {
				case "hip":
					ds = gunstat.spread.hip;
					break;
				case "aim":
					ds = gunstat.spread.aim;
					break;
			}
			
			var theta:Number = _ch.ang + Util.float_random( -ds, ds);
			
			
			var muzzle_pos:FlxPoint = muzzlePosInfo;
			if (muzzle_pos == null) {
				muzzle_pos = _ch.muzzle_position();
			} else {
				muzzle_pos = Util.calibrate_pos(_ch.x(), _ch.y(), muzzlePosInfo.x, muzzlePosInfo.y, _ch.ang * Util.DEG2RAD);
			}
			
			// var muzzle_pos:FlxPoint = _ch.muzzle_position();
			
			var range:Number = (gunstat.range == null)?930:gunstat.range;
			var bullet:Bullet = new Bullet(muzzle_pos.x, muzzle_pos.y, theta, bullet_spd, damage, range);
			
			if (gunstat.spawn != null) {
				if (gunstat.spawn == "rocket") {
					bullet = new Torpedo(muzzle_pos.x, muzzle_pos.y, theta);
				} else if (gunstat.spawn == "sniper") {
					// spawn sniper round
				} else if (gunstat.spawn == "railgun") {
					// spawn railgun round
				}
			}
			
			_g.bullets.add(bullet);
		}
		
		public function setAmmo(n_ammo:int, n_mag:int = -1):void {
			if (n_mag < 0) {
				mag = mag_size;
			} else {
				mag = n_mag;
			}
			
			ammo = n_ammo;
		}
		
		private var muzzlePosInfo:FlxPoint;
		
		public function setMuzzlePosInfo(pos:FlxPoint):void {
			muzzlePosInfo = pos;
		}
		
		public function replenishAmmo(amount:int):void {
			ammo += amount;
			if (ammo > gunstat.ammo) {
				ammo = gunstat.ammo;
			}
		}
	}

}