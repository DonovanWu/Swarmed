package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class PDW extends BulletEmitter {
		
		public function PDW() {
			super( {
				name : "PDW",
				type : "pistol",
				mobility : 1,
				ads_multi : 0.8,
				speed : 8,
				orpm : 600,
				brpm : 900,
				damage : 24,
				burst : 3,
				pellets: 1,
				mag_size : 15,
				ammo: 120,
				spread : { hip : 6, aim : 2 }
			});
		}
	}
}