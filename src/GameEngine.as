package {
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	
	import core.*;
	import flash.display.*;
	import guns.*;
	import misc.FlxGroupSprite;
	import org.flixel.*;
	import particles.*;
	
	public class GameEngine extends FlxState {
		
		// tutorial
		public static var firstTime:Boolean = true;
		public var tutorialObjs:FlxGroup = new FlxGroup();
		public static var tutor_timer:int = Util.TUTOR_TIMER;
		
		public var bg:FlxSprite = new FlxSprite();
		public var bullets:FlxGroup = new FlxGroup();
		public var chars:FlxGroup = new FlxGroup();
		public var player:Character;
		
		public var debug_text:FlxText = new FlxText(0, 0, 320);
		
		override public function create():void {
			super.create();
			
			// layer: bottom
			add_bg();
			
			// layer: mid
			add_chars();
			this.add(bullets);
			
			// layer: top
			add_tutorial_objs();
			
			set_player();
			
			FlxG.mouse.show();
			
			this.add(debug_text);
		}
		
		public function add_bg():void {
			bg.loadGraphic(Imports.DEFAULT_BG);
			bg.set_position(0, 0);
			this.add(bg);
		}
		
		public function add_chars():void {
			var knight:Knight = new Knight(320, 320);
			chars.add(knight);
			
			this.add(chars);
		}
		
		public function add_tutorial_objs():void {
			// add individual tutorial objects
			
			this.add(tutorialObjs);
		}
		
		public function set_player():void {
			player = chars.getFirstAlive() as Character;
		}
		
		override public function update():void {
			super.update();
			
			update_tutorial();

			update_characters();
			update_bullets();
		}
		
		private function update_tutorial():void {
			
		}
		
		private function update_characters():void {
			for (var i:int = chars.members.length - 1; i >= 0; i--) {
				var char:Character = chars.members[i] as Character;
				char.update_character(this);
			}
		}
		
		private function update_bullets():void {
			for (var i:int = bullets.members.length - 1; i >= 0; i--) {
				var itr_bullet:Bullet = bullets.members[i] as Bullet;
				if (itr_bullet != null) {	// for some odd reason, things only work if this line is added
					itr_bullet.update_bullet(this);
					if (itr_bullet.should_remove()) {
						// remove case: max range reached
						itr_bullet.do_remove();
						bullets.remove(itr_bullet, true);
					}
					
					if (Util.is_out_of_bound(itr_bullet, new FlxPoint(640, 640))) {
						// remove case: out of bound
						// TODO: add hit animation
						itr_bullet.do_remove();
						bullets.remove(itr_bullet, true);
					}
				} // end of if not null
			} // end of for
			
			// hit test
			/*
			FlxG.overlap(_layout, _bullets, function(obj:FlxSprite, bullet:Bullet):void {
				// remove case: hit object
				// TODO: add hit animation
				if (obj.ID == Util.ID_IMMOVABLE_OBJ) {
					itr_bullet.do_remove();
					_bullets.remove(itr_bullet, true);
				}
			});
			*/
			
		}
		
	}
	
}