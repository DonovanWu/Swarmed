package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class AK47 extends BulletEmitter
	{
		
		public function AK47() 
		{
			super( {
				name : "AK47",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 8,
				orpm : 600,
				damage : 33,
				burst : 0,
				pellets: 1,
				mag_size : 30,
				ammo: 180,
				spread : { hip : 10, aim : 4 }
			});
		}
		
	}

}