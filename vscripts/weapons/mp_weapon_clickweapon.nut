//Lightning Gun
//Made by @CafeFPS
//-- everyone else: advice

untyped 

global function OnWeaponPrimaryAttack_Clickweapon
global function OnWeaponActivate_Clickweapon
global function OnWeaponDeactivate_Clickweapon

global function Clickweapon_Init

#if CLIENT
//for settings ui
global function LGDuels_SetR
global function LGDuels_SetG
global function LGDuels_SetB
global function LGDuels_SetPositionOffset
global function LGDuels_SetSettingsMenuOpen
global function LGDuels_SetModifyingLocalBeam
global function LGDuels_SetPresetRed
global function LGDuels_SetPresetGreen
global function LGDuels_SetPresetYellow
global function LGDuels_SetPresetBlue
global function LGDuels_SetPresetPurple

int DesiredR = 89
int DesiredG = 232
int DesiredB = 37
int DesiredEnemyR = 252
int DesiredEnemyG = 3
int DesiredEnemyB = 227
vector chosenColor
vector chosenEnemyColor
float positionOffset = -30
bool isSettingsMenuOpen = false
bool modifyingLocalBeam = true
#endif

const asset TheBestAssetInTheGame = $"P_tesla_trap_link_CP"

struct{
	#if CLIENT
		table<entity, int> beamsFxs = {}
		table<entity, entity> handmover
		table<entity, entity> beammover
		table<entity, entity> healthBars
	#endif
}file

void function Clickweapon_Init()
{
	RegisterSignal( "EndLaser" )
	RegisterSignal( "EndNoAutoThread" )
	RegisterSignal( "PlayerStartShotingLightningGun" )

	#if CLIENT
	AddCreateCallback( "player", FS_LG_OnPlayerCreated )
	AddDestroyCallback( "player", FS_LG_OnPlayerDestroyed )
	
	chosenColor = < DesiredR, DesiredG, DesiredB >
	SetConVarFloat( "hud_setting_showLevelUp", positionOffset )
	SetConVarInt( "noise_filter_scale", DesiredR )
	SetConVarInt( "net_minimumPacketLossDC", DesiredG )
	SetConVarInt( "net_wifi", DesiredB )
	chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >
	#endif
	
	#if SERVER
	AddCallback_OnWeaponAttack( FS_LG_PlayerStartShooting )
	#endif
}

void function OnWeaponActivate_Clickweapon( entity weapon ) 
{
	#if CLIENT
	if ( InPrediction() && !IsFirstTimePredicted() )
		return

	entity sPlayer = weapon.GetWeaponOwner()

	if( !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return
	
	bool isAuto = !weapon.GetWeaponSettingBool( eWeaponVar.is_semi_auto )

	thread function () : ( weapon, sPlayer, isAuto ) 
	{
		Signal( sPlayer, "EndLaser" )
		EndSignal( sPlayer, "EndLaser" )

		while( IsValid( sPlayer ) && IsValid( sPlayer.GetActiveWeapon( eActiveInventorySlot.mainHand ) ) && sPlayer.GetActiveWeapon( eActiveInventorySlot.mainHand ) == weapon )
		{
			if( sPlayer.IsInputCommandHeld( IN_ATTACK ) && isAuto || isSettingsMenuOpen && modifyingLocalBeam || !isAuto && sPlayer.IsInputCommandPressed( IN_ATTACK ) )
			{
				entity player = GetLocalViewPlayer()

				vector origin = player.GetCrosshairTraceEndPos()
				
				entity moverForLaserEnt 
				
				if( !(player in file.beammover) || player in file.beammover && !IsValid( file.beammover[player] ) )
					file.beammover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
				
				moverForLaserEnt = file.beammover[ player ]
				moverForLaserEnt.SetOrigin( origin )

				int fxIDTeam = GetParticleSystemIndex( TheBestAssetInTheGame )

				if( !EffectDoesExist( file.beamsFxs[ player ] ) )
				{
					file.beamsFxs[ player ] = StartParticleEffectOnEntityWithPos( player, fxIDTeam, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, AnglesToRight( player.GetViewVector() ) * positionOffset + <0,0,40>, <0, 0, 0> )
					EffectSetDontKillForReplay( file.beamsFxs[ player ] )
					EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, moverForLaserEnt, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0> )
					EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenColor )
				} else
				{
					EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, moverForLaserEnt, FX_PATTACH_CUSTOMORIGIN_FOLLOW, -1, <0, 0, 0> )
				}
				
				if( !isAuto )
				{
					float endtime = Time() + 0.1
					
					while( Time() <= endtime )
						WaitFrame()
					
					continue
				}
			} else
			{
				if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) && sPlayer == GetLocalViewPlayer() )
				{
					EffectStop( file.beamsFxs[ sPlayer ], false, true )
				}
			}

			WaitFrame()
		}
	}()
	#endif
}

