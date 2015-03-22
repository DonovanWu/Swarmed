package  {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	public class Imports {
		
		[Embed( source = "../resc/hitbox_25x30.png" )] public static var IMPORT_HITBOX_25x30:Class;
		[Embed( source = "../resc/hitbox_80x80.png" )] public static var IMPORT_HITBOX_80x80:Class;
		[Embed( source = "../resc/roadblock.jpg" )] public static var ROAD_BLOCK:Class;
		[Embed( source = "../resc/roadblock_v.jpg" )] public static var ROAD_BLOCK_V:Class;
		[Embed( source = "../resc/packets.png" )] public static var IMPORT_PACKETS:Class;
		[Embed( source = "../resc/title.png" )] public static var IMPORT_TITLE:Class;
		
// accessories
		[Embed( source = "../resc/reticle.png" )] public static var MOUSE_RETICLE:Class;
		[Embed( source = "../resc/status_bar.jpg" )] public static var STATUS_BAR:Class;

// bg
		[Embed( source = "../resc/default_bg.jpg" )] public static var DEFAULT_BG:Class;

// particles
		[Embed( source = "../resc/particles/bullet_round.png" )] public static var BULLET_ROUND:Class;
		[Embed( source = "../resc/particles/explosion.png" )] public static var IMPORT_EXPLOSION:Class;
		[Embed( source = "../resc/particles/torpedo.png" )] public static var IMPORT_TORPEDO:Class;
		[Embed( source = "../resc/particles/spark.png" )] public static var IMPORT_SPARK:Class;
		[Embed( source = "../resc/bubble.png" )] public static var IMPORT_BUBBLE:Class;
		[Embed( source = "../resc/particles/bullet_sniper.png" )] public static var BULLET_SNIPER:Class;
		[Embed( source = "../resc/particles/bullet_railgun.png" )] public static var BULLET_RAILGUN:Class;

// player
		[Embed( source = "../resc/chars/knight_body.png" )] public static var KNIGHT_BODY:Class;
		[Embed( source = "../resc/chars/knight_limbs.png" )] public static var KNIGHT_LIMBS:Class;
		[Embed( source = "../resc/chars/vanguard_body.png" )] public static var VANGUARD_BODY:Class;
		[Embed( source = "../resc/chars/BigMech.png" )] public static var BIGMECH_BODY:Class;
		[Embed( source = "../resc/chars/knight_corpse.png" )] public static var KNIGHT_CORPSE:Class;
		[Embed( source = "../resc/chars/vanguard_corpse.png" )] public static var VANGUARD_CORPSE:Class;
		[Embed( source = "../resc/chars/BigMechCorpse.png" )] public static var BIGMECH_CORPSE:Class;
		[Embed( source = "../resc/chars/scout_body.png" )] public static var SCOUT_BODY:Class;
		[Embed( source = "../resc/chars/scout_corpse.png" )] public static var SCOUT_CORPSE:Class;
		
// weapon sprites
		[Embed( source = "../resc/guns/AssaultRifle.png" )] public static var GUN_ASSAULT_RIFLE:Class;
		[Embed( source = "../resc/guns/AssaultShotgun.png" )] public static var GUN_ASSAULT_SHOTGUN:Class;
		[Embed( source = "../resc/guns/BulpUpRifle.png" )] public static var GUN_BULPUP_RIFLE:Class;
		[Embed( source = "../resc/guns/DoubleBarrel.png" )] public static var GUN_DOUBLE_BARREL:Class;
		[Embed( source = "../resc/guns/Handgun.png" )] public static var GUN_HANDGUN:Class;
		[Embed( source = "../resc/guns/LightMachineGun.png" )] public static var GUN_LIGHT_MACHINE_GUN:Class;
		[Embed( source = "../resc/guns/MachinePistol.png" )] public static var GUN_MACHINE_PISTOL:Class;
		[Embed( source = "../resc/guns/MarksmanRifle.png" )] public static var GUN_MARKSMAN_RIFLE:Class;
		[Embed( source = "../resc/guns/Revolver.png" )] public static var GUN_REVOLVER:Class;
		[Embed( source = "../resc/guns/TacticalShotgun.png" )] public static var GUN_TACTICAL_SHOTGUN:Class;
		[Embed( source = "../resc/guns/SubmachineGun.png" )] public static var GUN_SUBMACHINE_GUN:Class;
		[Embed( source = "../resc/guns/AK47.png" )] public static var GUN_AK47:Class;
		[Embed( source = "../resc/guns/CombatShotgun.png" )] public static var GUN_COMBAT_SHOTGUN:Class;
		[Embed( source = "../resc/guns/HuntingRifle.png" )] public static var GUN_HUNTING_RIFLE:Class;
		[Embed( source = "../resc/guns/SniperRifle.png" )] public static var GUN_SNIPER_RIFLE:Class;
		[Embed( source = "../resc/guns/Railgun.png" )] public static var GUN_RAILGUN:Class;
		[Embed( source = "../resc/guns/AMR.png" )] public static var GUN_AMR:Class;
		
// sound
		[Embed( source = "../resc/sound/sfx_explosion.mp3" )] public static var SOUND_EXPLOSION:Class;
		[Embed( source = "../resc/sound/sfx_powerup.mp3" )] public static var SOUND_SCORE:Class;
		[Embed( source = "../resc/sound/sfx_launcher.mp3" )] public static var SOUND_LAUNCHER:Class;
		[Embed( source = "../resc/sound/shoot3.mp3" )] public static var SOUND_SHOOT_3:Class;
		[Embed( source = "../resc/sound/sfx_hit.mp3" )] public static var SOUND_HIT:Class;
		[Embed( source = "../resc/sound/bgm.mp3" )] public static var SOUND_BGM:Class;
		[Embed( source = "../resc/sound/reload.mp3" )] public static var SOUND_RELOAD:Class;
		[Embed( source = "../resc/sound/sfx_levelup.mp3" )] public static var SOUND_LEVELUP:Class;
		[Embed( source = "../resc/sound/sfx_sniper.mp3" )] public static var SOUND_SNIPER:Class;
	}
}