package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class LightMachineGun extends BulletEmitter {
		
		public function LightMachineGun() {
			super( {
				name : "Light Machine Gun",
				mobility : 0.8,
				ads_multi : 0.5,
				speed : 8,
				orpm : 600,
				damage : 25,
				burst : 0,
				pellets: 1,
				mag_size : 100,
				ammo: 200,
				spread : { hip : 9, aim : 1.5 }
			});
		}
	}
}