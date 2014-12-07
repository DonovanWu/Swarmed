package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Revolver extends BulletEmitter {
		
		public function Revolver() {
			super( {
				name : "Revolver",
				type : "pistol",
				mobility : 1,
				ads_multi : 0.8,
				speed : 8,
				orpm : 750,
				damage : 50,
				burst : 1,
				pellets: 1,
				mag_size : 6,
				ammo: 36,
				spread : { hip : 9, aim : 1 }
			});
		}
	}
}