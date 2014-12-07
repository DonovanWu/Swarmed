package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class BurstShotgun extends BulletEmitter {
		
		public function BurstShotgun() {
			super( {
				name : "Tactical Shotgun",
				mobility : 0.9,
				ads_multi : 0.8,
				speed : 6,
				orpm : 240,
				brpm : 450,
				damage : 15,
				range : 180,
				burst : -4,
				pellets: 8,
				mag_size : 16,
				ammo: 64,
				spread : { hip : 10, aim : 7 }
			});
		}
	}
}