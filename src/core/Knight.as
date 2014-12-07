package core 
{
	import guns.AssualtRifle;
	import guns.BulletEmitter;
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
		
		public var wlv1:int;	// level for weapon 1
		public var wlv2:int;	// level for weapon 2
		
		public var weapon:BulletEmitter = new BulletEmitter( { } );
		public var weapon_spr:FlxSprite = new FlxSprite();
		public var weapon_offset:FlxPoint = new FlxPoint();
		
		public var weaponSlot:int = 0;
		
		private const weaponMapping:Object = { w1: ["Revolver", "Marksman Rifle", "Assualt Rifle"],
												w2: ["Handgun", "Machine Pistol", "Submachine Gun"]};
		
		public function Knight(x:Number = 0, y:Number = 0, w1_lv:int = 0, w2_lv:int = 0) {
			// character data
			player_controlled = true;
			walkSpeed = 1.5;
			sprintSpeed = 2.5;
			wlv1 = w1_lv;
			wlv2 = w2_lv;
			
			body.loadGraphic(Imports.KNIGHT_BODY);
			
			limbs.loadGraphic(Imports.KNIGHT_LIMBS);
			limbs.origin.x = body.width / 2;
			limbs.origin.y = body.height / 2;
			
			hitbox.loadGraphic(Imports.IMPORT_HITBOX_25x30);
			hitbox.alpha = 0.5;
			hitbox.visible = false;
			
			this.add(limbs);
			add_weapons();
			this.add(body);
			this.add(hitbox);
			
			this.set_pos(x, y);
		}
		
		protected function add_weapons():void {
			// add weapons, corresponding bullet emitters and offset info
			weapon = new AssualtRifle();
			
			weapon_spr.loadGraphic(Imports.GUN_ASSUALT_RIFLE);
			weapon_spr.setOriginToCorner();
			
			weapon_offset = weapon_offset.make(5, 10);
			
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
			weapon.update_emitter(_g, this);
		}
		
		protected function update_mobility():void {
			if (stance == "hip") {
				mobility = weapon.mobility;
			} else {	// aim
				mobility = weapon.mobility * weapon.ads_multi;
			}
		}
		
		override public function getWeapon():BulletEmitter {
			return weapon;
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
	}

}