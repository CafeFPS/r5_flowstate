# R5RMechanicsGrinding

# v1.3 changelist:
Pls go to releases tab for download our last stable version.
- Stability fix.
- UI text fixes.
- Whitelisted weapons again in the file.
- Revenant spooky announcer cuz spooky month.
- New announcer voices.
____________________________
# README
# 1. Simple Champion UI. Leaderboard from the server side.
- Messages are shown with the scoreboard as the game progresses (only the best 3) are shown.
- Final full scoreboard screen with a cool effect.
- Third person mode when the champion is decided until next round.
- When the champion is decided, the champion will be on fire (thermite trail) and will be visible to all players until next round.
- Custom audio for the champion: "You are the Apex Champion"
- Added deaths and KD counter.

# 2. Fixes
- Auto reload weapon used on kill without animation.
- Auto pullout both weapons on respawn. (We avoid dying when pullout secondary weapon for the first time)
- Seamless Round Switching: includes an extended lobby to solve our most tedious problem: dying in the area during the change of location, this may still occur, but it has been shown to work. This extended lobby is also the screen where the previous round champion is shown, the scoreboard of the previous round, and we wait to the players to load. 

# 3. Character selection for all from the server side.
With this we avoid being assigned fat characters randomly.

# 4. Client commands
-Admin God and Ungod Commands
MakeInvincible Console command for the admin. (so u can go afk without giving free kills kek)

-Next_round
You can choose the next location with "next_round #" based on your sh locations file. Atm you can't insta switch.

In lines 27-32 there are hardcoded settings you must edit: roundtime, bubble color, hoster name and character selected.

Please make sure you have the last version of main scripts repo before using this: https://github.com/Mauler125/scripts_r5
- s10 weapons: https://discord.com/channels/873158454850756638/876850330648842250/897520961006485535
- Crack shield sound fix: https://discord.com/channels/873158454850756638/876850330648842250/896031055964954644
- Our trello: https://trello.com/b/vXqhQwTB/todo-r5-mechanics-grinding-dm-caf%C3%A9decolombiafps-empathogenwarlord

# Name of the file/files modified: 
1. /platform/scripts/vscripts/gamemodes/custom_tdm/_gamemode_custom_tdm.nut (actual script, server-side new features)
2. /platform/scripts/vscripts/gamemodes/custom_tdm/cl_gamemode_custom_tdm.nut (client-side scoreboard, so u can know ur position everytime! this one gets bugged when someone dced and a new player comes in and take their team id. optional!! ) 
3. /platform/scripts/vscripts/ _ health_regen.nut (Cracked shield fix, damage counter shield bleedtrhough fix)
5. Also s10 weapons in weapons folder.
