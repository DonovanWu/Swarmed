package  {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	public class Imports {
		
		[Embed( source = "../resc/hitbox_25x30.png" )] public static var IMPORT_HITBOX_25x30:Class;
		
// accessories
		[Embed( source = "../resc/reticle.png" )] public static var MOUSE_RETICLE:Class;
		[Embed( source = "../resc/status_bar.jpg" )] public static var STATUS_BAR:Class;

// bg
		[Embed( source = "../resc/default_bg.jpg" )] public static var DEFAULT_BG:Class;

// particles
		[Embed( source = "../resc/particles/bullet_round.png" )] public static var BULLET_ROUND:Class;

// player
		[Embed( source = "../resc/chars/knight_body.png" )] public static var KNIGHT_BODY:Class;
		[Embed( source = "../resc/chars/knight_limbs.png" )] public static var KNIGHT_LIMBS:Class;
		
// weapon sprites
		[Embed( source = "../resc/guns/AssaultRifle.png" )] public static var GUN_ASSUALT_RIFLE:Class;
	}
}