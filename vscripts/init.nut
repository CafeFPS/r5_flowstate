//========== Copyright � 2008, Valve Corporation, All rights reserved. ========
//  Purpose: Script initially run after squirrel VM is initialized
//
//  !!!NOTE: Reference script only; changes made to this script will not work in game.
//=============================================================================

global function printl
global function CodeCallback_Precompile

global struct EchoTestStruct
{
	int test1
	bool test2
	bool test3
	float test4
	vector test5
	int[5] test6
}

global struct TraceResults
{
	entity hitEnt
	vector endPos
	vector surfaceNormal
	string surfaceName
	int surfaceProp
	float fraction
	float fractionLeftSolid
	int hitGroup
	int staticPropID
	bool startSolid
	bool allSolid
	bool hitSky
	int contents
}

global struct VisibleEntityInCone
{
	entity ent
	vector visiblePosition
	int visibleHitbox
	bool solidBodyHit
	vector approxClosestHitboxPos
	int extraMods
}

global struct PlayerDidDamageParams
{
	entity victim
	vector damagePosition
	int hitBox
	int damageType
	float damageAmount
	int damageFlags
	int hitGroup
	entity weapon
	float distanceFromAttackOrigin
}

global struct Attachment
{
	vector position
	vector angle
}

global struct EntityScreenSpaceBounds
{
	float x0
	float y0
	float x1
	float y1
	bool outOfBorder
}

global struct BackendError
{
	int serialNum
	string errorString
}

global struct BrowseFilters
{
	string name
	string clantag
	string communityType
	string membershipType
	string category
	string playtime
	string micPolicy
	int pageNum
	int minMembers
}

global struct CommunitySettings
{
	int communityId
	bool verified
	bool doneResolving
	string name
	string clanTag
	string motd
	string communityType
	string membershipType
	string visibility
	string category
	string micPolicy
	string language1
	string language2
	string language3
	string region1
	string region2
	string region3
	string region4
	string region5
	int happyHourStart
	int matches
	int wins
	int losses
	string kills
	string deaths
	string xp
	int ownerCount
	int adminCount
	int memberCount
	int onlineNow
	bool invitesAllowed
	bool chatAllowed
	string creatorUID
	string creatorName
}

global struct CommunityMembership
{
	int communityId
	string communityName
	string communityClantag
	string membershipLevel
}

global struct CommunityFriends
{
	bool isValid
	array<string> ids
	array<string> hardware
	array<string> names
}

global struct CommunityFriendsData
{
	string id
	string hardware
	string name
	string presence
	bool online
	bool ingame
	bool away
}

global struct CommunityFriendsWithPresence
{
	bool isValid
	array<CommunityFriendsData> friends
}

global struct CommunityUserInfo
{
	string hardware
	string uid
	string name
	string kills
	int wins
	int matches
	int banReason
	int banSeconds
	int eliteStreak
	int rankScore
	int rankLadderPos
	int rankedLadderPos
	string rankedPeriodName
	int lastCharIdx
	bool isLivestreaming
	bool isOnline
	bool isJoinable
	bool partyFull
	bool partyInMatch
	float lastServerChangeTime
	string privacySetting
	array<int> charData

	int numCommunities
}

global struct PartyMember
{
	string name
	string uid
	string hardware
	bool ready
	bool present
}

global struct OpenInvite
{
	string inviteType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	array<PartyMember> members
}


global struct Party
{
	string partyType
	string playlistName
	string originatorName
	string originatorUID
	int numSlots
	int numClaimedSlots
	int numFreeSlots
	float timeLeft
	bool amIInThis
	bool amILeader
	bool searching
	array<PartyMember> members
}

global struct RemoteClientInfoFromMatchInfo
{
	string name
	int teamNum
	int score
	int kills
	int deaths
}

global struct RemoteMatchInfo
{
	string datacenter
	string gamemode
	string playlist
	string map
	int maxClients
	int numClients
	int maxRounds
	int roundsWonIMC
	int roundsWonMilitia
	int timeLimitSecs
	int timeLeftSecs
	int teamsLeft
	int maxScore
	array<RemoteClientInfoFromMatchInfo> clients
	array<int> teamScores
}

global struct InboxMessage
{
	int messageId
	string messageType
	bool deletable
	bool deleting
	bool reportable
	bool doneResolving

	string dateSent
	string senderHardware
	string senderUID
	string senderName
	int communityID
	string communityName
	string messageText
	string actionLabel
	string actionURL
}

global struct MainMenuPromos
{
	int prot,
	int version,
	string layout,
	string promoRpak,
	string miniPromoRpak
}

#if SERVER || UI
global struct MatchmakingDatacenterETA
{
	int datacenterIdx
	string datacenterName
	int latency
	int packetLoss
	int etaSeconds
	int idealStartUTC
	int idealEndUTC
}
#endif // #if SERVER || UI

#if SERVER || UI
global struct GRXCraftingOffer
{
	int itemIdx
	int craftingPrice
}

global struct GRXStoreOffer
{
	array< int > items
	array< array< int > > prices
	table< string, string > attrs
}
#endif // #if SERVER || UI

global struct GRXUserInfo
{
	int inventoryState

	int queryGoal
	int queryOwner
	int queryState
	int querySeqNum

	array< int > balances

	int marketplaceEdition

	bool isOfferRestricted
}

global struct VortexBulletHit
{
	entity vortex
	vector hitPos
}

global struct AnimRefPoint
{
	vector origin
	vector angles
}

