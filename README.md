# R5 Flow State 2.0
Welcome to the first official release of Flow State (previously known as Mechanics Grinding), by Retículo Endoplasmático#5955 & michae\l/#1125.

Flow State is a comprehensive DM enthusiast playlist custom_tdm playlist designed for rapid skill improvement through repeated mechanics drilling.

However, it also has a number of QOL / UX features not present in the original that makes for a smoother experience - namely a seamless round transition / lobby system, practice DM mechanics (auto-reload on kill, utility), leaderboard stat tracking (KD, damage, ping), support for other modes (e.g surf), and host customization / server options (auto-switch levels, all-chat, admin messages, insta-loadout switches, instantly re-balance teams). Also included in this playlist is the very one of R5's very first full-scale custom DM maps "Skill Trainer" (by CaféDeColombiaFPS, map index 1), as well as a Surf Purgatory (by AyeZee, map index 3 - movement values are adjusted accordingly if this level is selected).

Changelog (from 1.4):
* S11 weapon support (no custom configs needed - CAR replaces Alternator, Volt files included).
* Stability / UI fixes
* A much faster / improved game loop
* "Quick" lobby toggle (this WILL cause loading issues with players with high ping)
* Removed challenger / champion kill audio due to audio clutter
* ~~DUMMY model override - player models can now be set to dummies, color coded by team. Helps with identifying aligned enemies in more hectic TDM games which can reliably signal a player to start disengaging.~~
* Data knife melee animation pog
* Global kill counts can now be reset each round - kill leader announcer audio will now be accurate past 1 round.
* Auto-reload on kill improvements (last used gun will ALWAYS autofill regardless of whether it dealt the killing blow)
* Toggle option for reloading secondary on kill (enabled by default)
* New console commands:
  * scoreboard - displays a full scoreboard to user (kills, deaths, KD ratio, damage)
  * latency - displays the adjusted ping of all players to user (host ping is always 50, adjusted ping subtracts 40).
  * say [MESSAGE] - send a global announcement to all users. on a global cooldown (after use, disabled for all users for length of cooldown). DISABLED by default due to potential user abuse. we are working on an improved version of all-chat, but here is a ghetto version.
  * spectate - enables observer mode (and kills you, so don't do this while fighting).
  * commands - displays a menu with all of these commands.


New admin commands:
  * teambal [X] - RANDOMLY re-assigns players to X amount of teams. Helpful if players are leaving and you find yourself in a 2v2v1 type situation.
  * circlenow - teleports all players in a circle around you. Initiate the fucking thunderdome.
  * adminsay [MESSAGE] - send an announcement to all users (example usage: "adminsay stop abusing 3dash and get off the roof u actual weirdo")
  * pritoall / sectoall - equip chosen primary / secondary for all players immediately. same as tgive syntax.
  * next_round [X] [now] - sets the next map level to map index X (map array is in sh_gamemode_custom_tdm.nut). including the now flag will instantly switch the map.
