package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class BurstRifle extends BulletEmitter {
		
		public function BurstRifle() {
			super( {
				name : "Bulp-up Rifle",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 8,
				orpm : 480,
				brom : 1000,
				damage : 34,
				burst : 3,
				pellets: 1,
				mag_size : 30,
				ammo: 180,
				spread : { hip : 10, aim : 1 }
			});
		}
	}
}