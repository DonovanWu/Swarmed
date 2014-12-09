package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Handgun extends BulletEmitter {
		
		public function Handgun() {
			super( {
				name : "Handgun",
				type : "pistol",
				mobility : 1,
				ads_multi : 0.8,
				speed : 8,
				orpm : 750,
				damage : 15,
				burst : 1,
				pellets: 1,
				mag_size : 15,
				ammo: 60,
				spread : { hip : 6, aim : 3 }
			});
		}
	}
}