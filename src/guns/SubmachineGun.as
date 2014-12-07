package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class SubmachineGun extends BulletEmitter {
		
		public function SubmachineGun() {
			super( {
				name : "Submachine Gun",
				mobility : 1,
				ads_multi : 0.8,
				speed : 8,
				orpm : 1000,
				damage : 19,
				burst : 0,
				pellets: 1,
				mag_size : 36,
				ammo: 216,
				spread : { hip : 6, aim : 3 }
			});
		}
	}
}