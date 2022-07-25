global function OnWeaponPrimaryAttack_Clickweapon

var function OnWeaponPrimaryAttack_Clickweapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	entity player = weapon.GetWeaponOwner()
	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, weapon.GetWeaponDamageFlags() )
	#if SERVER
		if(!player.p.isChallengeActivated) return
		int basedamage = weapon.GetWeaponSettingInt( eWeaponVar.damage_near_value )
		int ornull projectilespershot = weapon.GetWeaponSettingInt( eWeaponVar.projectiles_per_shot )
		int pellets = 1
		if(projectilespershot != null)
		{
			pellets = expect int(projectilespershot)
			player.p.totalPossibleDamage += (basedamage * pellets)
		}
		else 
			player.p.totalPossibleDamage += basedamage
		
		//add 1 hit to total hits
		player.p.straferTotalShots += (1*pellets)
		
		
		Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIDamageViaWeaponAttack", basedamage, basedamage * pellets)
		Remote_CallFunction_NonReplay(player, "ServerCallback_LiveStatsUIAccuracyViaTotalShots", pellets)
	#endif
	return 0
}