Hi, I'm Café de Colombia. I hope you are well today.

Working gungame with lastest Mechanics Grinding v1.4 update.

Gungame: You kill, you get different weapon.
Gungame + Shield progression: You start with white and if you get kill streak you get better shield. 2 kills to blue, 5 kills to purple.

1. There are two modes of the gungame gamemode in the vscripts/gamemodes/custom_tdm/gungame folder, you have to choose one.

2. Make a backup of your previous _gamemode_custom_tdm.nut in vscripts/gamemodes/custom_tdm/ file, rename the gungame file selected and paste it there. It must have this name: _gamemode_custom_tdm.nut

4. In your custom_tdm section in the playlist,  this is playlists_r5_patch.txt in platform folder:

				respawn_kit_enabled                   1
				//respawn_kit_primary_weapon          "mp_weapon_wingman optic_cq_hcog_classic highcal_mag_l3"
				respawn_kit_secondary_weapon  "mp_weapon_r97 barrel_stabilizer_l4_flash_hider optic_cq_hcog_classic bullets_mag_l3 stock_tactical_l3"
				//respawn_kit_tactical                "mp_ability_phase_walk"
				//respawn_kit_ultimate                "mp_ability_3dash"

Please leave primary weapon, tactical and ultimate disabled.

3.  In your custom_tdm section in the playlist also add this:

				maxweapons									    27
				tactical_ability							    "mp_ability_grapple"
				ultimate_ability							    "mp_ability_3dash"
				weapon0		"mp_weapon_lmg"
				weapon0_0	"optic_ranged_hcog"
				weapon0_1	"highcal_mag_l1"
				weapon0_2	"barrel_stabilizer_l4_flash_hider"
				weapon0_3	"stock_tactical_l3"
				weapon1		"mp_weapon_shotgun_pistol"
				weapon1_0	"optic_cq_hcog_classic"
				weapon1_1	"shotgun_bolt_l1"
				weapon2	"mp_weapon_hemlok"
				weapon2_0	"highcal_mag_l3"
				weapon2_1	"optic_cq_hcog_bruiser"
				weapon2_2	"barrel_stabilizer_l4_flash_hider"
				weapon2_3	"stock_tactical_l3"
				weapon3		"mp_weapon_shotgun"
				weapon3_0	"optic_cq_hcog_classic"
				weapon3_1	"shotgun_bolt_l3"
				weapon4		"mp_weapon_energy_shotgun"
				weapon4_0	"optic_cq_hcog_classic"
				weapon4_1	"shotgun_bolt_l3"
				weapon5		"mp_weapon_alternator_smg"
				weapon5_0	"optic_cq_threat"
				weapon5_1	"bullets_mag_l3"
				weapon6		"mp_weapon_wingman"
				weapon6_0	"optic_cq_hcog_classic"
				weapon6_1	"highcal_mag_l3"
				weapon7		"mp_weapon_pdw"
				weapon7_0	"optic_cq_threat"
				weapon7_1	"highcal_mag_l3"
				weapon7_2	"stock_tactical_l3"
				weapon8		"mp_weapon_r97"
				weapon8_0	"optic_cq_hcog_classic"
				weapon8_1	"bullets_mag_l3"
				weapon8_2	"barrel_stabilizer_l4_flash_hider"
				weapon8_3	"stock_tactical_l3"
				weapon9		"mp_weapon_rspn101"
				weapon9_0	"optic_cq_hcog_bruiser"
				weapon9_1	"bullets_mag_l3"
				weapon9_2	"stock_tactical_l3"
				weapon9_3	"barrel_stabilizer_l4_flash_hider"
				weapon10		"mp_weapon_mastiff"
				weapon11	"mp_weapon_energy_ar"
				weapon11_0	"optic_cq_hcog_bruiser"
				weapon11_1	"energy_mag_l3"
				weapon12	"mp_weapon_vinson"
				weapon12_0	"optic_cq_hcog_bruiser"
				weapon12_1	"highcal_mag_l3"
				weapon13	"mp_weapon_g2"
				weapon13_0	"optic_cq_hcog_bruiser"
				weapon13_1	"bullets_mag_l1"
				weapon14	"mp_weapon_lstar"
				weapon15	"mp_weapon_lmg"
				weapon15_0	"optic_cq_hcog_bruiser"
				weapon15_1	"highcal_mag_l3"
				weapon16	"mp_weapon_dmr"
				weapon16_0	"optic_ranged_aog_variable"
				weapon17	"mp_weapon_doubletake"
				weapon17_0	"optic_ranged_aog_variable"
				weapon17_1	"hopup_energy_choke"									
				weapon18 	"mp_weapon_shotgun_pistol"
				weapon18_0	"optic_cq_hcog_classic"
				weapon18_1	"shotgun_bolt_l3"
				weapon19	"mp_weapon_r97"
				weapon20	"mp_weapon_lstar"
				weapon21	"mp_weapon_shotgun_pistol"
				weapon21_0	"optic_cq_threat"
				weapon21_1	"shotgun_bolt_l3"
				weapon22	"mp_weapon_energy_ar"
				weapon22_0	"optic_cq_hcog_bruiser"
				weapon23	"mp_weapon_g2"
				weapon23_0	"optic_ranged_hcog"
				weapon23_1	"bullets_mag_l3"
				weapon23_2	"barrel_stabilizer_l4_flash_hider"
				weapon23_3	"stock_sniper_l3"
				weapon24		"mp_weapon_shotgun_pistol"
				weapon24_0	"optic_cq_hcog_classic"
				weapon24_1	"shotgun_bolt_l1"
				weapon25 "mp_weapon_vinson"
				weapon26		"mp_weapon_shotgun_pistol"
				weapon26_0	"optic_cq_hcog_classic"
				weapon26_1	"shotgun_bolt_l1"
				
4. Now you can try to run the gungame!