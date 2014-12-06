package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	
	import core.Character;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import particles.
	
	public class Gun extends BasicWeapon {
		public var _g:GameEngine;
		public var _p:Character;
		
		public var _mag:int;	// ammo in the mag
		public var _ammo:int;	// total ammo
		
		// gun position info
		/*
		 * _offset: inherited from super class
		 */
		
		// gun mechanic varaibles
		private var _ct_rpm:Number;
		private var _ct_brpm:Number;
		private var _rpm:Number;
		private var _brpm:Number;
		private var _burst:int;		// 0 for auto
		private var _ct_burst:int;
		private var _fire_mode:int = 0;
		protected var _silenced:Boolean;
		
		public function Gun(stat:Object) {
			// actually acts as a bullet emitter
			
			super(stat);
			
			this._burst = _stat.burst[_fire_mode];
			
			this._mag = _stat.mag_size;
			this._ammo = _stat.max_clip * _mag;
			
			this._rpm = 3600 / _stat.rpm;
			if (_rpm < 1) {
				_rpm = 1;
			}
			if (_stat.brpm != null) {
				this._brpm = 3600 / _stat.brpm;
				if (_brpm < 1) {
					_brpm = 1;
				}
			} else {
				_brpm = Number.MAX_VALUE;
			}
			_ct_rpm = _rpm;
			_ct_brpm = _brpm;
			_ct_burst = 0;
			
			_silenced = (_stat.silenced != null) && (_stat.silenced == 1);
		}
		
		override public function update_weapon(game:GameEngine, player:Player):void {
			_g = game;
			_p = player;
			
			// update offset
			make_offset();
			
			if (triggered()) {
				if (_burst != 0 && _ct_brpm >= _brpm) _ct_brpm -= _brpm;
				
				if (_mag > 0) {
					if (_ct_rpm >= _rpm) {
						_ct_rpm -= _rpm;
						decr_ammo();
						if (_burst != 0) _ct_burst++;
						
						var ds:Number = 0.0;
						var dk:Number = 0.0;
						switch (_g._stance) {
							case 0 : // hip
								ds = _stat.spread.hip;
								dk = _stat.kick.hip;
								break;
							case 1 : // aim
								ds = _stat.spread.aim;
								dk = _stat.kick.aim;
								break;
							case -1 : // prone
								ds = _stat.spread.prone;
								dk = _stat.kick.prone;
								break;
						}
						
						for (var i:int = 1; i <= _stat.pellets; i++) {
							spawn_bullet(_offset, ds, dk);
						}
					}
					_ct_rpm++;
					_ct_brpm++;
				} // end if mag > 0
			} else {
				// capping the rpm
				if (_ct_rpm < _rpm) {
					_ct_rpm++;
				} else {
					_ct_rpm = _rpm;
				}
				
				if (_burst != 0) {
					if (_ct_brpm < _brpm) {
						_ct_brpm++;
					} else {
						_ct_brpm = _brpm;
					}
				}
			}
			
			if (_ct_burst >= Math.abs(_burst) && _ct_brpm >= _brpm) _ct_burst = 0;
			
			if (_mag <= 0) {
				reload();
			}
		}
		
		protected function spawn_bullet(off:FlxPoint, ds:Number, dk:Number):void {
			var ang:Number = _p._ang * Util.DEGREE;
			ang = ang + Util.float_random( -ds, ds);
			var player_pos:FlxPoint = _p.position();
			var kick:Number = Util.float_random( -dk, dk);
			// TODO: muzzle position may be different while proning
			var muzzle_pos:FlxPoint = 
				Util.calibrate_pos(player_pos.x, player_pos.y,
								off.x + _p._wg.width, off.y + kick, ang * Util.RADIAN);
			
			var bullet:GunBullet = 
				new GunBullet(muzzle_pos, ang, _stat.speed, _stat.damage, _stat.range);
			muzzle_pos = Util.repos2ctr(bullet, muzzle_pos, ang * Util.RADIAN);
			bullet.set_position(muzzle_pos.x, muzzle_pos.y);
			_g._bullets.add(bullet);
			
			if (!_silenced) {
				// spawn gun flare (silenced gun should be a different class?)
			}
		}
		
		// override if the gun has unusual ammo decrease mechanic, such as akimbo weapon
		// akimbo guns can modify this function for left-right side shift, too
		protected function decr_ammo():void {
			_mag--;
		}
		
		override public function mobility():Number {
			var multi:Number = 1;
			if (_g != null && _g._stance != 0) {
				multi = _stat.ads_mvspd;
			}
			return _stat.mobility * multi;
		}
		
		// differentiates types of triggering
		private function triggered():Boolean {
			if (_g._is_sprinting) return false;
			
			if (_burst == 0) {
				return FlxG.mouse.pressed();
			} else if (_burst < 0) {
				// to implement interruptible burst, just set burst < 0
				if (_ct_burst == 0) {
					return FlxG.mouse.justPressed();
				} else {
					return FlxG.mouse.pressed() && _ct_burst < Math.abs(_burst);
				}
			} else {
				if (_ct_burst == 0) {
					return FlxG.mouse.justPressed();
				} else {
					return _ct_burst < Math.abs(_burst);
				}
			}
		}
		
		// to be called in GameEngine, game control part
		public function select_fire():void {
			if (_stat.burst.length > 1) {
				_fire_mode = Util.nextInt(0, _stat.burst.length - 1, _fire_mode);
				_burst = _stat.burst[_fire_mode];
			}
		}
		
		public function set_ammo(ammo:int):void {
			if (ammo < 0 || ammo > _stat.max_clips * _stat.mag_size) {
				ammo = 0;
			}
			this._ammo = ammo;
		}
		
		override protected function make_offset():void {
			// default offset, suits for AR, SMG, LMG, DMR, SR, SG, do not override if using default
			_offset = _offset.make(-5, 12);
		}
		
		public function reload():void {
			// TODO: refill ammo, change clip animation
		}
	}

}