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
				ads_multi : 0.5,
				speed : 8,
				orpm : 700,
				damage : 20,
				burst : 0,
				pellets: 1,
				mag_size : 30,
				ammo: 180,
				spread : { hip : 9, aim : 2.5 }
			});
		}
	}
}