package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AMR extends BulletEmitter
	{
		
		public function AMR() 
		{
			super( {
				name : "Anti-materiel Rifle",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 10,
				orpm : 450,
				damage : 200,
				burst : 1,
				pellets: 1,
				mag_size : 8,
				ammo: 32,
				spread : { hip : 20, aim : 0 },
				spawn : "sniper"
			});
		}
		
	}

}