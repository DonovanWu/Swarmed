package {
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	
	import core.*;
	import flash.display.*;
	import gameobj.*;
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
		
		// groups
		public var bullets:FlxGroup = new FlxGroup();
		public var chars:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		public static var roadblocks:FlxGroup = new FlxGroup();
		public var packets:FlxGroup = new FlxGroup();
		public static var corpses:FlxGroup = new FlxGroup(50);
		
		// in-game settings
		public var bg:FlxSprite = new FlxSprite();
		public var player:Character;
		public var reticle:FlxSprite = new FlxSprite();
		
		// save
		public static var progress:Object = { knight:[0, 0], vanguard:[0, 0] };
		public var ammunition:Array = [{ mag:1, ammo:1 }, { mag:1, ammo:1 }];
		
		// game mechanics
		public var debug_text:FlxText = new FlxText(0, 0, 320);
		public var gameStart:Boolean = false;
		public var timer:int = 0;
		public var kills:int = 0;
		public var spawn_wait:int = 300;	// 600?
		
		override public function create():void {
			super.create();
			
			// layer: bottom
			add_bg();
			
			this.add(corpses);
			
			if (firstTime) {
				add_roadblocks();
				
				// turn off after tutorial is implemented
				firstTime = false;
			}
			
			this.add(roadblocks);
			
			// layer: mid
			this.add(packets);
			add_chars();
			this.add(bullets);
			this.add(_particles);
			
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
		
		public function add_roadblocks():void {
			var roadblock1:FlxSprite = new FlxSprite();
			roadblock1.loadGraphic(Imports.ROAD_BLOCK);
			roadblock1.set_position(Util.int_random(150, 450), Util.int_random(100, 200));
			roadblock1.mass = 10000000;
			
			var roadblock2:FlxSprite = new FlxSprite();
			roadblock2.loadGraphic(Imports.ROAD_BLOCK);
			roadblock2.set_position(Util.int_random(150, 450), Util.int_random(400, 500));
			roadblock2.mass = 10000000;
			
			var roadblock3:FlxSprite = new FlxSprite();
			roadblock3.loadGraphic(Imports.ROAD_BLOCK_V);
			var x3:Number = (Util.int_random(0,1) == 1) ? Util.int_random(100, 150) : Util.int_random(400, 450);
			roadblock3.set_position(x3, Util.int_random(250, 300));
			roadblock3.mass = 10000000;
			
			roadblocks.add(roadblock1);
			roadblocks.add(roadblock2);
			roadblocks.add(roadblock3);
		}
		
		public function add_chars():void {
			var knight1:Knight = new Knight(320, 320, progress.knight[0], progress.knight[1], true);
			chars.add(knight1);
			
			// test object
			var knight2:Knight = new Knight(80, 320, progress.knight[0], progress.knight[1]);
			chars.add(knight2);
			
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
			timer++;
			
			spawn_chars();
			
			update_characters();
			update_bullets();
			update_particles();
			
			update_tutorial();
			update_status_bar();
			
			update_reticle();
		}
		
		private function spawn_chars():void {
			if (timer % spawn_wait == spawn_wait - 1) {
				var r:Number = 640 * Math.sqrt(2) / 2;
				var thetha:Number = Util.float_random(0, 6.28);
				
				var x:Number = r * Math.cos(thetha);
				var y:Number = r * Math.sin(thetha);
				
				var knight:Knight = new Knight(x, y, progress.knight[0], progress.knight[1]);
				chars.add(knight);
			}
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
				
				// hit detection
				FlxG.overlap(char.getHitBox(), bullets, function(hitbox:FlxSprite, bullet:Bullet):void {
					char.take_damage(bullet.get_damage());
					
					var blood:Spark = new Spark(bullet.x, bullet.y, bullet.angle - 180, Spark.BLOOD);
					_particles.add(blood);
					
					bullets.remove(bullet, true);
				});
				
				FlxG.collide(char.getHitBox(), roadblocks, function(hitbox:FlxSprite, roadblock:FlxSprite):void {
					// moving roadblock
					if (char.player_controlled) {
						char.moveSpeed /= 3;
					} else {
						char.roam(true);
					}
				});
				
				if (char.player_controlled) {
					FlxG.overlap(char.getHitBox(), packets, function (hitbox:FlxSprite, item:Packet):void {
						char.gainExp(item.getAmount(), int(item.frame))
						packets.remove(item);
					});
				}
				
				if (char.should_remove()) {
					kills++;
					
					if (char.player_controlled) {
						player = null;
						kills--;
						// gameover!
					}
					
					chars.remove(char, true);
				}
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
				
				FlxG.overlap(roadblocks, bullets, function(roadblock:FlxSprite, bullet:Bullet):void {
					var spark:Spark = new Spark(bullet.x, bullet.y, bullet.angle - 180);
					_particles.add(spark);
					
					bullets.remove(bullet, true);
				});
				
			} // end of for
		}
		
		private function update_particles():void {
			for (var i:int = _particles.members.length - 1; i >= 0; i--) {
				var itr_bullet:Particle = _particles.members[i] as Particle;
				if (itr_bullet != null) {	// for some odd reason, things only work if this line is added
					itr_bullet.update_particle(this);
					if (itr_bullet.should_remove()) {
						// remove case: max range reached
						itr_bullet.do_remove();
						_particles.remove(itr_bullet, true);
					}
				} // end of if not null
			} // end of for
			
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