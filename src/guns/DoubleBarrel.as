package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class DoubleBarrel extends BulletEmitter {
		
		public function DoubleBarrel() {
			super( {
				name : "Double Barrel",
				mobility : 0.9,
				ads_multi : 0.8,
				speed : 6,
				orpm : 300,
				damage : 20,
				range : 180,
				burst : 1,
				pellets: 8,
				mag_size : 2,
				ammo: 40,
				spread : { hip : 10, aim : 7 }
			});
		}
	}
}