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
		
		/*
		private const weaponMapping:Object = { w1: ["Revolver", "Marksman Rifle", "Assualt Rifle"],
												w2: ["Handgun", "Machine Pistol", "Submachine Gun"]};
												*/
		public const weaponMapping:Array = [["Assualt Rifle", "Marksman Rifle", "Revolver"],
											["Double Barrel", "Handgun", "Submachine Gun"]];
		public var weaponSlot:int = 0;
		public var reloading:Boolean = false;
		public static var ammunition:Array = [ { mag: 1, ammo: 1 }, { mag: 1, ammo: 1 } ];
		public static var init:Boolean = false;
		
		protected var exp:Array = [[100, 200], [100, 200]];
		
		// ai specs
		public var ai_trigger:int = 3;	// 1200 RPM
		public var aim_before_shoot:Boolean = false;
		
		public function Knight(x:Number = 0, y:Number = 0, w1lv:int = 0, w2lv:int = 0, human:Boolean = false) {
			// character data
			player_controlled = human;
			walkSpeed = 1.5;
			sprintSpeed = 2.5;
			w1_lv = w1lv;
			w2_lv = w2lv;
			max_hp = 200;
			
			
			if (!player_controlled) {
				// if it is AI, then pick a random gun
				w1_lv = Util.int_random(0, 2);
				w2_lv = Util.int_random(0, 2);
			}
			
			
			body.loadGraphic(Imports.KNIGHT_BODY);
			
			limbs.loadGraphic(Imports.KNIGHT_LIMBS, true, false, 60, 45);
			limbs.origin.x = body.width / 2;
			limbs.origin.y = body.height / 2;
			limbs.addAnimation("reload_rifle", Util.consecutive_num(2, 14), 12, false);
			limbs.addAnimation("reload_pistol", Util.consecutive_num(15, 19), 10, false);
			
			hitbox.loadGraphic(Imports.IMPORT_HITBOX_25x30);
			hitbox.alpha = 0.5;
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
			/*
			// update weapon status to game engine
			_g.ammunition[weaponSlot].mag = weapon.mag;
			_g.ammunition[weaponSlot].ammo = weapon.ammo;
			*/
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
				// roam?
			}
			
			// update AI
			// _g.debug_text.text = weapon.ammo + "";
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
		
		// returns array of two weapons' stat currently mapped to
		/*
		override public function getWeaponMapStat():Array {
			var name1:String = weaponMapping[0][w1_lv];
			var name2:String = weaponMapping[1][w2_lv];
			var obj1:Object = Util.weapon_map_emitter(name1).gunstat;
			var obj2:Object = Util.weapon_map_emitter(name2).gunstat;
			return [obj1, obj2];
		}
		*/
		
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
	}

}