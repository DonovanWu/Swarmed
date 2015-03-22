package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class SniperRifle extends BulletEmitter
	{
		
		public function SniperRifle() 
		{
			// different bullet
			super( {
				name : "Sniper Rifle",
				mobility : 0.9,
				ads_multi : 0.6,
				speed : 12,
				orpm : 50,
				damage : 273,
				burst : 1,
				pellets: 1,
				mag_size : 5,
				ammo: 30,
				spread : { hip : 15, aim : 0 },
				spawn : "sniper"
			});
		}
		
	}

}