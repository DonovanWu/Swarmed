package guns 
{
	import core.Character;
	import org.flixel.*;
	import particles.Bullet;
	/**
	 * ...
	 * @author Wenrui (Donovan) Wu
	 */
	public class BulletEmitter extends FlxSprite
	{
		private var _g:GameEngine;
		private var _ch:Character;
		
		public var damage:int;
		
		protected var gunstat:Object;
		
		protected var pellets:int;
		protected static var mag:int = 1;			// bullet left in magazine
		protected var mag_size:int;		// magazine size: set to 0 or negative for inf ammo
		protected static var ammo:int = 1;			// total ammo this gun has
		
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
			
			// other stats often used
			bullet_spd = gunstat.speed;
			pellets = gunstat.pellets;
			damage = gunstat.damage;
			
			reset_gun();
		}
		
		public function update_emitter(game:GameEngine, char:Character):void {
			_g = game;
			_ch = char;
			
			if (triggered(_ch.trigger_p(), _ch.trigger_jp())) {
				
				if (burst != 0 && ct_brpm >= brpm) ct_brpm -= brpm;
				
				if (mag > 0) {
					if (ct_orpm >= orpm) {
						ct_orpm -= orpm;
						decr_ammo();
						if (burst != 0) ct_burst++;
						
						for (var i:int = 1; i <= pellets; i++) {
							spawn_bullet();
						}
					}
					ct_orpm++;
					ct_brpm++;
				} // end if mag > 0
			} else {
				// capping the rpm
				if (ct_orpm < orpm) {
					ct_orpm++;
				} else {
					ct_orpm = orpm;
				}
				
				if (burst != 0) {
					if (ct_brpm < brpm) {
						ct_brpm++;
					} else {
						ct_brpm = brpm;
					}
				}
			}
			
			if (ct_burst >= Math.abs(burst) && ct_brpm >= brpm) ct_burst = 0;
			
			if (mag <= 0) {
				reload();
			}
		}
		
		// differentiates types of triggering
		private function triggered(p:Boolean, jp:Boolean):Boolean {
			if (_ch.isSprinting) return false;
			
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
			orpm = convertRPM(gunstat.orpm);
			brpm = convertRPM(gunstat.brpm);
			
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
			return 3600 / gunstat.orpm;
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
		
		private function reload():void {
			// TODO: reload animation, halt character, etc.
			// TODO: ammo should be in clip after animation finishes
			
			var ammo_used:int = mag_size - mag;
			if (ammo < ammo_used) {
				mag = ammo;
			} else {
				mag = mag_size;
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
			_g.debug_text.text = theta + "";
			
			var muzzle_pos:FlxPoint = _ch.muzzle_position();
			
			var bullet:Bullet = new Bullet(muzzle_pos.x, muzzle_pos.y, theta, bullet_spd, damage);
			_g.bullets.add(bullet);
			
			/*
			var bullet:GunBullet = 
				new GunBullet(muzzle_pos, ang, _stat.speed, _stat.damage, _stat.range);
			muzzle_pos = Util.repos2ctr(bullet, muzzle_pos, ang * Util.RADIAN);
			bullet.set_position(muzzle_pos.x, muzzle_pos.y);
			_g.bullets.add(bullet);
			*/
		}
	}

}