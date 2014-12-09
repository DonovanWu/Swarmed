package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class RocketLauncher extends BulletEmitter {
		
		public function RocketLauncher() {
			super( {
				name : "Rocket Launcher",
				mobility : 0.8,
				ads_multi : 0.5,
				speed : 6,
				orpm : 840,
				damage : 40,
				burst : 1,
				pellets: 1,
				mag_size : 3,
				ammo: 30,
				spread : { hip : 0, aim : 0 },
				spawn : "rocket"
			});
		}
	}
}