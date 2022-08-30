/*
Flowstate Aim Trainer v1.0 - Made by CaféDeColombiaFPS (server, client, ui)
Discord: Retículo Endoplasmático#5955 | Twitter: @CafeFPS
Aim trainer repo to grab updates: https://github.com/ColombianGuy/r5_aimtrainer

I'm from Colombia and I don't have a job other than modding Apex, in this country 1 dollar is a lot. 
If you enjoy the mod and want to support me, please consider a donation: https://ko-fi.com/r5r_colombia ^^

I know all the code can be masivelly improved and there are a lot of things that are working with tape and glue,
I'm still learning so if you have any feedback about code or challenges improvements, or new ideas in general I'll really appreciate it, 
feel free leave me a dm in discord.
Hecho en Colombia con amor y mucha dedicación para toda la comunidad de Apex Legends.

More credits!
- Zee#6969 -- gave me weapons buy menu example
- rexx#1287 -- repak tool https://github.com/r-ex/RePak
- Skeptation#4002 -- beta tester
- Rego#2848 -- beta tester
- michae\l/#1125 -- beta tester
- James9950#5567 -- beta tester
- (--__GimmYnkia__--)#2995 -- beta tester
- oliver#1375 -- beta tester
- Rin 暗#5862 -- beta tester
*/


global function Sh_ChallengesByColombia_Init

global int AimTrainer_CHALLENGE_DURATION = 60
global int AimTrainer_AI_SHIELDS_LEVEL = 0
global float AimTrainer_STRAFING_SPEED = 1
global float AimTrainer_STRAFING_SPEED_WAITTIME = 1
global bool RGB_HUD = false
global bool AimTrainer_INFINITE_CHALLENGE = false
global bool AimTrainer_INFINITE_AMMO = true
global bool AimTrainer_INFINITE_AMMO2 = false
global bool AimTrainer_INMORTAL_TARGETS = false
global bool AimTrainer_USER_WANNA_BE_A_DUMMY = false
global bool ENABLE_HIT_DOT = false

global const int AimTrainer_RESULTS_TIME = 10
global const float AimTrainer_PRE_START_TIME = 3.0 //description time

void function Sh_ChallengesByColombia_Init()
{
	RegisterSignal("ForceResultsEnd_SkipButton")
	PrecacheParticleSystem($"P_wpn_lasercannon_aim_short_blue")
}