package core 
{
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
		
		public function Knight(x:Number = 0, y:Number = 0, w1_lv:int = 0, w2_lv:int = 0) {
			// something
			player_controlled = true;
			walkSpeed = 2.0;
			
			body.loadGraphic(Imports.KNIGHT_BODY);
			limbs.loadGraphic(Imports.KNIGHT_LIMBS);
			limbs.origin.x = body.width / 2;
			limbs.origin.y = body.height / 2;
			
			this.add(limbs);
			this.add(body);
			// this.add(hitbox);
			
			wlv1 = w1_lv;
			wlv2 = w2_lv;
			
			this.set_pos(x, y);
		}
		
		override public function update_position():void {
			body.set_position(x() - body.width / 2, y() - body.width / 2);
			limbs.set_position(body.x, body.y);
			
			body.angle = ang;
			// hitbox.angle = ang;
			limbs.angle = ang;
			
			// update_limb_anim();
		}
		
	}

}