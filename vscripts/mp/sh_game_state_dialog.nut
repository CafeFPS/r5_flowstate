global function GameStateDialog_Init


void function GameStateDialog_Init()
{
	RegisterGameStateConversations()
	RegisterReplacementTitanConversations()
}

void function RegisterGameStateConversations()
{
	RegisterConversation( "WinningScoreSmallMarginMatchEarly",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WinningScoreBigMarginMatchEarly",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WinningScoreSmallMarginMatchMid",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WinningScoreBigMarginMatchMid",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WinningScoreSmallMarginMatchLate",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WinningScoreBigMarginMatchLate",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "WonAnnouncement",							VO_PRIORITY_GAMESTATE )
	RegisterConversation( "WonAnnouncementShort",						VO_PRIORITY_GAMESTATE )
	RegisterConversation( "RoundWonAnnouncement",						VO_PRIORITY_GAMESTATE )
	RegisterConversation( "SwitchingSidesSoon",							VO_PRIORITY_GAMESTATE )
	RegisterConversation( "SwitchingSides",								VO_PRIORITY_GAMESTATE )

	RegisterConversation( "LosingScoreSmallMarginMatchEarly",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LosingScoreBigMarginMatchEarly",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LosingScoreSmallMarginMatchMid",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LosingScoreBigMarginMatchMid",				VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LosingScoreSmallMarginMatchLate",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LosingScoreBigMarginMatchLate",				VO_PRIORITY_GAMEMODE )

	RegisterConversation( "CloseScoreMatchEarly",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "CloseScoreMatchMid",							VO_PRIORITY_GAMEMODE )
	RegisterConversation( "CloseScoreMatchLate",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "LostAnnouncement",							VO_PRIORITY_GAMESTATE )
	RegisterConversation( "LostAnnouncementShort",						VO_PRIORITY_GAMESTATE )
	RegisterConversation( "RoundLostAnnouncement",						VO_PRIORITY_GAMESTATE )

	RegisterConversation( "GameModeAnnounce_AT",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_SCV",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_TDM",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_PS",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_CP",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_CTF",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_LTS",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "GameModeAnnounce_TTDM",						VO_PRIORITY_GAMEMODE )

	RegisterConversation( "PullAhead",									VO_PRIORITY_GAMEMODE )
	RegisterConversation( "FallBehind",									VO_PRIORITY_GAMEMODE )
	RegisterConversation( "FriendlyTeamCatchingUp",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "FriendlyTeamFallingBehindFurther",			VO_PRIORITY_GAMEMODE )
	RegisterConversation( "EnemyTeamCatchingUp",						VO_PRIORITY_GAMEMODE )
	RegisterConversation( "EnemyTeamFallingBehindFurther",				VO_PRIORITY_GAMEMODE )

	RegisterConversation( "EnemyTitansLeftTwo",							VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "EnemyTitansLeftOne",							VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "YouAreTheLastTitan",							VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "TitanVsTitan",								VO_PRIORITY_ELIMINATION_STATUS )

	RegisterConversation( "EnemyPilotsLeftTwo",							VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "EnemyPilotsLeftOne",							VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "FriendlyPilotsLeftTwo",						VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "YouAreTheLastPilot",							VO_PRIORITY_ELIMINATION_STATUS )

	RegisterConversation( "MFDPFriendlyPilotsLeftTwoMarkedPlayer",		VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "MFDPFriendlyPilotsLeftTwo",					VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "MFDPEnemyPilotsLeftTwo",						VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "MFDPBothTeamsPilotsLeftOne",					VO_PRIORITY_ELIMINATION_STATUS )
	RegisterConversation( "MFDPEnemyMarkIsAlone",						VO_PRIORITY_ELIMINATION_STATUS )

	RegisterConversation( "GameModeAnnounce_CTF_SuddenDeath",			VO_PRIORITY_GAMESTATE )
	RegisterConversation( "GameModeAnnounce_TDM_SuddenDeath",			VO_PRIORITY_GAMESTATE )

	#if CLIENT

	/************************ GameModeAnnounce ***************************/
	/************************        IMC       ***************************/
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_TDM", "diag_imc_blisk_tdm_modeannounce_01" ) //Blisk: This is a strike mission. Eliminate all hostiles. Good luck.
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_TDM", "diag_imc_blisk_tdm_modeannounce_02" ) //Blisk: All right, this is a strike mission. Get in there and kill every Militia terrorist you get in your sights.
	AddVDULineForBlisk( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_01_imc_blisk" )
	AddVDULineForBlisk( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_02_imc_blisk" )
	AddVDULineForBlisk( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_03_imc_blisk" )

	//Blisk: "This is a skirmish between Pilots. Titanfall authorization has been revoked. Eliminate all Militia Pilots you see down there!"
	AddVDULineForBlisk( "GameModeAnnounce_PS", "diag_gm_8v8_modeAnnc_imc_Blisk" )

	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_CP", "diag_imc_blisk_hp_modeannounce_01" ) //Blisk: All ground forces, secure the hardpoints.
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_CP", "diag_imc_blisk_hp_modeannounce_02" ) //Blisk: Pilot, you need to secure hardpoints A, B, and C so my team can access the system. Good luck.
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_CP", "diag_imc_blisk_hp_modeannounce_03" ) //Blisk: Attention all units, this is a hardpoint operation. Take control of as many hardpoints as you can, patch my team in to them, and we'll take care of the rest.
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_CP", "diag_imc_blisk_hp_modeannounce_04" ) //Blisk: "This is a hardpoint mission."

	AddVDULineForBlisk( "GameModeAnnounce_CTF", "diag_imc_blisk_ctf_modeAnnc_01" )
	AddVDULineForBlisk( "GameModeAnnounce_CTF", "diag_imc_blisk_ctf_modeAnnc_02" )
	AddVDULineForBlisk( "GameModeAnnounce_CTF", "diag_imc_blisk_ctf_modeAnnc_03" )
	AddVDULineForBlisk( "GameModeAnnounce_CTF", "diag_imc_blisk_ctf_modeAnnc_04" )

	AddVDULineForBlisk( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_01_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_02_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_03_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_04_imc_BLISK" )

	AddVDULineForBlisk( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_01_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_02_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_03_imc_BLISK" )
	AddVDULineForBlisk( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_04_imc_BLISK" )

	AddVDULineForBlisk( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_01_imc_blisk" )
	AddVDULineForBlisk( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_02_imc_blisk" )
	AddVDULineForBlisk( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_03_imc_blisk" )

	AddVDULineForBlisk( "SwitchingSidesSoon", "diag_gm_switchSides_101_01_imc_BLISK" )
	AddVDULineForBlisk( "SwitchingSidesSoon", "diag_gm_switchSides_101_02_imc_BLISK" )
	AddVDULineForBlisk( "SwitchingSidesSoon", "diag_gm_switchSides_101_03_imc_BLISK" )

	AddVDULineForBlisk( "SwitchingSides", "diag_gm_switchSides_101_04_imc_BLISK" )

	AddVDULineForBlisk( "PullAhead", "diag_gm_pullAhead_101_01_imc_BLISK" )
	AddVDULineForBlisk( "PullAhead", "diag_gm_pullAhead_101_02_imc_BLISK" )

	AddVDULineForBlisk( "FallBehind", "diag_gm_fallBehind_101_01_imc_BLISK" )
	AddVDULineForBlisk( "FallBehind", "diag_gm_fallBehind_101_02_imc_BLISK" )


	//Blisk: We're doing better than before, but those Milita terrorists are still in the lead. Step it up Pilot!
	//Blisk: We're making good progress, but the Militia forces are still ahead. Get it together Pilots!
	AddVDULineForBlisk( "FriendlyTeamCatchingUp", "diag_gm_gc_scoreTeamCatchingUp_imc_Blisk" )

	//Blisk:Pilots, the Militia are pulling further and further ahead. We've got to turn this around right now!
	//Blisk:All units, the Militia are getting even further ahead of us! Step it up down there!
	AddVDULineForBlisk( "FriendlyTeamFallingBehindFurther",	 "diag_gm_gc_scoreTeamFallingBehind_imc_Blisk" )

	//Blisk:Pilots, we're still in the lead, but the Milita are catching up. Stay vigilant. Don't let them get ahead.
	//Blisk:Be advised, we're still ahead of the Militia but our lead is decreasing. Stay focused and don't let up.
	AddVDULineForBlisk( "EnemyTeamCatchingUp",	"diag_gm_gc_scoreEnemyCatchingUp_imc_Blisk" )

	//Blisk: All units, we're steadily increasing our lead over these Militia terrorists. Good work down there. Keep it up!
	//Blisk: Pilots, we're pulling even further ahead of the Miliia. You're doing a fine job. Let's keep this pace up!
	AddVDULineForBlisk( "EnemyTeamFallingBehindFurther", "diag_gm_gc_scoreEnemyFallingBehind_imc_Blisk" )

	AddVDULineForBlisk( "EnemyTitansLeftTwo", "diag_lts_twoTitansLeft_101_01_imc_BLISK" )
	AddVDULineForBlisk( "EnemyTitansLeftTwo", "diag_lts_twoTitansLeft_101_02_imc_BLISK" )
	AddVDULineForBlisk( "EnemyTitansLeftOne", "diag_lts_oneEnemyTitan_101_01_imc_BLISK" )
	AddVDULineForBlisk( "EnemyTitansLeftOne", "diag_lts_oneEnemyTitan_101_02_imc_BLISK" )
	AddVDULineForBlisk( "YouAreTheLastTitan", "diag_lts_youLastTitan_101_01_imc_BLISK" )
	AddVDULineForBlisk( "YouAreTheLastTitan", "diag_lts_youLastTitan_101_02_imc_BLISK" )
	AddVDULineForBlisk( "TitanVsTitan", "diag_lts_oneEnemyTitan_102_01_imc_BLISK" )


	//2 options:
	//Blisk: Only 2 more Militia Pilots left. Take them down!
	//Blisk: Just 2 more Militia Pilots remaining. Hunt them down!
	AddVDULineForBlisk( "EnemyPilotsLeftTwo", "diag_gm_gc_pilotsAliveTwoEnemy_imc_Blisk" )

	//2 options:
	//Blisk:There's only one more Militia Pilot left alive. Hunt him down!
	//Blisk:Only one Militia Pilot left alive. Take him out!
	AddVDULineForBlisk( "EnemyPilotsLeftOne", "diag_gm_gc_pilotsAliveOneEnemy_imc_Blisk" )

	//2 options:
	//Blisk: There's just the 2 of you left down there Pilots. Don't let your guard down!
	//Blisk: It's just the 2 of you left now. Stay focused Pilots!
	AddVDULineForBlisk( "FriendlyPilotsLeftTwo", "diag_gm_gc_pilotsAliveTwoTeam_imc_Blisk" )

	//Blisk: You're the last one left alive. It's all up to you now!
	AddVDULineForBlisk( "YouAreTheLastPilot", "diag_gm_gc_lastAlivePlayer_imc_Blisk" )



	//MFDPro
	//Blisk: There's only 2 of you left alive down there. Stay close to your teammate!
	AddVDULineForBlisk( "MFDPFriendlyPilotsLeftTwoMarkedPlayer", "diag_gm_mfdp_teamAliveTwoImMark_imc_Blisk" )

	//Blisk: There's only 2 of you left alive down there. Make sure you protect the mark!
	AddVDULineForBlisk( "MFDPFriendlyPilotsLeftTwo", "diag_gm_mfdp_teamAliveTwoImNotMark_imc_Blisk" )

	//Blisk: There's only 2 Pilots left on the Militia team.
	AddVDULineForBlisk( "MFDPEnemyPilotsLeftTwo", "diag_gm_mfdp_enemyAliveTwo_imc_Blisk" )

	//Blisk: It's just you and the Militia marked pilot down there. Stay focused and finish him off!
	AddVDULineForBlisk( "MFDPBothTeamsPilotsLeftOne", "diag_gm_mfdp_pilotsAliveMarksOnly_imc_Blisk" )

	//Blisk: The Militia mark is the last one left alive. All units, terminate him with extreme prejudice.
	AddVDULineForBlisk( "MFDPEnemyMarkIsAlone", "diag_gm_mfdp_enemyMarkIsAlone_imc_Blisk" )

	/************************** WinningScoreSmallMarginMatchEarly *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WinningScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_imcReachM1_LeadSlight_01" ) // Blisk: All units, we've got the upper hand for now, but it's a close fight. Don't let your guard down.
	AddVDULineForBlisk( "WinningScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_imcReachM1_LeadSlight_02" ) // Blisk: Be advised, we're only slightly ahead of the insurgents. There's still lots of time to improve our situation.  Get to it.

	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_closewinning_01" ) // Blisk: Listen up, we're doing all right against these outlaws, but not by much.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_closewinning_02" ) // Blisk: All units, we've got the upper hand for now, but it's a close fight. Don't let your guard down.

	/**************************  WinningScoreBigMarginMatchEarly  *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WinningScoreBigMarginMatchEarly", "diag_imc_blisk_gs_imcReachM1_LeadGreat_01" ) // Blisk: Blisk to all units, you're doing a fine job, but its still early in the fight. Keep the pressure on those terrorists.
	AddVDULineForBlisk( "WinningScoreBigMarginMatchEarly", "diag_imc_blisk_gs_imcReachM1_LeadGreat_02" ) // Blisk: Pilots, we're off to an excellent start, but don't let up - the battle's only just begun.
	AddVDULineForBlisk( "WinningScoreBigMarginMatchEarly", "diag_imc_blisk_gs_imcReachM1_LeadGreat_03" ) // Blisk: All units, so far so good. Keep fighting this well, and we'll have the Militia on the run in no time.

	/**************************  CloseScoreMatchEarly  *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "CloseScoreMatchEarly", "diag_imc_blisk_gs_imcReachM1_Tied_01" ) // Blisk: All units, it's a very close fight - closer than I'd like. Step it up down there.

    /************************** WinningScoreSmallMarginMatchMid *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WinningScoreSmallMarginMatchMid", "diag_imc_blisk_gs_imcReachM2_LeadSlight_01" ) // Blisk: All units, we have only a slight edge on these terrorists.  There's still some time left in the mission, so let's stay ahead.
	AddVDULineForBlisk( "WinningScoreSmallMarginMatchMid", "diag_imc_blisk_gs_imcReachM2_LeadSlight_02" ) // Blisk: All units be advised, we're slightly ahead of the insurgents.  There still some time left, so don't let up.

	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreSmallMarginMatchMid", "diag_imc_blisk_gs_closewinning_01" ) // Blisk: Listen up, we're doing all right against these outlaws, but not by much.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreSmallMarginMatchMid", "diag_imc_blisk_gs_closewinning_02" ) // Blisk: All units, we've got the upper hand for now, but it's a close fight. Don't let your guard down.

	/**************************  WinningScoreBigMarginMatchMid  *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WinningScoreBigMarginMatchMid", "diag_imc_blisk_gs_imcReachM2_LeadGreat_01" ) // Blisk: Blisk to all IMC units: we're completely outclassing the Militia. Keep up the good work!
	AddVDULineForBlisk( "WinningScoreBigMarginMatchMid", "diag_imc_blisk_gs_imcReachM2_LeadGreat_02" ) // Blisk: All units, we're destroying the Militia forces, and we're about halfway through the mission. Keep pouring it on.
	//AddVDULineForBlisk( "WinningScoreBigMarginMatchMid", "diag_imc_blisk_gs_imcReachM2_LeadGreat_03" ) // Blisk: Blisk to all Pilots: we're crushing the terrorists, they're barely putting up a fight. Whatever you're doing, it's working - keep it up.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreBigMarginMatchMid", "diag_imc_blisk_gs_bigwinning_03" ) // Blisk: Tac Six to all Pilots: we're crushing the terrorists, they're barely putting up a fight. Whatever you're doing, it's working - keep it up.

	/**************************  CloseScoreMatchMid  *****************************/
	/**************************        IMC        *****************************/

	//Same line as CloseScoreMatchEarly because the recorded dialogue was inappropriate.
	AddVDULineForBlisk( "CloseScoreMatchMid", "diag_imc_blisk_gs_imcReachM1_Tied_01" ) // Blisk: All units, it's a very close fight - closer than I'd like. Step it up down there.


	/************************** WinningScoreSmallMarginMatchLate *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WinningScoreSmallMarginMatchLate", "diag_imc_blisk_gs_imcReachM3_LeadSlight_01" ) // Blisk: Tac Six to all units, it's been a close battle. We've got a slight lead on the enemy. Keep it together and we'll win this one.
	AddVDULineForBlisk( "WinningScoreSmallMarginMatchLate", "diag_imc_blisk_gs_imcReachM3_LeadSlight_02" ) // Blisk: We've almost secured victory, but the insurgents aren't far behind. Let's stay on top and shut 'em down.

	/**************************  WinningScoreBigMarginMatchLate  *****************************/
	/**************************        IMC        *****************************/

	//AddVDULineForBlisk( "WinningScoreBigMarginMatchLate", "diag_imc_blisk_gs_imcReachM3_LeadGreat_01" ) // Blisk: All units, we are crushing the insurgents. This battle's almost over.
	//AddVDULineForBlisk( "WinningScoreBigMarginMatchLate", "diag_imc_blisk_gs_imcReachM3_LeadGreat_02" ) // Blisk: Tac Six to all units, victory is imminent. This battle is almost over, well done.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreBigMarginMatchLate", "diag_imc_blisk_gs_bigwinning_01" ) // Blisk: All units, we are crushing the insurgents. This battle's almost over.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WinningScoreBigMarginMatchLate", "diag_imc_blisk_gs_bigwinning_02" ) // Blisk: Tac Six to all units, victory is imminent. This battle is almost over, well done.


	/**************************  CloseScoreMatchLate  *****************************/
	/**************************        IMC        *****************************/
	AddVDULineForBlisk( "CloseScoreMatchLate", "diag_imc_blisk_gs_imcReachM3_Tied_01" ) // Blisk: All units, this battle is way too close. This is your last chance to pull it together and win this fight decisively.
	AddVDULineForBlisk( "CloseScoreMatchLate", "diag_imc_blisk_gs_imcReachM3_Tied_02" ) // Blisk: All units, we're neck and neck with the Militia. You only have a short time left to secure victory!

	/**************************  WonAnnouncement  *****************************/
	/**************************        IMC        *****************************/

	AddVDUAnimWithEmbeddedAudioForBlisk( "WonAnnouncement", "diag_imc_blisk_gs_gamewon_01" ) // Blisk: Tac Six to all ground forces. The situation is under our control. Well done.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WonAnnouncement", "diag_imc_blisk_gs_gamewon_02" ) // Blisk: Tac Six to all ground units - the Militia have been defeated. Excellent work.
	AddVDUAnimWithEmbeddedAudioForBlisk( "WonAnnouncement", "diag_imc_blisk_gs_gamewon_03" ) // Blisk: All units, be advised, we are mission complete. Nice work.

	/**************************  WonAnnouncementShort  *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "WonAnnouncementShort", "diag_gm_matchWin_101_01_imc_BLISK" ) // Blisk: Excellent work Pilots. We've won this match.
	AddVDULineForBlisk( "WonAnnouncementShort", "diag_gm_matchWin_101_03_imc_BLISK" ) // Blisk: Excellent work Pilots. We've won.
	AddVDULineForBlisk( "WonAnnouncementShort", "diag_gm_matchWin_101_04_imc_BLISK" ) // Blisk: Pilots! We've won the battle! Good work.

	/**************************  RoundWonAnnouncement  *****************************/
	/**************************        IMC        *****************************/

	//3 Possible lines:
	//Blisk:This round is ours!
	//Blisk:We won this round!
	//Blisk:That's how it's done. Good job Pilots, this round is ours.
	AddVDULineForBlisk( "RoundWonAnnouncement", "diag_gm_gc_roundWon_imc_Blisk" )


	/************************** LosingScoreSmallMarginMatchEarly *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_milReachM1_LeadSlight_01" ) // Blisk: Be advised, the Militia have a small lead in this fight, but there's still plenty of time to retake the initiative.
	AddVDULineForBlisk( "LosingScoreSmallMarginMatchEarly", "diag_imc_blisk_gs_milReachM1_LeadSlight_02" ) // Blisk: All units, the Militia are slightly ahead of us, but there's plenty of time left to turn it around.  Get it done, Blisk out.

	/**************************  LosingScoreBigMarginMatchEarly  *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreBigMarginMatchEarly", "diag_imc_blisk_gs_milReachM1_LeadGreat_01" ) // Blisk: All IMC units:  the Militia are dominating the fight, but we've still got plenty of time to turn it around. Get to it!
	AddVDULineForBlisk( "LosingScoreBigMarginMatchEarly", "diag_imc_blisk_gs_milReachM1_LeadGreat_02" ) // Blisk: All IMC units:  battle projections say we're going to lose by a landslide, but it's still early in the fight. Let's turn this around.
	AddVDULineForBlisk( "LosingScoreBigMarginMatchEarly", "diag_imc_blisk_gs_milReachM1_LeadGreat_03" ) // Blisk: All units be advised: We've allowed the enemy to start with a comfortable lead.  Fix it. Blisk out.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LosingScoreBigMarginMatchEarly", "diag_imc_blisk_gs_closelosing_02" ) // Blisk: All units: The militia have the upper hand at the moment but we can still regain control of the situation


	/************************** LosingScoreSmallMarginMatchMid *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreSmallMarginMatchMid", "diag_imc_blisk_gs_milReachM2_LeadSlight_01" ) // Blisk: Be advised, we're losing the fight but not by much. We still have time to regain the lead.
	AddVDULineForBlisk( "LosingScoreSmallMarginMatchMid", "diag_imc_blisk_gs_milReachM2_LeadSlight_02" ) // Blisk: All units, the Militia have the upper hand at the moment, but we can still regain control of the situation.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LosingScoreSmallMarginMatchMid", "diag_imc_blisk_gs_closelosing_01" ) // Blisk: Be advised, we're losing the fight but not by much. Don't underestimate these terrorists!

	/**************************  LosingScoreBigMarginMatchMid  *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreBigMarginMatchMid", "diag_imc_blisk_gs_milReachM2_LeadGreat_01" ) // Blisk: All units, these Militia terrorists are destroying us! We may need to abort the mission if we don't turn it around now!
	AddVDULineForBlisk( "LosingScoreBigMarginMatchMid", "diag_imc_blisk_gs_milReachM2_LeadGreat_02" ) // Blisk: All units, we're getting destroyed out here, but there's still time left. Do whatever it takes to turn it around!
	AddVDULineForBlisk( "LosingScoreBigMarginMatchMid", "diag_imc_blisk_gs_milReachM2_LeadGreat_03" ) // Blisk: Pilots, we're losing badly, but we still have time to regain control of the situation.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LosingScoreBigMarginMatchMid", "diag_imc_blisk_gs_biglosing_02" ) // Blisk: All units, be advised. We're taking excessive losses. We may need to abort the mission if we don't turn it around now




	/************************** LosingScoreSmallMarginMatchLate *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreSmallMarginMatchLate", "diag_imc_blisk_gs_milReachM3_LeadSlight_01" ) // Blisk: All units: it's been a close fight, but the Militia forces are slightly ahead. We need to turn this around, now!
	AddVDULineForBlisk( "LosingScoreSmallMarginMatchLate", "diag_imc_blisk_gs_milReachM3_LeadSlight_02" ) // Blisk: Blisk to all remaining units: the Militia have a slight edge, and the fight is nearly over. You've got to turn this fight around before it's too late!

	/**************************  LosingScoreBigMarginMatchLate  *****************************/
	/**************************        IMC       *****************************/

	AddVDULineForBlisk( "LosingScoreBigMarginMatchLate", "diag_imc_blisk_gs_milReachM3_LeadGreat_01" ) // Blisk: All units, be advised, we are losing the battle and there's not much time left. Defeat is imminent!
	AddVDULineForBlisk( "LosingScoreBigMarginMatchLate", "diag_imc_blisk_gs_milReachM3_LeadGreat_02" ) // Blisk: All IMC units, battle projections are looking grim. There's not much time left to turn it around.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LosingScoreBigMarginMatchLate", "diag_imc_blisk_gs_biglosing_01" ) // Blisk: We're getting destroyed out here. We've got to do whatever it takes to turn this around
	AddVDUAnimWithEmbeddedAudioForBlisk( "LosingScoreBigMarginMatchLate", "diag_imc_blisk_gs_biglosing_03" ) // Blisk: All units, be advised. We are losing the battle and have sustained massive casualties. Defeat is imminent!


	/**************************  LostAnnouncement  *****************************/
	/**************************         IMC        *****************************/

	AddVDUAnimWithEmbeddedAudioForBlisk( "LostAnnouncement", "diag_imc_blisk_gs_gamelost_01" ) // Blisk: All units, return to HQ, we are terminating this mission effective immediately.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LostAnnouncement", "diag_imc_blisk_gs_gamelost_02" ) // Blisk: All units, abort mission, I repeat, abort mission. We are out of here.

	AddVDUAnimWithEmbeddedAudioForBlisk( "LostAnnouncement", "diag_imc_blisk_gs_gamelost_03" ) // Blisk: Tac Six to all units, we have been defeated. We're cutting our losses and getting the hell out of here.


	/**************************  LostAnnouncementShort  *****************************/
	/**************************        IMC        *****************************/

	AddVDULineForBlisk( "LostAnnouncementShort", "diag_gm_matchLose_102_01_imc_BLISK" ) // Blisk: Pilots! We've lost this match
	AddVDULineForBlisk( "LostAnnouncementShort", "diag_gm_matchLose_102_03_imc_BLISK" ) // Blisk: Pilots, we've lost this one.


	/**************************  RoundLostAnnouncement  *****************************/
	/**************************        IMC        *****************************/

	//3 Possible lines:
	//Blisk:We lost the round!
	//Blisk:The Militia beat us this round.
	//Blisk:They make have taken this round, but we'll get them next time.
	AddVDULineForBlisk( "RoundLostAnnouncement", "diag_gm_gc_roundLost_imc_Blisk" )


	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/
	/*************************************************************************/


	/************************ GameModeAnnounce ***************************/
	/************************      MILITIA     ***************************/
	//Commenting out since we have no animation
	//AddVDULineForBish( "GameModeAnnounce_TDM", "diag_tdm_mcor_bish_modeannounce_01" ) //Bish: This is a strike mission. Eliminate all hostiles. Good luck.
	AddVDUAnimWithEmbeddedAudioForBish( "GameModeAnnounce_TDM", "diag_tdm_mcor_bish_modeannounce_02" )//Bish: Ok buddy, this is a strike mission. Get in there and kill every IMC bastard you run into. It's real simple. Good luck.
	AddVDULineForBish( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_01_mcor_bish" )
	AddVDULineForBish( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_02_mcor_bish" )
	AddVDULineForBish( "GameModeAnnounce_TDM", "diag_tdm_modeAnnc_101_03_mcor_bish" )

	//Bish: "This is a skirmish between Pilots. You won't have any Titans backing you up down there Boss. Take out any IMC Pilots you see!"
	AddVDULineForBish( "GameModeAnnounce_PS", "diag_gm_8v8_modeAnnc_mcor_Bish" )

	AddVDUAnimWithEmbeddedAudioForBish( "GameModeAnnounce_CP", "diag_hp_bish_modeannounce_03" ) //Bish: Ok boss, this is a hardpoint operation. Take control of as many hardpoints as you can, patch me in to them, and I'll take care of the rest.

	AddVDULineForBish( "GameModeAnnounce_CTF", "diag_mcor_bish_ctf_modeAnnc_01" )
	AddVDULineForBish( "GameModeAnnounce_CTF", "diag_mcor_bish_ctf_modeAnnc_02" )
	AddVDULineForBish( "GameModeAnnounce_CTF", "diag_mcor_bish_ctf_modeAnnc_03" )
	AddVDULineForBish( "GameModeAnnounce_CTF", "diag_mcor_bish_ctf_modeAnnc_04" )

	AddVDULineForBish( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_01_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_02_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_03_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_LTS", "diag_lts_modeAnnc_101_04_mcor_BISH" )

	AddVDULineForBish( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_01_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_02_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_03_mcor_BISH" )
	AddVDULineForBish( "GameModeAnnounce_TTDM", "diag_lts_modeAnnc_101_04_mcor_BISH" )

	AddVDULineForBish( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_01_mcor_bish" )
	AddVDULineForBish( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_02_mcor_bish" )
	AddVDULineForBish( "GameModeAnnounce_AT", "diag_at_modeAnnc_101_03_mcor_bish" )

	AddVDULineForBish( "SwitchingSidesSoon", "diag_gm_switchSides_101_01_mcor_BISH" )
	AddVDULineForBish( "SwitchingSidesSoon", "diag_gm_switchSides_101_02_mcor_BISH" )
	AddVDULineForBish( "SwitchingSidesSoon", "diag_gm_switchSides_101_03_mcor_BISH" )

	AddVDULineForBish( "SwitchingSides", "diag_gm_switchSides_101_04_mcor_BISH" )

	AddVDULineForBish( "PullAhead", "diag_gm_pullAhead_101_01_mcor_BISH" )
	AddVDULineForBish( "PullAhead", "diag_gm_pullAhead_101_02_mcor_BISH" )

	AddVDULineForBish( "FallBehind", "diag_gm_fallBehind_101_01_mcor_BISH" )
	AddVDULineForBish( "FallBehind", "diag_gm_fallBehind_101_02_mcor_BISH" )

	//Bish: "You're catching up Boss, but we're still trailing behind them. You've got to step it up down there!"
	//Bish: We're doing better than before, but the IMC are still ahead of us. You can do this people!
	AddVDULineForBish( "FriendlyTeamCatchingUp", "diag_gm_gc_scoreTeamCatchingUp_mcor_Bish" )

	//Bish:They're pulling further and further ahead Boss! If you're gonna do something, you need to do it fast!
	//Bish:The IMC are getting even further ahead of us. We need to step it up, and I mean right now!
	AddVDULineForBish( "FriendlyTeamFallingBehindFurther",	 "diag_gm_gc_scoreTeamFallingBehind_mcor_Bish" )

	//Bish:We're still ahead Boss, but the IMC are catching up. Don't let up now!
	//Bish:We're still doing good down there, but the IMC are catching up. Don't give them a chance to come back!
	AddVDULineForBish( "EnemyTeamCatchingUp",	"diag_gm_gc_scoreEnemyCatchingUp_mcor_Bish" )

	//Bish:We're doing even better than before! Good work team. Keep up the pressure!
	//Bish:We're pulling even further ahead of the IMC! Great job down there Boss!
	AddVDULineForBish( "EnemyTeamFallingBehindFurther", "diag_gm_gc_scoreEnemyFallingBehind_mcor_Bish" )

	AddVDULineForBish( "EnemyTitansLeftTwo", "diag_lts_twoTitansLeft_101_01_mcor_BISH" )
	AddVDULineForBish( "EnemyTitansLeftTwo", "diag_lts_twoTitansLeft_101_02_mcor_BISH" )
	AddVDULineForBish( "EnemyTitansLeftOne", "diag_lts_oneEnemyTitan_101_01_mcor_BISH" )
	AddVDULineForBish( "EnemyTitansLeftOne", "diag_lts_oneEnemyTitan_101_02_mcor_BISH" )
	AddVDULineForBish( "YouAreTheLastTitan", "diag_lts_youLastTitan_101_01_mcor_BISH" )
	AddVDULineForBish( "YouAreTheLastTitan", "diag_lts_youLastTitan_101_02_mcor_BISH" )
	AddVDULineForBish( "TitanVsTitan", "diag_lts_oneEnemyTitan_102_02_mcor_BISH" )

	//2 options:
	//Bish:Only 2 more IMC Pilots left. Take them down!
	//Bish:Just 2 more IMC Pilots remaining. Hunt them down!
	AddVDULineForBish( "EnemyPilotsLeftTwo", "diag_gm_gc_pilotsAliveTwoEnemy_mcor_Bish" )

	//2 options:
	//Bish:Only one IMC Pilot left now. Hunt him down!
	//Bish:There's only one more IMC Pilot left alive. Take him out!
	AddVDULineForBish( "EnemyPilotsLeftOne", "diag_gm_gc_pilotsAliveOneEnemy_mcor_Bish" )

	//2 options:
	//Bish:It's just the 2 of you left now. Stay focused guys!
	//Bish:There's just the 2 of you left down there now. Don't let your guard down!
	AddVDULineForBish( "FriendlyPilotsLeftTwo", "diag_gm_gc_pilotsAliveTwoTeam_mcor_Bish" )

	//Bish: You're the last one left alive. It's all up to you now!
	AddVDULineForBish( "YouAreTheLastPilot", "diag_gm_gc_lastAlivePlayer_mcor_Bish" )



	//MFDPro
	//Bish: There's only 2 of you left alive down there. Stay close to your teammate!
	AddVDULineForBish( "MFDPFriendlyPilotsLeftTwoMarkedPlayer", "diag_gm_mfdp_teamAliveTwoImMark_mcor_Bish" )

	//Bish: There's only 2 of you left alive down there. Make sure you protect the mark!
	AddVDULineForBish( "MFDPFriendlyPilotsLeftTwo", "diag_gm_mfdp_teamAliveTwoImNotMark_mcor_Bish" )

	//Bish: There's only 2 Pilots left on the imc team.
	AddVDULineForBish( "MFDPEnemyPilotsLeftTwo", "diag_gm_mfdp_enemyAliveTwo_mcor_Bish" )

	//Bish: It's just you and the IMC mark down there. You've got this boss!
	AddVDULineForBish( "MFDPBothTeamsPilotsLeftOne", "diag_gm_mfdp_pilotsAliveMarksOnly_mcor_Bish" )

	//Bish: Only the IMC mark is left alive now. You've got this team. Take him out!
	AddVDULineForBish( "MFDPEnemyMarkIsAlone", "diag_gm_mfdp_enemyMarkIsAlone_mcor_Bish" )

	/************************** WinningScoreSmallMarginMatchEarly *****************************/
	/**************************      MILITIA      *****************************/

	AddVDULineForBish( "WinningScoreSmallMarginMatchEarly", "diag_mcor_bish_gs_milReachM1_LeadSlight_01" ) // Bish: We're off to a good start,  but we're not ahead by much.  Stay sharp my friend.
	AddVDULineForBish( "WinningScoreSmallMarginMatchEarly", "diag_mcor_bish_gs_milReachM1_LeadSlight_02" ) // Bish: Hey, we're barely ahead of the IMC right now,  but there's plenty of time left to step it up.

	AddVDUAnimWithEmbeddedAudioForBish( "WinningScoreSmallMarginMatchEarly", "diag_gs_mcor_bish_closewinning_01" ) 	// Bish: We're barely ahead of the IMC, man. The battle projections say it's gonna be real close.


	/**************************  WinningScoreBigMarginMatchEarly  *****************************/
	/**************************      MILITIA      *****************************/

	AddVDULineForBish( "WinningScoreBigMarginMatchEarly", "diag_mcor_bish_gs_milReachM1_LeadGreat_01" ) // Bish: We're crushing them big time, but we've got a ways to go. Don't let up!
	AddVDULineForBish( "WinningScoreBigMarginMatchEarly", "diag_mcor_bish_gs_milReachM1_LeadGreat_02" ) // Bish: We're off to a  great start man;  keep it up!
	AddVDULineForBish( "WinningScoreBigMarginMatchEarly", "diag_mcor_bish_gs_milReachM1_LeadGreat_03" ) // Bish: We're just getting started, but this is looking really good. Keep up the fire.

	AddVDUAnimWithEmbeddedAudioForBish( "WinningScoreBigMarginMatchEarly", "diag_gs_mcor_bish_bigwinning_01" ) // Bish: We're crushing them big time, don't let up!

	/**************************  CloseScoreMatchEarly  *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "CloseScoreMatchEarly", "diag_mcor_bish_gs_milReachM1_Tied_01" ) // Bish: It's been a really close fight so far, but the mission's far from over.  Let's step it up and show the IMC what we can do.

	/************************** WinningScoreSmallMarginMatchMid *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "WinningScoreSmallMarginMatchMid", "diag_mcor_bish_gs_milReachM2_LeadSlight_01" ) // Bish: Team, we're looking good,  but the IMC isn't far behind.  We have a ways to go, so don't let up.
	AddVDULineForBish( "WinningScoreSmallMarginMatchMid", "diag_mcor_bish_gs_milReachM2_LeadSlight_02" ) // Bish: We're looking good team, but it's a close fight, and there's plenty of time left in this mission.  Don't give the IMC any ground.

	AddVDUAnimWithEmbeddedAudioForBish( "WinningScoreSmallMarginMatchMid", "diag_gs_mcor_bish_closewinning_01" ) 	// Bish: We're barely ahead of the IMC, man. The battle projections say it's gonna be real close.

	/**************************  WinningScoreBigMarginMatchMid  *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "WinningScoreBigMarginMatchMid", "diag_mcor_bish_gs_milReachM2_LeadGreat_01" ) // Bish: Hey buddy, we're doing great - if this keeps up, I think we're gonna win this fight.
	AddVDULineForBish( "WinningScoreBigMarginMatchMid", "diag_mcor_bish_gs_milReachM2_LeadGreat_02" ) // Bish: We're way ahead of the IMC! We're only partway through the mission, so keep doing what you're doing!
	AddVDULineForBish( "WinningScoreBigMarginMatchMid", "diag_mcor_bish_gs_milReachM2_LeadGreat_03" ) // Bish: You're doing great out there man! Keep it up, and this battle will be ours before you know it!

	AddVDUAnimWithEmbeddedAudioForBish( "WinningScoreBigMarginMatchMid", "diag_gs_mcor_bish_bigwinning_01" ) // Bish: We're crushing them big time, don't let up!

	/**************************  CloseScoreMatchMid  *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "CloseScoreMatchMid", "diag_mcor_bish_gs_milReachM2_Tied_01" ) // Bish: Man�this fight's too close to call but there's still plenty of time to bury the IMC - team, let's step it up.

	/************************** WinningScoreSmallMarginMatchLate *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "WinningScoreSmallMarginMatchLate", "diag_mcor_bish_gs_milReachM3_LeadSlight_01" ) // Bish: Ok team, the mission's almost over. The IMC aren't far behind though. Keep at it!
	AddVDULineForBish( "WinningScoreSmallMarginMatchLate", "diag_mcor_bish_gs_milReachM3_LeadSlight_02" ) // Bish: There's not much time left in the mission, but the IMC aren't far behind. Let's stay on top and end this fight.

	/**************************  WinningScoreBigMarginMatchLate  *****************************/
	/**************************        MILITIA        *****************************/

	AddVDULineForBish( "WinningScoreBigMarginMatchLate", "diag_mcor_bish_gs_milReachM3_LeadGreat_01" ) // Bish: We're totally crushing it. The IMC don't stand a chance. Won't be long before we finish this fight!
	AddVDULineForBish( "WinningScoreBigMarginMatchLate", "diag_mcor_bish_gs_milReachM3_LeadGreat_02" ) // Bish: We're looking real good team - short of a miracle for the IMC, there's no way we're losin' this fight.

	/**************************  CloseScoreMatchLate  *****************************/
	/**************************        MILITIA        *****************************/
	AddVDULineForBish( "CloseScoreMatchLate", "diag_mcor_bish_gs_milReachM3_Tied_01" ) // Bish: Hey Pilots, the IMC are giving us a run for our money.  It's gonna be a close battle.  Let's make sure we get there first.
	AddVDULineForBish( "CloseScoreMatchLate", "diag_mcor_bish_gs_milReachM3_Tied_02" ) // Bish: We're neck and neck with the IMC, man. The battle projections say it's gonna be real close.

	/**************************  WonAnnouncement  *****************************/
	/**************************      MILITIA      *****************************/
	AddVDUAnimWithEmbeddedAudioForBish( "WonAnnouncement", "diag_gs_mcor_bish_gamewon_02" )  // Bish: All right, we got what we came for! Awesome work team, mission accomplished.

	/**************************  WonAnnouncementShort  *****************************/
	/**************************      MILITIA      *****************************/
	//AddVDULineForBish( "WonAnnouncementShort", "diag_gm_matchWin_101_03_mcor_BISH" )  // Bish: Excellent work Pilots. We've won.
	AddVDULineForBish( "WonAnnouncementShort", "diag_gm_matchWin_101_04_mcor_BISH" )  // Bish: Pilots! We've won the battle! Good work.



	/**************************  RoundWonAnnouncement  *****************************/
	/**************************        MILITIA       *****************************/

	//3 Possible lines:
	//Bish: This round is ours!
	//Bish: We won this round!
	//Bish: That's how it's done. Good job team, this round is ours.
	AddVDULineForBish( "RoundWonAnnouncement", "diag_gm_gc_roundWon_mcor_Bish" )


	/************************** LosingScoreSmallMarginMatchEarly *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreSmallMarginMatchEarly", "diag_mcor_bish_gs_imcReachM1_LeadSlight_01" ) // Bish: Hey, we're doing all right, but the IMC is slightly ahead of us. We've still got plenty of time to show 'em who's boss though.
	AddVDULineForBish( "LosingScoreSmallMarginMatchEarly", "diag_mcor_bish_gs_imcReachM1_LeadSlight_02" ) // Bish: Pilots, we're tracking slightly behind the enemy right now, but its still early; we've got time to turn this around.

	/**************************  LosingScoreBigMarginMatchEarly  *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreBigMarginMatchEarly", "diag_mcor_bish_gs_imcReachM1_LeadGreat_01" ) // Bish: Uh, we're off to a really bad start and the IMC are way ahead. Pull it together man, we have lots of time to turn it around.
	AddVDULineForBish( "LosingScoreBigMarginMatchEarly", "diag_mcor_bish_gs_imcReachM1_LeadGreat_02" ) // Bish: Bad news man, combat projections have the IMC tracking way ahead of us.  We gotta catch up before it's too late!
	AddVDULineForBish( "LosingScoreBigMarginMatchEarly", "diag_mcor_bish_gs_imcReachM1_LeadGreat_03" ) // Bish: Pilot, the battle projections aren't looking too good for us. We gotta catch up and turn this fight around, like now.

	/************************** LosingScoreSmallMarginMatchMid *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreSmallMarginMatchMid", "diag_mcor_bish_gs_imcReachM2_LeadSlight_01" ) // Bish: Hey buddy, we're still in the fight, but the IMC have the upper hand right now.  We still have time to get ahead, so don't let up.
	AddVDULineForBish( "LosingScoreSmallMarginMatchMid", "diag_mcor_bish_gs_imcReachM2_LeadSlight_02" ) // Bish: Ok buddy, it's still a close fight, but we're definitely behind right now.  There's some time left to turn things around.
	AddVDUAnimWithEmbeddedAudioForBish( "LosingScoreSmallMarginMatchMid", "diag_gs_mcor_bish_closelosing_01" ) // Bish: Ok buddy, it's still a close fight, but we're definitely behind right now.


	/**************************  LosingScoreBigMarginMatchMid  *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreBigMarginMatchMid", "diag_mcor_bish_gs_imcReachM2_LeadGreat_01" ) // Bish: Bad news boss. The IMC are way ahead of us! There's still some time to catch up though.
	AddVDUAnimWithEmbeddedAudioForBish( "LosingScoreBigMarginMatchMid", "diag_gs_mcor_bish_biglosing_01" ) // Bish: Boss, we're seriously losing this fight, you gotta step it up out there!
	AddVDULineForBish( "LosingScoreBigMarginMatchMid", "diag_mcor_bish_gs_imcReachM2_LeadGreat_03" ) // Bish: We're losing man� we gotta turn this fight around, and I mean right now.

	/************************** LosingScoreSmallMarginMatchLate *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreSmallMarginMatchLate", "diag_mcor_bish_gs_imcReachM3_LeadSlight_01" ) // Bish: Hey buddy, the enemy is slightly ahead of us, and the battle's almost over! If you're planning a comeback, now's the time!
	AddVDULineForBish( "LosingScoreSmallMarginMatchLate", "diag_mcor_bish_gs_imcReachM3_LeadSlight_02" ) // Bish: Hey, we're running out of time and the enemy is slightly ahead! We gotta turn it around now, or we're done!
	AddVDULineForBish( "LosingScoreSmallMarginMatchLate", "diag_mcor_bish_gs_imcReachM3_LeadSlight_03" ) // Bish: Uh, it's a close battle,  but we're slightly behind! We need to do something now, or we're gonna lose the fight!

	/**************************  LosingScoreBigMarginMatchLate  *****************************/
	/**************************        MILITIA       *****************************/

	AddVDULineForBish( "LosingScoreBigMarginMatchLate", "diag_mcor_bish_gs_imcReachM3_LeadGreat_01" ) // Bish: Hey man, this is not looking good - we're way behind, and we're running out of time!
	AddVDULineForBish( "LosingScoreBigMarginMatchLate", "diag_mcor_bish_gs_imcReachM3_LeadGreat_02" ) // Bish: Pilots�its looking pretty grim�we don't have much time left for a comeback! Pull it together!

	/**************************  LostAnnouncement  *****************************/
	/**************************      MILITIA       *****************************/

	AddVDUAnimWithEmbeddedAudioForBish( "LostAnnouncement", "diag_gs_mcor_bish_gamelost_03" ) 	// Bish: It's over guys. We lost - fall back to base.

	/**************************  LostAnnouncementShort  *****************************/
	/**************************      MILITIA      *****************************/
	AddVDULineForBish( "LostAnnouncementShort", "diag_gm_matchLose_102_01_mcor_BISH" )  // Bish: Pilots! We've lost this match.
	AddVDULineForBish( "LostAnnouncementShort", "diag_gm_matchLose_102_03_mcor_BISH" )  // Bish: Pilots, we've lost this one.

	/**************************  RoundLostAnnouncement  *****************************/
	/**************************        MILITIA       *****************************/

	//3 Possible lines:
	//Bish:We lost the round!
	//Bish:They beat us this round.
	//Bish:Ahh, they beat us this round. We'll get them next time.

	AddVDULineForBish( "RoundLostAnnouncement", "diag_gm_gc_roundLost_mcor_Bish" )

	/**************************      SuddenDeath     *****************************/
	/**************************        MILITIA       *****************************/
	AddVDULineForBish( "GameModeAnnounce_CTF_SuddenDeath", "diag_gm_ctf_suddenDeath_mcor_Bish" )
	AddVDULineForBish( "GameModeAnnounce_TDM_SuddenDeath", "diag_tdm_modeAnnc_101_01_mcor_bish" )

	/**************************        IMC       *****************************/
	AddVDULineForBlisk( "GameModeAnnounce_CTF_SuddenDeath", "diag_gm_ctf_suddenDeath_imc_Blisk" )
	AddVDUAnimWithEmbeddedAudioForBlisk( "GameModeAnnounce_TDM_SuddenDeath", "diag_imc_blisk_tdm_modeannounce_01" )
	#endif
}

void function RegisterReplacementTitanConversations()
{
	RegisterConversation( "FirstTitanETA120s",				    VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanETA60s",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanETA30s",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanETA15s",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanETA5s",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanReady",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "FirstTitanInbound",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementReady",				VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacement",					VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementETA120s",			VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementETA60s",				VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementETA30s",				VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementETA15s",				VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "TitanReplacementETA5s",				VO_PRIORITY_PLAYERSTATE )
	RegisterConversation( "AutoTitanDestroyed",					VO_PRIORITY_PLAYERSTATE )

	#if CLIENT

	/**************************************************************************/
	/**************************        IMC        *****************************/
	/************************ FirstTitanETA ***************************/
	AddVDULineForSpyglass( "FirstTitanETA120s", "diag_imc_spyglass_gs_titaneta_61", "spy_VDU_status" ) //Spyglass:    "Pilot, your Titan will be ready in 2 minutes."
	AddVDULineForSpyglass( "FirstTitanETA60s", "diag_imc_spyglass_gs_titaneta_62", "spy_VDU_think_slow" ) //Spyglass: "Pilot, your Titan will be ready in 60 seconds."
	AddVDULineForSpyglass( "FirstTitanETA30s", "diag_imc_spyglass_gs_titaneta_63", "spy_VDU_think_slow" ) //Spyglass: "Pilot, your Titan will be ready in 30 seconds."
	AddVDULineForSpyglass( "FirstTitanETA15s", "diag_imc_spyglass_gs_titaneta_64", "spy_VDU_point" ) //Spyglass:      "Pilot, your Titan will be ready in 15 seconds."
	AddVDULineForSpyglass( "FirstTitanETA5s", "diag_imc_spyglass_gs_titaneta_65", "spy_VDU_status" ) //Spyglass:     "Pilot, your Titan will be ready in 5 seconds."

	/************************ FirstTitanReady ***************************/
	AddVDULineForSpyglass( "FirstTitanReady", "diag_imc_spyglass_gs_firsttitanready_21", "spy_VDU_status" ) //Spyglass: "Titan Online. Signal when ready."
	AddVDULineForSpyglass( "FirstTitanReady", "diag_imc_spyglass_gs_firsttitanready_22", "spy_VDU_think_slow" ) //Spyglass: "Your Titan is ready to drop. Signal when ready."

	/************************ FirstTitanInbound ***************************/
	AddVDULineForSpyglass( "FirstTitanInbound", "diag_imc_spyglass_gs_firsttitaninbound_21", "spy_VDU_status" ) //Spyglass: "Command authenticated. Standby for Titanfall."
	AddVDULineForSpyglass( "FirstTitanInbound", "diag_imc_spyglass_gs_firsttitaninbound_22", "spy_VDU_think_slow" ) //Spyglass: "Acknowledged.  Standby for Titanfall."

	/************************ TitanReplacementReady ***************************/
    AddVDULineForSpyglass( "TitanReplacementReady", "diag_imc_spyglass_gs_replacetitanready_21", "spy_VDU_think_slow" ) //Spyglass: "Replacement Titan Online.  Signal when ready."
	AddVDULineForSpyglass( "TitanReplacementReady", "diag_imc_spyglass_gs_replacetitanready_22", "spy_VDU_think_fast" ) //Spyglass: "Your replacement Titan is ready for launch. Signal when ready."

	/************************ TitanReplacementETA ***************************/
	AddVDULineForSpyglass( "TitanReplacementETA120s", "diag_imc_spyglass_gs_titaneta_01", "spy_VDU_status" ) //Spyglass: "Be advised, your Replacement Titan will be ready in 2 minutes."
	AddVDULineForSpyglass( "TitanReplacementETA60s", "diag_imc_spyglass_gs_titaneta_02", "spy_VDU_think_slow" ) //Spyglass: "Be advised, your Titan will be ready in 60 seconds."
	AddVDULineForSpyglass( "TitanReplacementETA30s", "diag_imc_spyglass_gs_titaneta_03", "spy_VDU_think_slow" ) //Spyglass: "Be advised, your Titan will be ready in 30 seconds"
	AddVDULineForSpyglass( "TitanReplacementETA15s", "diag_imc_spyglass_gs_titaneta_04", "spy_VDU_point" ) //Spyglass: "Be advised, your Titan will be ready in 15 seconds"
	AddVDULineForSpyglass( "TitanReplacementETA5s", "diag_imc_spyglass_gs_titaneta_05", "spy_VDU_status" ) //Spyglass: "Be advised, your Titan will be ready in 5 seconds"

	/************************   TitanReplacement   ***************************/
	AddVDULineForSpyglass( "TitanReplacement", "diag_imc_spyglass_gs_replacetitaninbound_21", "spy_VDU_think_slow" ) //Spyglass: "Acknowledged.  Standby for Titanfall."
	AddVDULineForSpyglass( "TitanReplacement", "diag_imc_spyglass_gs_replacetitaninbound_22", "spy_VDU_think_fast" ) //Spyglass: "Command authenticated. Standby for Titanfall."

	/************************ AutoTitanDestroyed ***************************/
	AddVDULineForSpyglass( "AutoTitanDestroyed", "diag_imc_spyglass_gs_playertitandestroyed_01", "spy_VDU_think_slow" )	// Spyglass: "Be advised, your Titan has been destroyed. Constructing replacement. Standby."
	AddVDULineForSpyglass( "AutoTitanDestroyed", "diag_imc_spyglass_gs_playertitandestroyed_02", "spy_VDU_think_fast" )	// Spyglass: "Be advised, your Titan has been neutralized. Constructing replacement. Standby."
	AddVDULineForSpyglass( "AutoTitanDestroyed", "diag_imc_spyglass_gs_playertitandestroyed_03", "spy_VDU_status" )	// Spyglass: "Be advised, your Titan has been eliminated. Constructing replacement. Standby."

	/**************************************************************************/
	/************************        MILITIA        ************************ */

	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanETA120s", "diag_mcor_sarah_firsttitan_eta_01" ) //SARAH: "Pilot, your Titan will be ready in 2 minutes."
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanETA60s", "diag_mcor_sarah_firsttitan_eta_02" ) //SARAH: "Hey, your Titan will be ready in 60 seconds."
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanETA30s", "diag_mcor_sarah_firsttitan_eta_03" ) //SARAH: "Be advised, Titan ready in 30 seconds."
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanETA15s", "diag_mcor_sarah_firsttitan_eta_04" ) //SARAH: "Titan ready in 15 seconds."

	/************************ FirstTitanReady ***************************/
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanReady", "diag_mcor_sarah_firsttitan_01" ) //SARAH: "Hey, your Titan's good to go. Call it when ready."
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanReady", "diag_mcor_sarah_firsttitan_02" ) //SARAH: ""Ok your Titan's prepped for launch. Call it when ready."

	/************************ FirstTitanInbound ****************************/
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanInbound", "diag_mcor_sarah_firsttitan_03" ) //SARAH: "It's on the way. Standby for Titanfall."
	AddVDUAnimWithEmbeddedAudioForSarah( "FirstTitanInbound", "diag_mcor_sarah_firsttitan_04" ) //SARAH: "You got it. Standby for Titanfall."

	/************************ TitanReplacementReady ***************************/

	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementReady", "diag_mcor_sarah_firsttitan_01" ) //SARAH: "Hey, your Titan's good to go. Call it when ready."
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementReady", "diag_mcor_sarah_firsttitan_02" ) //SARAH: ""Ok your Titan's prepped for launch. Call it when ready."

	/************************ TitanReplacementETA ***************************/

	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementETA120s", "diag_mcor_sarah_firsttitan_eta_01" )  //SARAH: "Pilot, your Titan will be ready in 2 minutes."
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementETA60s", "diag_mcor_sarah_firsttitan_eta_02" ) //SARAH: "Hey, your Titan will be ready in 60 seconds."
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementETA30s", "diag_mcor_sarah_firsttitan_eta_03" ) //SARAH: "Be advised, Titan ready in 30 seconds."
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacementETA15s", "diag_mcor_sarah_firsttitan_eta_04" ) //SARAH: "Titan ready in 15 seconds."

	//Commenting out these lines for E3, using the first Titan ETA lines instead.
	/*AddVDULineForSarah( "TitanReplacementETA120s", "diag_mcor_sarah_replacement_eta_01" ) //Sarah: "Pilot, your Replacement Titan will be ready in 2 minutes."
	AddVDULineForSarah( "TitanReplacementETA60s", "diag_mcor_sarah_replacement_eta_02" ) //Sarah: "Hey, your Replacement Titan will be ready in 60 seconds."
	AddVDULineForSarah( "TitanReplacementETA30s", "diag_mcor_sarah_replacement_eta_03" ) //Sarah: "Be advised, Replacement Titan ready in 30 seconds."
	AddVDULineForSarah( "TitanReplacementETA15s", "diag_mcor_sarah_replacement_eta_04" ) //Sarah: "Replacement Titan ready in 15 seconds." */

	/************************   TitanReplacement   ***************************/
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacement", "diag_mcor_sarah_firsttitan_03" ) //SARAH: "It's on the way. Standby for Titanfall."
	AddVDUAnimWithEmbeddedAudioForSarah( "TitanReplacement", "diag_mcor_sarah_firsttitan_04" ) //SARAH: "You got it. Standby for Titanfall."

	//Restricting to only using lines that say "TitanFall" for now
	/*AddVDULineForSarah( "TitanReplacement", "diag_mcor_sarah_replacementtitan_05" ) //SARAH:Head's up dropping off a titan for you
	AddVDULineForSarah( "TitanReplacement", "diag_mcor_sarah_replacementtitan_06" ) //SARAH: Launching another titan for you now.
	AddVDULineForSarah( "TitanReplacement", "diag_mcor_sarah_replacementtitan_07" ) //SARAH:Good news, replacement titan inbound.
	AddVDULineForSarah( "TitanReplacement", "diag_mcor_sarah_replacementtitan_08" ) //SARAH:Sending down a new titan.*/

	/************************ AutoTitanDestroyed ***************************/
	AddVDUAnimWithEmbeddedAudioForSarah( "AutoTitanDestroyed", "diag_mcor_sarah_replacementtitan_09" )	// SARAH: Hey - your Titan's been destroyed. I'll get you another as soon as I can.
	AddVDUAnimWithEmbeddedAudioForSarah( "AutoTitanDestroyed", "diag_mcor_sarah_titandestroyed_01" )	// SARAH: "Great, your Titan's been destroyed. We're working on a replacement. I'll get back to you when it's done."
	AddVDUAnimWithEmbeddedAudioForSarah( "AutoTitanDestroyed", "diag_mcor_sarah_titandestroyed_02" )	// SARAH: "Pilot, your Titan's been destroyed. I've got a replacement underway. I'll let you know when it's done."
	#endif
}
