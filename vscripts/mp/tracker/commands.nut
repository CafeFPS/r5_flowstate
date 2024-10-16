//commands.nut																//mkos

global function Commands_ReturnBaseCmdForAlias
global function Commands_ReturnBaseArgForAlias

global function Commands_AllArgAliasesContains
global function Commands_AllCmdAliasesContains

global function Commands_ArgAliasPointsTo
global function Commands_CmdAliasPointsTo

global function Commands_RequiresValidPlayer
global function Commands_GetCommandAliases
global function Commands_GetCommandHandler
global function Commands_DoesExist
global function Commands_Register

global function Commands_GetArgAliases
global function Commands_ArgDoesExist
global function Commands_SetupArg					

global typedef CommandCallback void functionref( string, array<string>, entity )

const bool PRINT_REGISTERED = true

struct CommandData
{
	CommandCallback handler
	array<string> aliases
	bool bRequiresValidPlayer
}

struct ArgData
{
	array<string> aliases
}

struct 
{
	table< string, CommandData > commandCallbacks
	table< string, string > cmdAliasLookupTable
	
	table< string, ArgData > argTable
	table< string, string > argAliasLookupTable
	
} file

void function nullreturn( string cmd, array<string> args, entity activator ) 
{
	#if DEVELOPER
		printw( "No handler for command:", cmd )
	#endif
}

/*
	Purpose:
	
	Tie a callback to handle a registered command and script it's functioinality such that
	When a user does a chat command of /rest, it does some checks and calls the function that 
	handles the args / request. These can be enabled conditionally once inside of a gamemodes
	own script file.
	
	All functions with Commands_ are global and can be used to make other features like chat commands.
*/

///////////////////////////////////////////////////////
///////					Commands				///////
///////////////////////////////////////////////////////

void function Commands_Register( string cmd, CommandCallback ornull handlerFunctionOrNull = null, array<string> aliases = [], bool bRequiresValidPlayer = true ) 
{
	mAssert( !empty( cmd ), "Cannot register empty command" )
	
	if ( !Commands_DoesExist( cmd ) )
	{
		CommandCallback handlerFunction = nullreturn
		
		if( handlerFunctionOrNull != null )
			handlerFunction = expect CommandCallback ( handlerFunctionOrNull )
		
		CommandData data
		
		data.handler = handlerFunction
		data.aliases = aliases
		data.bRequiresValidPlayer = bRequiresValidPlayer
		
		file.commandCallbacks[ cmd ] <- data	
		
		#if DEVELOPER && PRINT_REGISTERED
			printw( "== Registered command:", cmd, " handler: " + string( handlerFunction ) + "() ==" )
		#endif
		
		__InsertCmdAliasLookupTable( cmd, aliases )	
    } 
	else
	{
		#if DEVELOPER
			printw( "Command", "\"" + cmd + "\"", "already exists" )
		#endif
	}
}

bool function Commands_DoesExist( string cmd )
{
	return ( cmd in file.commandCallbacks )
}

CommandCallback function Commands_GetCommandHandler( string cmd ) 
{
	if ( cmd in file.commandCallbacks )
		return file.commandCallbacks[ cmd ].handler
		
	return nullreturn
}

bool function Commands_CmdAliasPointsTo( string alias, string cmd )
{
	if( !Commands_DoesExist( cmd ) )
		return false
	
	if( Commands_ReturnBaseCmdForAlias( alias ) == cmd  )
		return true
		
	return false
}

array<string> function Commands_GetCommandAliases( string cmd )
{
	if( Commands_DoesExist( cmd ) )
		return file.commandCallbacks[ cmd ].aliases
		
	array<string> emptyArray
	return emptyArray
}

string function Commands_ReturnBaseCmdForAlias( string cmdAlias )
{
	if( cmdAlias in file.cmdAliasLookupTable )
		return file.cmdAliasLookupTable[ cmdAlias ]
	
	return ""
}

