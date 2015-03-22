package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Railgun extends BulletEmitter
	{
		
		public function Railgun() 
		{
			// different bullet
			super( {
				name : "Railgun",
				mobility : 0.9,
				ads_multi : 0.6,
				speed : 15,
				orpm : 90,
				damage : 540,
				burst : 1,
				pellets: 1,
				mag_size : 1,
				ammo: 30,
				spread : { hip : 15, aim : 0 },
				spawn : "railgun"
			});
		}
		
	}

}