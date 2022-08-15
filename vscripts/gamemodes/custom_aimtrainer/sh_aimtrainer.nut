/* 
Flowstate Aim Trainer my beloved

- CaféDeColombiaFPS (Retículo Endoplasmático#5955 - Twitter @CafeFPS) -- developer: ui, client, server.
- Zee#6969 -- gave me weapons menu example

Main advices, relevant feedback and being nice with me:
- Skeptation#4002
- Rego#2848
- michae\l/#1125
- James9950#5567
- (--__GimmYnkia__--)#2995 
*/

global function Sh_ChallengesByColombia_Init

global int AimTrainer_CHALLENGE_DURATION = 60
global int AimTrainer_AI_SHIELDS_LEVEL = 0
global bool RGB_HUD = false
global bool AimTrainer_INFINITE_CHALLENGE = false
global bool AimTrainer_INFINITE_AMMO = true
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