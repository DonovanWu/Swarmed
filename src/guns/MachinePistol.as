package guns 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class MachinePistol extends BulletEmitter {
		
		public function MachinePistol() {
			super( {
				name : "Machine Pistol",
				type : "pistol",
				mobility : 1,
				ads_multi : 0.8,
				speed : 8,
				orpm : 900,
				damage : 17,
				burst : 0,
				pellets: 1,
				mag_size : 20,
				ammo: 120,
				spread : { hip : 6, aim : 3 }
			});
		}
	}
}