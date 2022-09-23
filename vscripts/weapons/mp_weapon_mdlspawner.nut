untyped

global function OnWeaponPrimaryAttack_weapon_mdlspawner
global function MDLSpawner_Init

#if SERVER
global function OnWeaponNpcPrimaryAttack_weapon_mdlspawner
global function ClientCommand_SetMDLSpawnerModel
#endif // SERVER

const MASTIFF_BLAST_PATTERN_LEN = 1

struct {
	float[2][MASTIFF_BLAST_PATTERN_LEN] boltOffsets = [
		[0.0, 0.0], //
	]

	/*array boltOffsets = [
		[0.0, 0.0], // 
	]*/

	var model = $"mdl/dev/empty_model.rmdl"
} file


void function MDLSpawner_Init()
{
	#if SERVER
	printt("adding mdlspawner ccc")
	AddClientCommandCallback( "setmdl", ClientCommand_SetMDLSpawnerModel )
	#endif // SERVER
}

#if SERVER
bool function ClientCommand_SetMDLSpawnerModel( entity player, array<string> args )
{
	if(args.len() == 0)
		return true

	// string model = args[0]

	file.model = compilestring( "return $\"" + args[0] + "\"" )()

	return true
}
#endif

var function OnWeaponPrimaryAttack_weapon_mdlspawner( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireMastiff( attackParams, true, weapon )
}

#if SERVER
var function OnWeaponNpcPrimaryAttack_weapon_mdlspawner( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return FireMastiff( attackParams, false, weapon )
}
#endif // SERVER

int function FireMastiff( WeaponPrimaryAttackParams attackParams, bool playerFired, entity weapon )
{
	entity owner = weapon.GetWeaponOwner()
	bool shouldCreateProjectile = false
	#if SERVER
	MDLSpawner_SpawnModel()	
	#endif

	vector attackAngles = VectorToAngles( attackParams.dir )
	vector baseUpVec = AnglesToUp( attackAngles )
	vector baseRightVec = AnglesToRight( attackAngles )

	float zoomFrac
	if ( playerFired )
		zoomFrac = owner.GetZoomFrac()
	else
		zoomFrac = 0.5

	float spreadFrac = Graph( zoomFrac, 0, 1, 0.05, 0.025 ) * 1.0

	int boltsPerShot = weapon.GetProjectilesPerShot()
	Assert( boltsPerShot <= MASTIFF_BLAST_PATTERN_LEN, "Not enough points in blast pattern to fire " + boltsPerShot + " bolts; check MASTIFF_BLAST_PATTERN_LEN in script" )

	if ( shouldCreateProjectile )
	{
		weapon.EmitWeaponNpcSound( LOUD_WEAPON_AI_SOUND_RADIUS_MP, 0.2 )

		for ( int index = 0; index < boltsPerShot; index++ )
		{
			vector upVec = baseUpVec * file.boltOffsets[index][0] * spreadFrac
			vector rightVec = baseRightVec * file.boltOffsets[index][1] * spreadFrac
			vector attackDir = attackParams.dir + upVec + rightVec

			bool ignoreSpread = true  // don't use the normal code spread for this weapon (ie, slightly adjusting outgoing round angle within spread cone)
			bool deferred = index > (boltsPerShot / 2)
			entity bolt = FireBallisticRoundWithDrop( weapon, attackParams.pos, attackDir, playerFired, ignoreSpread, index, deferred )

			if ( IsValid( bolt ) )
			{
				if ( owner.IsPlayer() )
				{
#if CLIENT
					EmitSoundOnEntity( bolt, "weapon_mastiff_projectile_crackle" )
#else //
					EmitSoundOnEntityExceptToPlayer( bolt, owner, "weapon_mastiff_projectile_crackle" )
#endif //
				}
				else
				{
					EmitSoundOnEntity( bolt, "weapon_mastiff_projectile_crackle" )
				}
			}
		}
	}

	return 1
}


void function MDLSpawner_SpawnModel( )
{
	#if SERVER
	entity player = GetPlayerArray()[0]
	TraceResults tr = TraceLine(
		player.EyePosition(), player.EyePosition() + 300.0 * player.GetViewVector(),
		[ player ], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE
	)

	// Dev_SpawnAllLootTypes( tr.endPos, <100, 100, 0>, <100, 100, 0>, 5 )

	var model = file.model
	printt( "spawning model", model )
	PrecacheModel( model )
	entity ent = CreateEntity( "prop_dynamic" )
	ent.SetValueForModelKey( model )
	ent.SetOrigin( tr.endPos )
	ent.SetAngles( AnglesCompose( VectorToAngles( FlattenNormalizeVec( tr.endPos - player.GetOrigin() ) ), <0, -90, 0> ) )
	ent.kv.solid = SOLID_VPHYSICS
	ent.Solid()
	DispatchSpawn( ent )
	#endif // SERVER
}
