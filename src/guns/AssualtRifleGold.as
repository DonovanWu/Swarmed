package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class AssualtRifleGold extends BulletEmitter {
		
		public function AssualtRifleGold() {
			super( {
				name : "Assualt Rifle - Gold",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 8,
				orpm : 800,
				damage : 28,
				burst : 0,
				pellets: 1,
				mag_size : 40,
				ammo: 240,
				spread : { hip : 9, aim : 1 }
			});
		}
	}
}