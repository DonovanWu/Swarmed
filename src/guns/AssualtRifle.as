package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class AssualtRifle extends BulletEmitter {
		
		public function AssualtRifle() {
			super( {
				name : "Assualt Rifle",
				mobility : 0.9,
				speed : 8,
				orpm : 750,
				damage : 20,
				burst : 0,
				pellets: 1,
				mag_size : 300,
				ammo: 600,
				spread : { hip : 9, aim : 2.5 },
				ads_mvspd : 0.5
			});
		}
	}
}