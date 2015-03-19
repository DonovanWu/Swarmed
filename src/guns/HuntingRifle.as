package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class HuntingRifle extends BulletEmitter
	{
		
		public function HuntingRifle() 
		{
			super( {
				name : "Hunting Rifle",
				mobility : 0.9,
				ads_multi : 0.5,
				speed : 10,
				orpm : 60,
				damage : 200,
				burst : 1,
				pellets: 1,
				mag_size : 5,
				ammo: 20,
				spread : { hip : 15, aim : 0 }
			});
		}
		
	}

}