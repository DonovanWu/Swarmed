package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class MarksmanRifle extends BulletEmitter {
		
		public function MarksmanRifle() {
			super( {
				name : "Marksman Rifle",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 8,
				orpm : 576,
				damage : 45,
				burst : 1,
				pellets: 1,
				mag_size : 20,
				ammo: 120,
				spread : { hip : 10, aim : 0 }
			});
		}
	}
}