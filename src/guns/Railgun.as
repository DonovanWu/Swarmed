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
			// use different bullet?
			super( {
				name : "Railgun",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 10,
				orpm : 60,
				damage : 450,
				burst : 1,
				pellets: 1,
				mag_size : 1,
				ammo: 30,
				spread : { hip : 10, aim : 0 }
			});
		}
		
	}

}