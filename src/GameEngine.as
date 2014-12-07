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
		public var title:Boolean = true;
		
		// status bar
		public var status_bar:FlxSprite = new FlxSprite();
		public var hp_info:FlxText = new FlxText(0, 0, 150);
		public var gun_info:FlxText = new FlxText(0, 0, 300);
		public var ammo_info:FlxText = new FlxText(0, 0, 150);
		
		// in-game settings
		public var bg:FlxSprite = new FlxSprite();
		public var bullets:FlxGroup = new FlxGroup();
		public var chars:FlxGroup = new FlxGroup();
		public var player:Character;
		public var reticle:FlxSprite = new FlxSprite();
		
		// save
		public static var progress:Object = { knight:[0, 0], vanguard:[0, 0] };
		public var ammunition:Array = [{ mag:1, ammo:1 }, { mag:1, ammo:1 }];
		
		// special
		public var debug_text:FlxText = new FlxText(0, 0, 320);
		public var gameStart:Boolean = false;
		
		override public function create():void {
			super.create();
			
			// layer: bottom
			add_bg();
			
			// layer: mid
			add_chars();
			this.add(bullets);
			
			// layer: top
			add_status_bar();
			add_tutorial_objs();
			add_reticle();
			
			set_player();
			
			this.add(debug_text);
		}
		
		public function add_bg():void {
			bg.loadGraphic(Imports.DEFAULT_BG);
			bg.set_position(0, 0);
			this.add(bg);
		}
		
		public function add_chars():void {
			var knight:Knight = new Knight(320, 320, progress.knight[0], progress.knight[1], true);
			chars.add(knight);
			
			this.add(chars);
		}
		
		public function add_tutorial_objs():void {
			// add individual tutorial objects
			
			this.add(tutorialObjs);
		}
		
		public function add_status_bar():void {
			status_bar.loadGraphic(Imports.STATUS_BAR);
			status_bar.set_position(0, 600);
			
			var text_y:Number = 610;
			var text_size:Number = 12;
			
			hp_info.set_position(20, text_y);
			hp_info.text = "hp=???";
			hp_info.size = text_size;
			
			gun_info.set_position(170, text_y);
			gun_info.text = "gun=???";
			gun_info.size = text_size;
			
			ammo_info.set_position(480, text_y);
			ammo_info.text = "ammo=???";
			ammo_info.size = text_size;
			
			this.add(status_bar);
			this.add(hp_info);
			this.add(gun_info);
			this.add(ammo_info);
		}
		
		public function add_reticle():void {
			reticle.loadGraphic(Imports.MOUSE_RETICLE);
			this.add(reticle);
		}
		
		public function init_ammunition():void {
			if (player != null && player.getWeapon() != null) {
				// pull from weapon stat directly!
				var data:Array = player.getWeaponMapStat();
				ammunition[0].mag = data[0].mag_size;
				ammunition[0].ammo = data[0].ammo;
				ammunition[1].mag = data[1].mag_size;
				ammunition[1].ammo = data[2].ammo;
			}
		}
		
		// assign which thing on scene is going to be player
		public function set_player():void {
			player = chars.getFirstAlive() as Character;
		}
		
		override public function update():void {
			super.update();
			
			/*
			if (!gameStart) {
				init_ammunition();
				gameStart = true;
			}
			*/
			
			update_characters();
			update_bullets();
			
			update_tutorial();
			update_status_bar();
			
			update_reticle();
		}
		
		private function update_tutorial():void {
			return;
		}
		
		private function update_reticle():void {
			var x:Number = FlxG.mouse.x - reticle.width / 2;
			var y:Number = FlxG.mouse.y - reticle.height / 2;
			reticle.set_position(x,y);
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
			FlxG.overlap(chars, bullets, function(obj:Character, bullet:Bullet):void {
				// remove case: hit object
				// TODO: add hit animation
				itr_bullet.do_remove();
				_bullets.remove(itr_bullet, true);
			});
			*/
			
		}
		
		private function update_status_bar():void {
			if (player != null) {
				hp_info.text = "hp: " + player.hp + " / " + player.max_hp;
				
				var gun_text:String = "";
				var ammo_text:String = "";
				var weapon:BulletEmitter = player.getWeapon();
				if (weapon != null) {
					gun_text = weapon.name;
					ammo_text = weapon.mag + " / " + weapon.backup_ammo();
				}
				gun_info.text = "gun: " + gun_text;
				ammo_info.text = "ammo: " + ammo_text;
			}
		}
		
	}
	
}