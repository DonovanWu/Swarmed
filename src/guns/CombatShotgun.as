package guns 
{
	/**
	 * ...
	 * @author ...
	 */
	public class CombatShotgun extends BulletEmitter
	{
		
		public function CombatShotgun() 
		{
			super( {
				name : "Combat Shotgun",
				mobility : 0.9,
				ads_multi : 0.8,
				speed : 6,
				orpm : 400,
				damage : 17,
				range : 180,
				burst : 1,
				pellets: 8,
				mag_size : 10,
				ammo: 40,
				spread : { hip : 10, aim : 7 }
			});
		}
		
	}

}