global struct LevelTransitionStruct
{
	// only ints, floats, bools, vectors, and other structs or fixed-size arrays containing those are allowed.
	// "ornull" may also be used.

	int startPointIndex

	int[3] ints

	int[2] pilot_mainWeapons = [-1,-1]
	int[2] pilot_offhandWeapons = [-1,-1]
	int ornull[2] pilot_weaponMods = [null,null]
	int pilot_ordnanceAmmo = -1

	int titan_mainWeapon = -1
	int titan_unlocksBitfield = 0

	int difficulty = 0
}

global struct WeaponOwnerChangedParams
{
	entity oldOwner
	entity newOwner
}

global struct WeaponTossPrepParams
{
	bool isPullout
}

global struct WeaponPrimaryAttackParams
{
	vector pos
	vector dir
	bool firstTimePredicted
	int burstIndex
	int barrelIndex
}

global struct WeaponBulletHitParams
{
	entity hitEnt
	vector startPos
	vector hitPos
	vector hitNormal
	vector dir
}

global struct WeaponFireBulletSpecialParams
{
	vector pos
	vector dir
	int bulletCount
	int scriptDamageType
	bool skipAntiLag
	bool dontApplySpread
	bool doDryFire
	bool noImpact
	bool noTracer
	bool activeShot
	bool doTraceBrushOnly
}

global struct WeaponFireBoltParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	int additionalRandomSeed
	bool dontApplySpread
	int projectileIndex
	bool deferred
}

global struct WeaponFireGrenadeParams
{
	vector pos
	vector vel
	vector angVel
	float fuseTime
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool clientPredicted
	bool lagCompensated
	bool useScriptOnDamage
	bool isZiplineGrenade = false
	int projectileIndex
}

global struct WeaponFireMissileParams
{
	vector pos
	vector dir
	float speed
	int scriptTouchDamageType
	int scriptExplosionDamageType
	bool doRandomVelocAndThinkVars
	bool clientPredicted
	int projectileIndex
}

global struct ModInventoryItem
{
	int slot
	string mod
	string weapon
	int count
}

global struct OpticAppearanceOverride
{
	array<string>	bodygroupNames
	array<int>		bodygroupValues
	array<string>	uiDataNames
}

global struct ConsumableInventoryItem
{
	int slot
	int type
	int count
}

global struct PingCollection
{
	entity latestPing
	array<entity> locations
	array<entity> loots
}

global struct HudInputContext
{
	bool functionref(int) keyInputCallback
	bool functionref(float, float) viewInputCallback
	bool functionref(float, float) moveInputCallback
	int hudInputFlags
}

global struct SmartAmmoTarget
{
	entity ent
	float fraction
	float prevFraction
	bool visible
	float lastVisibleTime
	bool activeShot
	float trackTime
}

global struct StaticPropRui
{
	//------------------------------
	// These values are ignored by RuiCreateOnStaticProp. They are given to ClientCodeCallback_OnEnumStaticPropRui to be informative.
	//
	// If you create a StaticPropRui struct from scratch to pass to RuiCreateOnStaticProp, you can leave these blank.

	string scriptName           // "script_name" in LevelEd.
	string mockupName           // Name of the mockup material in Maya.
	string modelName            // Name of the model.
	vector spawnOrigin			// World coordinates of the model's origin when spawned. Parented static props can move away from here.
	vector spawnMins			// Minimum world coordinates of the model's bounding box when spawned. This can be wrong for parented static props once the level starts.
	vector spawnMaxs			// Maximum world coordinates of the model's bounding box when spawned. This can be wrong for parented static props once the level starts.

	vector spawnForward
	vector spawnRight
	vector spawnUp

	//------------------------------
	// These values are used by RuiCreateOnStaticProp to create a RUI on a static prop.
	// They are initialized to default values in ClientCodeCallback_OnEnumStaticPropRui.
	// You can change them to customize behavior.
	//
	// If you create a StaticPropRui struct from scratch to pass to RuiCreateOnStaticProp, you must initialize "ruiName", but "args" can be left empty.

	asset ruiName               //
	table<string, string> args  //

	//------------------------------
	// This magic number is how code knows which prop and RUI mesh to use for the topology. Do not remember this across levels, and do not modify it.
	// If you want to remember a RUI mesh on a static prop at startup so that you can create a RUI on it later, this is all you have to remember.
	//
	// If you create a StaticPropRui struct from scratch to pass to RuiCreateOnStaticProp, this must be initialized to the value you remembered from
	// ClientCodeCallback_OnEnumStaticPropRui.

	int magicId
}

global struct ScriptAnimWindow
{
	entity ent
	asset settingsAsset
	string stringID
	string windowName
	float startCycle
	float endCycle
}

global struct ZiplineStationSpots
{
	asset beginStationModel
	vector beginStationOrigin
	vector beginStationAngles
	entity beginStationMoveParent
	string beginStationAnimation
	vector beginZiplineOrigin

	asset endStationModel
	vector endStationOrigin
	vector endStationAngles
	entity endStationMoveParent
	string endStationAnimation
	vector endZiplineOrigin
}

global struct WaypointClusterInfo
{
	vector clusterPos
	int numPointsNear
}

global struct NavMesh_FindMeshPath_Result
{
	bool navMeshOK
	bool startPolyOK
	bool goalPolyOK
	bool pathFound
	array<vector> points
}

global typedef SettingsAssetGUID int

//-----------------------------------------------------------------------------
// General
//-----------------------------------------------------------------------------

void function printl( var text )
{
	return print( text + "\n" )
}

void function CodeCallback_Precompile()
{
#if DEVELOPER
	// save the const table for later printing when documenting code consts
	//if ( Dev_CommandLineHasParm( "-scriptdocs" ) )
		getroottable().originalConstTable <- clone getconsttable()
#endif
}

