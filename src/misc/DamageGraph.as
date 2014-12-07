package misc 
{
	/**
	 * ...
	 * @author ...
	 */
	public class DamageGraph 
	{
		private var dmg:Array;
		private var rg:Array;
		
		public function DamageGraph() 
		{
			dmg = [];
			rg = [];
		}
		
		public function add_new_point(x:int, y:int):void {
			if (isEmpty()) {
				// push initial damage
				rg.push(0);
				dmg.push(y);
			}
			
			rg.push(x);
			dmg.push(y);
		}
		
		public function get_damage(range:Number):int {
			if (isEmpty()) {
				return 0;
			}
			
			for (var k:int = 1; k < rg.length; k++) {
				if (rg[k] >= range && rg[k-1] < range) {
					return dmg[k];
				}
			}
			
			// not found?
			return 0;
		}
		
		public function isEmpty():Boolean {
			return dmg.length == 0 && rg.length == 0;
		}
	}

}