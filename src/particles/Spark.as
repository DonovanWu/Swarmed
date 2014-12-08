package particles 
{
	/**
	 * A kind of particle that spawn for a short life span on stage
	 * @author Wenrui (Donovan) Wu
	 */
	public class Spark extends Particle
	{
		public var anim_name:String;
		
		public static const SPARK:String = "spark";
		public static const BLOOD:String = "blood";
		
		public function Spark(x:int = 0, y:int = 0, ang:Number = 0, graphic:String = "spark") 
		{
			super(x, y);
			
			this.loadGraphic(Imports.IMPORT_SPARK, true, false, 20, 5);
			this.addAnimation(SPARK, [0, 1], 60);
			this.addAnimation(BLOOD, [2, 3], 60);
			
			this.setOriginToCorner();
			this.angle = ang;
			
			anim_name = graphic;
		}
	
		override public function update_particle(game:GameEngine):void {
			this.play(anim_name);
		}
		
		override public function should_remove():Boolean {
			return this.finished;
		}
	}

}