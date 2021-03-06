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
		public var roadblocks:FlxGroup = new FlxGroup();	// static
		public var packets:FlxGroup = new FlxGroup();
		public var corpses:FlxGroup = new FlxGroup();		// static
		
		// in-game settings
		public var bg:FlxSprite = new FlxSprite();
		public var player:Character;
		public var reticle:FlxSprite = new FlxSprite();
		public var title_screen:FlxSprite = new FlxSprite();
		public var camera_icon:FlxSprite = new FlxSprite();
		public var warning:FlxSprite = new FlxSprite();
		
		// save
		public var progress:Object = { knight:[0, 0], vanguard:[0, 0], scout: [0, 0], bigmech:[0, 0]};
		public var ammunition:Array = [{ mag:1, ammo:1 }, { mag:1, ammo:1 }, {mag:1, ammo:1}];
		
		// game mechanics
		public var debug_text:FlxText = new FlxText(0, 0, 320);
		public var gameStart:Boolean = false;
		public var timer:int = 0;
		public var kills:int = 0;
		public var spawn_wait:int = 450;
		public const MAX_ENEMY_ONSTAGE:int = 20;
		public var game_status:String = "title";	// title, in-game, gameover
		public var init:Boolean = false;
		public var playing_music:Boolean = false;
		public var swarms:int = 0;
		public var bounds:FlxPoint = new FlxPoint(1280, 1280);
		
		override public function create():void {
			super.create();
			
			FlxG.worldBounds = new FlxRect(0, 0, bounds.x, bounds.y);
			
			// layer: bottom
			add_bg();
			
			corpses.add(new KnightCorpse(640, 640, 30));
			// corpses.add(new BigMechCorpse(640, 640, 30));
			// corpses.add(new ScoutCorpse(640, 640, 30));
			
			add_roadblocks();
			
			this.add(roadblocks);
			
			// layer: mid
			this.add(corpses);
			this.add(packets);
			this.add(chars);
			this.add(bullets);
			this.add(_particles);
			
			// layer: top
			add_status_bar();
			add_tutorial_objs();
			add_reticle();
			
			camera_icon.visible = false;		// turn visible for debugging
			camera_icon.set_position(640, 640);
			camera_icon.width = 0; camera_icon.height = 0;
			this.add(camera_icon);
			
			FlxG.camera.follow(camera_icon);
			FlxG.camera.setBounds(0, 0, bounds.x, bounds.y);
			
			title_screen.loadGraphic(Imports.IMPORT_TITLE);
			this.add(title_screen);
			title_screen.set_position(FlxG.camera.x + 320, FlxG.camera.y + 320);
			
			this.add(debug_text);
			debug_text.text = corpses.members.length + "";
			debug_text.visible = false;
		}
		
		public function add_bg():void {
			bg.loadGraphic(Imports.DEFAULT_BG);
			bg.set_position(0, 0);
			this.add(bg);
		}
		
		public function add_roadblocks():void {
			var roadblock1:FlxSprite = new FlxSprite();
			roadblock1.loadGraphic(Imports.ROAD_BLOCK);
			roadblock1.set_position(Util.int_random(150, 450), Util.int_random(100, 500));
			roadblock1.mass = 10000000;
			
			var roadblock2:FlxSprite = new FlxSprite();
			roadblock2.loadGraphic(Imports.ROAD_BLOCK);
			roadblock2.set_position(Util.int_random(150, 900), Util.int_random(700, 900));
			roadblock2.mass = 10000000;
			
			var roadblock3:FlxSprite = new FlxSprite();
			roadblock3.loadGraphic(Imports.ROAD_BLOCK_V);
			roadblock3.set_position(Util.int_random(700, 900), Util.int_random(150, 900));
			roadblock3.mass = 10000000;
			
			roadblocks.add(roadblock1);
			roadblocks.add(roadblock2);
			roadblocks.add(roadblock3);
		}
		
		public function add_chars():void {
			/*
			var knight1:Knight = new Knight(320, 320, progress.knight[0], progress.knight[1], true);
			chars.add(knight1);
			*/
			var me:BigMech = new BigMech(320, 320, progress.bigmech[0], progress.bigmech[1], true);
			chars.add(me);
			
			// test object
			var knight2:Knight = new Knight(80, 320);
			chars.add(knight2);
			
			this.add(chars);
		}
		
		public function add_tutorial_objs():void {
			// add individual tutorial objects
			
			this.add(tutorialObjs);
		}
		
		public function add_status_bar():void {
			var init_pos:FlxPoint = new FlxPoint(camera_icon.x +320, camera_icon.y + 320);
			
			status_bar.loadGraphic(Imports.STATUS_BAR);
			status_bar.set_position(init_pos.x, init_pos.y + 600);
			
			var text_y:Number = init_pos.y + 610;
			var text_size:Number = 12;
			
			hp_info.set_position(init_pos.x + 20, text_y);
			hp_info.text = "hp=???";
			hp_info.size = text_size;
			
			gun_info.set_position(init_pos.x + 170, text_y);
			gun_info.text = "gun=???";
			gun_info.size = text_size;
			
			ammo_info.set_position(init_pos.x + 480, text_y);
			ammo_info.text = "ammo=???";
			ammo_info.size = text_size;
			
			this.add(status_bar);
			this.add(hp_info);
			this.add(gun_info);
			this.add(ammo_info);
			
			add_warning();
		}
		
		public function add_reticle():void {
			reticle.loadGraphic(Imports.MOUSE_RETICLE, true, false, 32, 32);
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
		
		override public function update():void {
			super.update();
			
			update_reticle();
			if (!playing_music) {
				FlxG.playMusic(Imports.SOUND_BGM);
				playing_music = true;
			}
			
			if (game_status == "title") {
				title_screen.visible = true;
				title_screen.set_position(camera_icon.x - 320, camera_icon.y - 320);
				if (!init) {
					FlxG.flash();
					init = true;
				}
				for (var i:int = corpses.members.length - 1; i >= 0; i--) {
					var itr_corpse:Corpse = corpses.members[i];
					if (itr_corpse != null) {
						itr_corpse.update_corpse(this);
					}
				}
				update_particles();
			} else if (game_status == "in-game") {
				if (init) {
					FlxG.flash(0xffffffff, 0.6);
					init = false;
				}
				
				title_screen.visible = false;
				
				update_cam_pos();
				
				timer++;
				
				update_characters();
				update_bullets();
				update_particles();
				
				update_tutorial();
				update_status_bar();
				
				spawn_chars();
				spawn_swarm();
				spawn_ammo();
			} else if (game_status == "gameover") {
				can_revive = true;
				if (player == null) {
					game_status = "title";
				}
			}
		}
		
		private function spawn_chars():void {
			if (timer % spawn_wait == 1 && chars.members.length <= MAX_ENEMY_ONSTAGE) {
				var center:FlxPoint = new FlxPoint(640, 640);
				
				var r:Number = 1080;
				var theta:Number = Util.float_random(0, 6.28);
				
				var x:Number = r * Math.cos(theta) + center.x;
				var y:Number = r * Math.sin(theta) + center.y;
				
				/*
				// only spawn scout for testing
				var scout:Scout = new Scout(x, y);
				chars.add(scout);
				*/
				
				var choice:int = Util.float_random(0, 100);
				if (choice < 50) {
					var knight:Knight = new Knight(x, y);
					chars.add(knight);
					if (choice < (player.getWeaponLevel()[0] + player.getWeaponLevel()[1] - 4.5) * 10) {
						var scout:Scout = new Scout(x, y);
						chars.add(scout);
					}
				} else {
					if (choice < (player.getWeaponLevel()[0] + player.getWeaponLevel()[1] - 0.5) * 10) {
						var bigmech:BigMech = new BigMech(-200, 320);
						chars.add(bigmech);
					}
					var vanguard:Vanguard = new Vanguard(x, y);
					chars.add(vanguard);
				}
			}
		}
		
		private function spawn_swarm():void {
			if (kills % 30 == 15) {
				// TODO: warns swarm in bound
				FlxG.flash(0x20990000);
				FlxG.play(Imports.SOUND_ALARM);
				warning.play("warn");
				
				// every certain amount of kills will have a wave of swarm
				for (var i:int = 0; i < 6; i++ ) {
					var center:FlxPoint = new FlxPoint(640, 640);
					
					var r:Number = 1200;
					var theta:Number = Util.float_random(0, 6.28);
					
					var x:Number = r * Math.cos(theta) + center.x;
					var y:Number = r * Math.sin(theta) + center.y;
					
					var knight:Knight = new Knight(x, y);
					chars.add(knight);
					var vanguard:Vanguard = new Vanguard(x, y);
					chars.add(vanguard);
				}
				
				var scout1:Scout = new Scout(800, -100);
				chars.add(scout1);
				var scout2:Scout = new Scout(800, 1320);
				chars.add(scout2);
				
				// one big mech
				var bigmech:BigMech = new BigMech(-200, 640, 0, 0, false, swarms);
				chars.add(bigmech);
				
				kills++;	// therefore kills is no longer an accurate count of things ... ;_;
				// ending up with add 10 more kills to kill so...
				swarms++;
			}
		}
		
		private function spawn_ammo():void {
			if (timer % spawn_wait == spawn_wait / 2) {
				packets.add(new Packet(Util.int_random(40, bounds.x - 40), Util.int_random(40, bounds.y - 40), 2));
			}
		}
		
		private function update_tutorial():void {
			return;
		}
		
		private function update_reticle():void {
			var x:Number = FlxG.mouse.x - reticle.width / 2;
			var y:Number = FlxG.mouse.y - reticle.height / 2;
			reticle.set_position(x, y);
			if (player != null && player.stance == "aim") {
				reticle.frame = 1;
			} else {
				reticle.frame = 0;
			}
		}
		
		private function update_characters():void {
			// debug_text.text = chars.members.length + "";
			
			for (var i:int = chars.members.length - 1; i >= 0; i--) {
				var char:Character = chars.members[i];
				if (char != null) {
					char.update_character(this);
					
					// bullet hit detection
					FlxG.overlap(char.getHitBox(), bullets, function(hitbox:FlxSprite, bullet:Bullet):void {
						char.take_damage(bullet.get_damage());
						
						var spark:String = (char.giant)? Spark.SPARK : Spark.BLOOD;
						var blood:Spark = new Spark(bullet.x, bullet.y, bullet.angle - 180, spark);
						_particles.add(blood);
						bullet.do_remove();
						// FlxG.play(Imports.SOUND_HIT);
						
						bullets.remove(bullet, true);
					});
					
					FlxG.collide(char.getHitBox(), roadblocks, function(hitbox:FlxSprite, roadblock:FlxSprite):void {
						// moving roadblock
						if (!char.giant) {
							if (char.player_controlled) {
								char.moveSpeed /= 4;
							} else {
								char.roam(true);
							}
						}
					});
					
					if (char.player_controlled) {
						FlxG.overlap(char.getHitBox(), packets, function (hitbox:FlxSprite, item:Packet):void {
							if (item.frame != 2) {
								char.gainExp(item.getAmount(), int(item.frame));
							} else {
								// pick up ammo
								FlxG.play(Imports.SOUND_SCORE, 0.3);
								char.getWeapon().replenishAmmo(item.getAmount());
							}
							packets.remove(item);
						});
					}
					
					if (char.should_remove()) {
						kills++;
						
						if (char.player_controlled) {
							player = null;
							kills--;
							game_status = "gameover";
						}
						
						chars.remove(char, true);
					}
				}
			}
		}
		
		private function update_bullets():void {
			for (var i:int = bullets.members.length - 1; i >= 0; i--) {
				var itr_bullet:Bullet = bullets.members[i];
				if (itr_bullet != null) {	// for some odd reason, things only work if this line is added
					itr_bullet.update_bullet(this);
					if (itr_bullet.should_remove()) {
						// remove case: max range reached
						itr_bullet.do_remove();
						bullets.remove(itr_bullet, true);
					}
					
					if (Util.is_out_of_bound(itr_bullet, bounds)) {
						// remove case: out of bound
						// TODO: add hit animation
						itr_bullet.do_remove();
						bullets.remove(itr_bullet, true);
					}
				} // end of if not null
				
				// bullet hit roadblock detection
				FlxG.overlap(roadblocks, bullets, function(roadblock:FlxSprite, bullet:Bullet):void {
					var spark:Spark = new Spark(bullet.x, bullet.y, bullet.angle - 180);
					_particles.add(spark);
					bullet.do_remove();
					
					bullets.remove(bullet, true);
				});
				
			} // end of for
		}
		
		private function update_particles():void {
			for (var i:int = _particles.members.length - 1; i >= 0; i--) {
				var itr_bullet:Particle = _particles.members[i];
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
				var suffix:String = "";
				var weapon:BulletEmitter = player.getWeapon();
				if (weapon != null) {
					gun_text = weapon.name;
					ammo_text = weapon.mag + " / " + weapon.backup_ammo();
					if (player.is_curr_weap_max()) {
						suffix = "(Max Level)";
					}
				}
				
				gun_info.text = "gun: " + gun_text + " " + suffix;
				ammo_info.text = "ammo: " + ammo_text;
				
				var init_pos:FlxPoint = new FlxPoint(camera_icon.x - 320, camera_icon.y - 320);
				var text_y:Number = init_pos.y + 610;
				var text_size:Number = 12;
				
				status_bar.set_position(init_pos.x, init_pos.y + 600);
				hp_info.set_position(init_pos.x + 20, text_y);
				gun_info.set_position(init_pos.x + 170, text_y);
				ammo_info.set_position(init_pos.x + 480, text_y);
				
				warning.set_position(camera_icon.x - warning.width / 2, camera_icon.y - warning.height);
			}
		}
		
		// an experimental function to solve lag issue
		private function get_player():Character {
			for (var i:int = 0; i < chars.members.length; i++ ) {
				var itr_char:Character = chars.members[i] as Character;
				if (itr_char.player_controlled) {
					return itr_char;
				}
			}
			return null;
		}
		
		public var can_revive:Boolean = true;	// to make sure only one is revived
		
		public function revive_knight(x:Number, y:Number, corpse:Corpse):void {
			if (can_revive) {
				var knight:Knight = new Knight(x, y, progress.knight[0], progress.knight[1], true);
				chars.add(knight);
				player = knight;
				
				corpses.remove(corpse);
				can_revive = false;
			}
		}
		
		public function revive_vanguard(x:Number, y:Number, corpse:Corpse):void {
			if (can_revive) {
				var knight:Vanguard = new Vanguard(x, y, progress.vanguard[0], progress.vanguard[1], true);
				chars.add(knight);
				player = knight;
				
				corpses.remove(corpse);
				can_revive = false;
			}
		}
		
		public function revive_scout(x:Number, y:Number, corpse:Corpse):void {
			if (can_revive) {
				var scout:Scout = new Scout(x, y, progress.scout[0], progress.scout[1], true);
				chars.add(scout);
				player = scout;
				
				corpses.remove(corpse);
				can_revive = false;
			}
		}
		
		public function revive_bigmech(x:Number, y:Number, corpse:Corpse):void {
			if (can_revive) {
				var knight:BigMech = new BigMech(x, y, 0, 0, true);
				chars.add(knight);
				player = knight;
				
				corpses.remove(corpse);
				can_revive = false;
			}
		}
		
		public function update_progress(w1_lv:int, w2_lv:int, which:String):void {
			if (which == "knight") {
				progress.knight[0] = w1_lv;
				progress.knight[1] = w2_lv;
			} else if (which == "vanguard") {
				progress.vanguard[0] = w1_lv;
				progress.vanguard[1] = w2_lv;
			} else if (which == "scout") {
				progress.scout[0] = w1_lv;
				progress.scout[1] = w2_lv;
			}
		}
		
		public function add_corpse(corpse:Corpse):void {
			// CORPSE_MAX is 50
			if (corpses.length >= 50) {
				corpses.remove(corpses.getFirstAlive(), true);
			}
			corpses.add(corpse);
		}
		
		private function update_cam_pos():void {
			var x:int = (player.x() + FlxG.mouse.x) / 2;
			var y:int = (player.y() + FlxG.mouse.y) / 2;
			if (x < bounds.x / 4) {
				x = bounds.x / 4;
			} else if (x > bounds.x * 3 / 4) {
				x = bounds.x * 3 / 4;
			}
			if (y < bounds.y / 4) {
				y = bounds.y / 4;
			} else if (y > bounds.y * 3 / 4) {
				y = bounds.y * 3 / 4;
			}
			
			camera_icon.set_position(x, y);
		}
		
		private function add_warning():void {
			warning.loadGraphic(Imports.IMPORT_WARNING, true, false, 420, 70);
			warning.addAnimation("warn", [0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 0], 12, false);
			warning.frame = 0;
			warning.set_position(camera_icon.x - warning.width / 2, camera_icon.y - warning.height);
			this.add(warning);
		}
	}
	
}