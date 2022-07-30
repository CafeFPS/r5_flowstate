//Flowstate Aim Trainer my beloved
//Credits: 
//CaféDeColombiaFPS (Retículo Endoplasmático#5955 - @CafeFPS) -- dev
//Zee#6969 -- gave me weapons menu example
//Skeptation#4002 -- main advices and relevant feedback

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
global const float AimTrainer_PRE_START_TIME = 2.5 //description time

void function Sh_ChallengesByColombia_Init()
{
	RegisterSignal("ForceResultsEnd_SkipButton") 
}