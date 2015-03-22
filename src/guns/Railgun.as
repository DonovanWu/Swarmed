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
				speed : 18,
				orpm : 60,
				damage : 600,
				burst : 1,
				pellets: 1,
				mag_size : 1,
				ammo: 30,
				spread : { hip : 10, aim : 0 },
				spawn : "railgun"
			});
		}
		
	}

}