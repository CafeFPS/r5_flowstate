global function OnWeaponActivate_weapon_melee_primary
global function OnWeaponDeactivate_weapon_melee_primary
global function OnWeaponActivate_vctblue

void function OnWeaponActivate_weapon_melee_primary( entity weapon )
{
}

void function OnWeaponDeactivate_weapon_melee_primary( entity weapon )
{
}

void function OnWeaponActivate_vctblue( entity weapon )
// By CafeFPS
{
	entity player = weapon.GetWeaponOwner()
	weapon.kv.rendercolor = player.p.snd_knifecolor

	thread function () : ( weapon )
	{
		Signal( weapon, "VCTBlueFX" )
		EndSignal( weapon, "VCTBlueFX" )
		EndSignal( weapon, "OnDestroy" )

		float endTime
		float frac
		string current
		float startTime
		vector startColor
		vector endColor

		float colorResultX
		float colorResultY
		float colorResultZ

		for( ;; )
		{
			if( Time() > endTime )
			{
				startTime = Time()
				endTime = startTime + 3
			
				current = expect string ( weapon.kv.rendercolor )
				startColor = < split( current, " " )[0].tointeger(), split( current, " " )[1].tointeger(), split( current, " " )[2].tointeger() >
				endColor = Vector( RandomInt( 255 ), RandomInt( 255 ), RandomInt( 255 ) )
			}

			colorResultX = GraphCapped( Time(), startTime, endTime, startColor.x, endColor.x )
			colorResultY = GraphCapped( Time(), startTime, endTime, startColor.y, endColor.y )
			colorResultZ = GraphCapped( Time(), startTime, endTime, startColor.z, endColor.z )

			string colorString = colorResultX + " " + colorResultY + " " + colorResultZ

			weapon.kv.rendercolor = colorString

			WaitFrame()
		}
	}()
}