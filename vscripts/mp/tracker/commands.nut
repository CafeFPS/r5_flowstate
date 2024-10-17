//commands.nut																//mkos

global function Commands_ReturnBaseCmdForAlias
global function Commands_ReturnBaseArgForAlias

global function Commands_AllArgAliasesContains
global function Commands_AllCmdAliasesContains

global function Commands_ArgAliasPointsTo
global function Commands_CmdAliasPointsTo

global function Commands_RequiresPlayersCommandsEnabled
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
	bool bRequiresCommandsEnabled
}

struct ArgData
{
	array<string> aliases
}

struct 
{
	table< string, CommandData > commandHandlers
	table< string, string > cmdAliasLookupTable
	
	table< string, ArgData > argTable
	table< string, string > argAliasLookupTable
	
} file

/*
	Purpose:
	
	Tie a callback to handle a registered command and script it's functioinality such that
	When a user does a chat command of /rest, it does some checks and calls the function that 
	handles the args / request. These can be registered conditionally inside of a gamemode's
	own script init file.
	
	All function names prefixed with Commands_ are global and can be used to make other features like chat commands.
*/

/*

	Documentation:
	
	It is preferable that interfaces with systems are done via ui, however
	It is convenient for server mods to be able to experiment or change behavior
	via client commands. 
	
	If a gamemode or server operator wants to provide the ability to call a server 
	function via chat as opposed to via console, they can expose this via Commands_Register()
	
	Example:
		Commands_Register( "!rest", cmd_rest, [ "/rest", "\\rest" ], true )
		
		
	1.	The command name
	
		1a. Example: "!rest"
	
	
	
	2.	The functionref to handle it or null: AFunctionName 
	
		2a. Example: in the function callback, can forward call the function that handles ClientCommand callback for "rest" normally
			See Below for more info	on creating func and what params it wants.	
			
	
	
	3.	An Array of aliases (strings) that also trigger this command's behavior.
	
		3a. Example: [ "!sleep", "!break" ]
		
		
		
	4.	Set to false to bypass player's command processing disabled status. ( true by default )
	
		4a. Example: a player is command disabled for all client command callbacks, 
		and when they try to use a command registered here via chat, if this command 
		is marked as false, it lets them do something scripted anyway. + dev purposes.
	
	
	"rest" now needs access to more args when passed to ClientCommand callback func in certain circumstances, 
	This is no issue. Your callback will get all the data needed if any is needed at all. (custom commands)
	
	CommandCallback type function = ( string, array<string>, entity )
	Your callback will get called when your command is issued in chat by: handler( baseCmd, args, player )
	
	baseCmd = What you registered the commmand as in Commands_Register, which can be used to get other info.
	args 	= the args that got passed when command was triggered in chat.
	player  = the activator of your function. ( player entity )
	
	Theoretically one could use the same callback for all of their commands and have a switch statement based on base command if wanted.	
	
	
	///
	
	
	Be mindful with user provided args, it can't be trusted innately. 
	
	numbers -> IsNumeric( string data, minRange, maxRange ) before Int() or .tointeger()
	check against pregmatch / max len -> IsSafeString( string str, int strlen = -1(unlimited), string pattern = ""(default pattern runs)  ) requires valid preg match expr 
	try{}catch(e){} may be used here if logged properly to avoid failed input conversions and then fix with proper control logic flow using the above.
	bool isTrue = arg[n] == "1" will compare the pointers of the two strings under the hood and wouldn't need checked for numeric because the logic can resume based on pre determined conditions for the pointer match of two strings.
	
	
	///
	
	
	Command Callback for "!rest":
	
		void function cmd_rest( string tag, array<string> args, entity activator )
		{
			if( !g_bRestEnabled() )
				return
				
			switch( Playlist() )
			{
				case ePlaylists.fs_scenarios:
					
					FS_Scenarios_ClientCommand_Rest( activator, args )
					break
					
				case ePlaylists.fs_1v1:
				
					ClientCommand_Maki_SoloModeRest( activator, args )	
					break
			}
		}
*/

///////////////////////////////////////////////////////
///////					Commands				///////
///////////////////////////////////////////////////////

void function Commands_Register( string cmd, CommandCallback ornull handlerFunctionOrNull = null, array<string> aliases = [], bool bRequiresCommandsEnabled = true ) 
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
		data.bRequiresCommandsEnabled = bRequiresCommandsEnabled
		
		file.commandHandlers[ cmd ] <- data	
		
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
	return ( cmd in file.commandHandlers )
}

CommandCallback function Commands_GetCommandHandler( string cmd ) 
{
	if ( cmd in file.commandHandlers )
		return file.commandHandlers[ cmd ].handler
		
	return nullreturn
}

bool function Commands_CmdAliasPointsTo( string alias, string cmd )
{
	if( !Commands_DoesExist( cmd ) )
	{
		#if DEVELOPER
			mAssert( false, "cmd \"" + cmd + "\" doesn't exist." )
		#endif 
		
		return false
	}
	
	if( Commands_ReturnBaseCmdForAlias( alias ) == cmd  )
		return true
		
	return false
}

array<string> function Commands_GetCommandAliases( string cmd )
{
	if( Commands_DoesExist( cmd ) )
		return file.commandHandlers[ cmd ].aliases
		
	array<string> emptyArray
	return emptyArray
}

string function Commands_ReturnBaseCmdForAlias( string cmdAlias )
{
	if( cmdAlias in file.cmdAliasLookupTable )
		return file.cmdAliasLookupTable[ cmdAlias ]
	
	return ""
}

bool function Commands_RequiresPlayersCommandsEnabled( string cmd )
{
	#if DEVELOPER
		if ( !( cmd in file.commandHandlers ) )
		{
			mAssert( false, "Command \"" + cmd + "\" does not exist. Calling function should be checking." ) //reduce check trains
			return false 
		}
	#endif
	
	return file.commandHandlers[ cmd ].bRequiresCommandsEnabled
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
	
	Like Commands, however, arg setup is currently only used to customize aliases for args and take 
	advantage of separating gamemode logic into it's own files without conditionals. 
	
	All functions with Commands_ are global and can be used to make other features.
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



///////////////////////////////////////////////////////
///////					Util					///////
///////////////////////////////////////////////////////

void function nullreturn( string cmd, array<string> args, entity activator ) 
{
	#if DEVELOPER
		printw( "No handler for command:", cmd )
	#endif
}