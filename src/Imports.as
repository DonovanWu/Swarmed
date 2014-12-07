package  {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	public class Imports {
		
		[Embed( source = "../resc/hitbox_25x30.png" )] public static var IMPORT_HITBOX_25x30:Class;
		
// accessories
		// [Embed( source = "../resc/mouse_reticle.png" )] public static var MOUSE_RETICLE:Class;

// bg
		[Embed( source = "../resc/default_bg.jpg" )] public static var DEFAULT_BG:Class;

// particles
		[Embed( source = "../resc/particles/bullet_round.png" )] public static var BULLET_ROUND:Class;

// player
		[Embed( source = "../resc/chars/knight_body.png" )] public static var KNIGHT_BODY:Class;
		[Embed( source = "../resc/chars/knight_limbs.png" )] public static var KNIGHT_LIMBS:Class;
	}
}