bool function Commands_RequiresValidPlayer( string cmd )
{
	if ( cmd in file.commandCallbacks )
		return file.commandCallbacks[ cmd ].bRequiresValidPlayer
		
	return false
}

bool function Commands_AllCmdAliasesContains( string alias )
{
	return ( alias in file.cmdAliasLookupTable )
}

///////////////////////
// commands internal //////////////////////////////////////////////////////////////////
///////////////////////

void function __InsertCmdAliasLookupTable( string cmd, array<string> aliases )
{
	__CmdAliasTable_CheckSlot( cmd, cmd )
		
	foreach( alias in aliases )
		__CmdAliasTable_CheckSlot( alias, cmd )
}

void function __CmdAliasTable_CheckSlot( string alias, string cmd )
{
	if( !( alias in file.cmdAliasLookupTable ) )
	{
		file.cmdAliasLookupTable[ alias ] <- cmd

		#if DEVELOPER && PRINT_REGISTERED
			printw( "Registered command alias \"" + alias + "\" for [", cmd, "]" )
		#endif
	}
	#if DEVELOPER
	else
		mAssert( false, "Tried to insert a key in command table twice. Duplicate cmd aliases running?" )
	#endif
}

/*
	Purpose:
	
	Like Commands, arg setup is currently only used to customize aliases for args and take 
	advantage of separating gamemode logic into it's own files without conditionals. 
	
	All functions with Commands_ are global and can be used to make other features like custom arg aliases.
*/

///////////////////////////////////////////////////////
///////					Args					///////
///////////////////////////////////////////////////////

void function Commands_SetupArg( string arg, array<string> aliases = [] )
{
	mAssert( !empty( arg ), "Cannot register empty arg" )
	
	if ( !Commands_ArgDoesExist( arg ) ) 
	{
		ArgData data 
		
		data.aliases = aliases
		
		file.argTable[ arg ] <- data

		#if DEVELOPER && PRINT_REGISTERED
			printw( "== Registered arg \"" + arg + "\"" )
		#endif
		
		__InsertArgAliasLookupTable( arg, aliases )
	}
	else
	{
		#if DEVELOPER
			printw( "Arg", "\"" + arg + "\"", "already exists" )
		#endif
	}
}

bool function Commands_ArgDoesExist( string arg )
{
	return ( arg in file.argTable )
}

string function Commands_ReturnBaseArgForAlias( string argAlias )
{
	if( argAlias in file.argAliasLookupTable )
		return file.argAliasLookupTable[ argAlias ]
	
	return ""
}

bool function Commands_AllArgAliasesContains( string alias )
{
	return ( alias in file.argAliasLookupTable )
}

array<string> function Commands_GetArgAliases( string arg )
{
	if( Commands_ArgDoesExist( arg ) )
		return file.argTable[ arg ].aliases
		
	array<string> emptyArray
	return emptyArray
}

bool function Commands_ArgAliasPointsTo( string alias, string arg )
{
	if( !Commands_ArgDoesExist( arg ) )
		return false
	
	if( Commands_ReturnBaseArgForAlias( alias ) == arg  )
		return true
		
	return false
}

///////////////////
// args internal //////////////////////////////////////////////////////////////////
///////////////////

void function __InsertArgAliasLookupTable( string arg, array<string> aliases )
{
	__ArgAliasTable_CheckAndCreateSlot( arg, arg )
		
	foreach( alias in aliases )
		__ArgAliasTable_CheckAndCreateSlot( alias, arg )
}

void function __ArgAliasTable_CheckAndCreateSlot( string alias, string arg )
{
	if( !( alias in file.argAliasLookupTable ) )
	{
		file.argAliasLookupTable[ alias ] <- arg
		
		#if DEVELOPER && PRINT_REGISTERED
			printw( "Registered arg alias: \"" + alias + "\" for arg [", arg, "]" )
		#endif
	}
	#if DEVELOPER
	else 
		mAssert( false, "Tried to insert a key in arg alias table twice. Duplicate arg aliases running?" )
		
	#endif
}