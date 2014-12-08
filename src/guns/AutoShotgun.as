package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class AutoShotgun extends BulletEmitter {
		
		public function AutoShotgun() {
			super( {
				name : "Assualt Shotgun",
				mobility : 0.9,
				ads_multi : 0.8,
				speed : 6,
				orpm : 400,
				damage : 18,
				range : 150,
				burst : 0,
				pellets: 6,
				mag_size : 20,
				ammo: 60,
				spread : { hip : 10, aim : 7 }
			});
		}
	}
}