var function OnWeaponPrimaryAttack_Clickweapon( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	#if CLIENT
	if ( InPrediction() && !IsFirstTimePredicted() )
		return
	#endif

	if( !IsValid( weapon ) )
		return

	weapon.FireWeaponBullet( attackParams.pos, attackParams.dir, 1, weapon.GetWeaponDamageFlags() )
	entity player = weapon.GetWeaponOwner()

	//The following code is only for the aim trainer stats
	#if SERVER
	if( GetCurrentPlaylistName() == "fs_lgduels_1v1" )
	{
		if( player.p.totalLGShots > 0 )
		{
			int acurracy = int( ( float( player.p.totalLGHits ) / float( player.p.totalLGShots ) )*100 )
			player.SetPlayerNetInt( "accuracy", acurracy )
		}
		
		player.p.totalLGShots++
	}

	if( GameRules_GetGameMode() != "fs_aimtrainer" ) 
		return

	if(!player.p.isChallengeActivated) 
		return

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

void function OnWeaponDeactivate_Clickweapon( entity weapon ) 
{
	entity player = weapon.GetWeaponOwner()
	
	if( !IsValid( player ) )
		return

	Signal( player, "EndLaser" )
	
	#if SERVER
	if( player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) )
		player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", false )
	#endif

	#if CLIENT
	if( player == GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
	{
		EffectStop( file.beamsFxs[ player ], false, true )
	}
	#endif
}


#if CLIENT
void function LGDuels_SetPresetRed( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 0
		DesiredB = 0

		SetConVarInt( "noise_filter_scale", DesiredR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredG )
		SetConVarInt( "net_wifi", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = 255
		DesiredEnemyG = 0
		DesiredEnemyB = 0

		SetConVarInt( "noise_filter_scale", DesiredEnemyR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredEnemyG )
		SetConVarInt( "net_wifi", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetBlue( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 0
		DesiredG = 0
		DesiredB = 255

		SetConVarInt( "noise_filter_scale", DesiredR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredG )
		SetConVarInt( "net_wifi", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = 0
		DesiredEnemyG = 0
		DesiredEnemyB = 255

		SetConVarInt( "noise_filter_scale", DesiredEnemyR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredEnemyG )
		SetConVarInt( "net_wifi", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetYellow( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 255
		DesiredB = 0

		SetConVarInt( "noise_filter_scale", DesiredR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredG )
		SetConVarInt( "net_wifi", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = 255
		DesiredEnemyG = 255
		DesiredEnemyB = 0

		SetConVarInt( "noise_filter_scale", DesiredEnemyR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredEnemyG )
		SetConVarInt( "net_wifi", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetGreen( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 0
		DesiredG = 255
		DesiredB = 0

		SetConVarInt( "noise_filter_scale", DesiredR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredG )
		SetConVarInt( "net_wifi", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = 0
		DesiredEnemyG = 255
		DesiredEnemyB = 0

		SetConVarInt( "noise_filter_scale", DesiredEnemyR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredEnemyG )
		SetConVarInt( "net_wifi", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPresetPurple( bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = 255
		DesiredG = 0
		DesiredB = 255

		SetConVarInt( "noise_filter_scale", DesiredR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredG )
		SetConVarInt( "net_wifi", DesiredB )

		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = 255
		DesiredEnemyG = 0
		DesiredEnemyB = 255

		SetConVarInt( "noise_filter_scale", DesiredEnemyR )
		SetConVarInt( "net_minimumPacketLossDC", DesiredEnemyG )
		SetConVarInt( "net_wifi", DesiredEnemyB )

		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetModifyingLocalBeam( bool modifyingLocalBeam )
{
	modifyingLocalBeam = modifyingLocalBeam
}

void function LGDuels_SetSettingsMenuOpen( bool open )
{
	isSettingsMenuOpen = open
	if( open )
	{
		ForceHide1v1Scoreboard( )
	} else {
		ForceShow1v1Scoreboard( )
	}
}

void function LGDuels_SetR( int R, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredR = R
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyR = R
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetG( int G, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredG = G
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyG = G
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetB( int B, bool isLocalChosen )
{
	if( isLocalChosen )
	{
		DesiredB = B
		chosenColor = < DesiredR, DesiredG, DesiredB >

		entity sPlayer = GetLocalViewPlayer()

		if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
		{
			EffectSetControlPointVector( file.beamsFxs[ sPlayer ], 2, chosenColor )
		}
	} else {
		DesiredEnemyB = B
		chosenEnemyColor = < DesiredEnemyR, DesiredEnemyG, DesiredEnemyB >

		foreach( player in GetPlayerArray() )
			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() && player != GetLocalViewPlayer() && player in file.beamsFxs && EffectDoesExist( file.beamsFxs[ player ] ) )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
	}
}

void function LGDuels_SetPositionOffset( float offset )
{
	positionOffset = offset

	entity sPlayer = GetLocalViewPlayer()

	if( sPlayer in file.beamsFxs && EffectDoesExist( file.beamsFxs[ sPlayer ] ) )
	{
		EffectStop( file.beamsFxs[ sPlayer ], false, true )
	}
}

void function FS_LG_OnPlayerCreated( entity player )
{
	if ( !IsValid( player ) ) 
		return

	if( !( player in file.beammover ) )
	{
		file.beammover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	}

	if( !( player in file.handmover ) )
	{
		file.handmover[player] <- CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", <0, 0, 0>, <0, 0, 0> )
	}

	if( !( player in file.beamsFxs ) )
	{
		file.beamsFxs[player] <- -1
	}

	if( !( player in file.healthBars ) )
	{
		file.healthBars[player] <- CreateClientsideVGuiScreen( "flowstate_health_bar", VGUI_SCREEN_PASS_WORLD, <0, 0, 0>, <0, 0, 0>, 3, 45 )
	}

	thread FS_LG_HandleLaserForPlayer( player )
	
	if( GetCurrentPlaylistName() != "fs_lgduels_1v1" )
		return

	Flowstate_CreateCustomHealthBarForPlayer( player )
}

void function FS_LG_HandleLaserForPlayer( entity player )
{
	FlagWait( "EntitiesDidLoad" ) // for dev

	if( !IsValid( player ) || player == GetLocalViewPlayer() ) 
		return

	entity mover = file.beammover[player]
	entity handmover = file.handmover[player]

	int fx = file.beamsFxs[ player ]

	bool wasPlayerShooting = false
	while( IsValid( player ) && IsValid( mover ) )
	{
		if( !EffectDoesExist( file.beamsFxs[ player ] ) && player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) && !wasPlayerShooting )
		{
			if( player.LookupAttachment( "R_HAND" ) != -1 )
				handmover.SetParent( player, "R_HAND" )
			else
				handmover.SetParent( player )
			//create a mover for the hand/weapon
			file.beamsFxs[ player ] = StartParticleEffectOnEntityWithPos( handmover, GetParticleSystemIndex( TheBestAssetInTheGame ), FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 0>, <0, 0, 0> )
			EffectSetDontKillForReplay( file.beamsFxs[ player ] )

			if( player.GetTeam() != GetLocalViewPlayer().GetTeam() )
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenEnemyColor )
			else
				EffectSetControlPointVector( file.beamsFxs[ player ], 2, chosenColor )

			EffectAddTrackingForControlPoint( file.beamsFxs[ player ], 1, mover, FX_PATTACH_ABSORIGIN_FOLLOW, -1, <0, 0, 3> )
			wait 0.01
			continue
		}

		if( EffectDoesExist( file.beamsFxs[ player ] ) && !player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) && wasPlayerShooting || !player.DoesShareRealms( GetLocalViewPlayer() ) || !IsAlive( player ) )
		{
			EffectStop( file.beamsFxs[ player ], false, false )
		}
		
		wasPlayerShooting = player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" )
		mover.NonPhysicsMoveTo( EyeTraceVec( player ), 0.0001, 0, 0 )
		
		WaitFrame()
	}
}

// cool health bars, im insane
void function Flowstate_CreateCustomHealthBarForPlayer( entity player ) 
{
	entity vgui
	
	if( player in file.healthBars )
	{
		vgui = file.healthBars[player]
	} else
	{
		vgui = CreateClientsideVGuiScreen( "flowstate_health_bar", VGUI_SCREEN_PASS_WORLD, player.GetOrigin() + AnglesToUp( player.GetAngles() ) * 80 + AnglesToRight( GetLocalViewPlayer().CameraAngles() ) * 20, <0, 0, 0>, 3, 45 )
		file.healthBars[player] <- vgui
	}
	
	if( !IsValid( vgui ) )
		return

	vgui.SetParent( player )
	thread Flowstate_CustomHealthBar_FaceVguiToPlayer( player, vgui )
}

void function Flowstate_CustomHealthBar_FaceVguiToPlayer( entity player, entity vgui )
{
	//todo desharcodear 80, quizá tomar el headfocus
	local foreground = HudElement( "HealthBar_Foreground", vgui.GetPanel() )
	local background = HudElement( "HealthBar_Background", vgui.GetPanel() )
	int baseHeight = 280
	
	while( true )
	{
		WaitFrame()

		if( !IsValid( player ) )
			break
		
		if( !IsValid( vgui ) )
		{
			vgui = CreateClientsideVGuiScreen( "flowstate_health_bar", VGUI_SCREEN_PASS_WORLD, player.GetOrigin() + AnglesToUp( player.GetAngles() ) * 80 + AnglesToRight( GetLocalViewPlayer().CameraAngles() ) * 20, <0, 0, 0>, 3, 45 )
			vgui.SetParent( player )
			file.healthBars[player] = vgui
		}

		if( !IsAlive( player ) || !player.DoesShareRealms( GetLocalViewPlayer() ) || player == GetLocalViewPlayer() )
		{
			foreground.Hide()
			background.Hide()
			continue
		}

		foreground.Show()
		background.Show()

		int health = player.GetHealth()
		float Width = float( health * baseHeight ) / player.GetMaxHealth()
		foreground.SetHeight( Width )

		//make it face view player
		vector closestPoint = GetClosestPointOnLine( GetLocalViewPlayer().CameraPosition(), GetLocalViewPlayer().CameraPosition() + (AnglesToRight( GetLocalViewPlayer().CameraAngles() ) * 100.0), vgui.GetOrigin() )		
		vector angles = VectorToAngles( vgui.GetOrigin() - closestPoint )
		vgui.SetAngles( Vector( -90, angles.y, 0 ) )
		vgui.SetOrigin( player.GetOrigin() + AnglesToUp( player.GetAngles() ) * 80 + AnglesToRight( GetLocalViewPlayer().CameraAngles() ) * 20 )
	}
}

void function FS_LG_OnPlayerDestroyed( entity player )
{
	if ( !IsValid( player ) )
		return

	if( player in file.healthBars )
	{
		if( IsValid( file.healthBars[player] ) )
			file.healthBars[ player ].Destroy()
		delete file.healthBars[player]
	}

	if( player in file.beammover )
	{
		if( IsValid( file.beammover[player] ) )
			file.beammover[ player ].Destroy()
		delete file.beammover[player]
	}

	if( player in file.handmover )
	{
		if( IsValid( file.handmover[player] ) )
			file.handmover[ player ].Destroy()
		delete file.handmover[player]
	}

	if( player in file.beamsFxs )
	{
		if( EffectDoesExist( file.beamsFxs[ player ] ) )
			EffectStop( file.beamsFxs[ player ], false, true )
		delete file.beamsFxs[player]
	}
}
#endif

#if SERVER
void function FS_LG_PlayerStartShooting( entity player, entity weapon, string weaponName, int ammoUsed, vector attackOrigin, vector attackDir )
{
	if ( !IsValid( player ) || !IsValid( weapon ) || weapon.GetWeaponClassName() != "mp_weapon_lightninggun" )
		return
	
	thread FS_LG_PlayerStartShooting_Thread( player, weapon ) 
}

void function FS_LG_PlayerStartShooting_Thread( entity player, entity weapon )
{
	if( !player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) )
		player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", true )

	Signal( player, "PlayerStartShotingLightningGun" )
	EndSignal( player, "PlayerStartShotingLightningGun" )

	wait 0.1
	
	if( !IsValid( player ) )
		return

	if( player.GetPlayerNetBool( "isPlayerShootingFlowstateLightningGun" ) )
		player.SetPlayerNetBool( "isPlayerShootingFlowstateLightningGun", false )
}
#endif