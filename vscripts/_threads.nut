untyped

//********************************************************************************************
// _threads.nut
//********************************************************************************************

global table<string,var> level

global function IsTable
global function IsArray
global function IsNumber
global function IsFunction
global function IsString
global function IsDeadCoroutine

global function VM_NAME
global function FUNC_NAME
global function FILE_NAME
global function DBG_INFO

global function printt
global function PrintFunc
global function printt_spamLog
global function printl_spamLog

global function LevelVarInit


global bool reloadingScripts = false
global bool reloadedScripts = false

#if DEVELOPER
global function __serialize_state
global function __evalBreakpoint
#endif


bool function IsTable( var variable ) {
	return (type( variable ) == "table")
}

bool function IsArray( var variable ) {
	return (type( variable ) == "array")
}

bool function IsNumber( var variable ) {
	return (type( variable ) == "float" || type( variable ) == "int")
}

bool function IsFunction( var variable ) {
	return (type( variable ) == "function")
}

bool function IsString( var variable ) {
	return (type( variable ) == "string")
}

bool function IsDeadCoroutine( var co ) {
	return (co.getstatus() == "idle" || co.getstatus() == "error")
}

void function printt( ... )
{
	if ( vargc <= 0 )
		return

	local msg = vargv[0]
	for ( int i = 1; i < vargc; i++ )
		msg = (msg + " " + vargv[i])

	printl( msg )
}

void function PrintFunc( var val = null )
{
	if ( val != null )
	{
		printt( "PrintFunc:", getstackinfos( 2 ).func, val )
	}
	else
	{
		printt( "PrintFunc:", getstackinfos( 2 ).func )
	}
}

string function VM_NAME()
{
	#if SERVER
		return "Server"
	#elseif CLIENT
		return "Client"
	#else
		Assert( UI )
		return "UI"
	#endif
}

string function FUNC_NAME( int up = 0 )
{
	return string( getstackinfos( 2 + up ).func )
}

string function FILE_NAME( int up = 0 )
{
	return string( getstackinfos( 2 + up ).src )
}

string function DBG_INFO()
{
	string vmName   = VM_NAME()
	var stackInfos  = getstackinfos( 2 )
	string fileName = expect string(stackInfos.src)
	int lineNum  = expect int(stackInfos.line)
	string funcName = expect string(stackInfos.func)
	return "[" + VM_NAME() + ":" + fileName + ":" + lineNum + ":" + funcName + "]"
}

void function printt_spamLog( ... )
{
	if ( vargc <= 0 )
		return

	local msg = vargv[0]
	for ( int i = 1; i < vargc; i++ )
		msg = (msg + " " + vargv[i])

	SpamLog( format( "[%.3f] %s\n", Time(), msg ) )
}

void function printl_spamLog( var msg )
{
	SpamLog( format( "%s\n", msg ) )
}

void function LevelVarInit()
{
	table levelVarDelegate = {}
	levelVarDelegate._typeof <- function()
	{
		return "levelTable"
	}

	level = delegate levelVarDelegate : {}

	disableoverwrite( level )
}


#if DEVELOPER

//********************************************************************************************
// _vscript_code.nut
// NOTE: you should not edit this file.
//********************************************************************************************

var function __evalBreakpoint( string evalString )
{
	local stackInfos = getstackinfos( 2 )

	local funcSrc = "return function ("
	local params = []

	params.append( stackInfos.locals["this"] )
	local first = 1
	foreach ( i, v in stackInfos.locals )
	{
		if ( i != "this" && i[0] != '@' ) //foreach iterators start with @
		{
			if ( !first )
			{
				funcSrc = funcSrc + ", "
			}
			first = null
			params.append( v )
			funcSrc = funcSrc + i
		}
	}
	funcSrc = funcSrc + "){\n"
	funcSrc = funcSrc + "return (" + evalString + ")\n}"

	try
	{
		local evalFunc = compilestring( funcSrc, stackInfos.src )
		return evalFunc().acall( params )
	}
	catch( error )
	{
		print( "Eval breakpoint error: " + error + "\n" )
		return false
	}

	return true
}


void function __serialize_state()
{
	/*
		see copyright notice in sqrdbg.h
	*/
	try
	{
		function evaluate_watch( stackframe, stacklevel, expression )
		{
			// add 1 to stackLevel because this function counts as 1
			local res = compilewatch( expression, stacklevel + 1, stackframe.src )
			if ( typeof( res ) == "int" )
				return { status = "ok", val = res }
			else
				return { status = "error", val = res }
		}
		local evaluate_watch = this.evaluate_watch

		/////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////
		{
			local stack = []
			int baseStackFrameIndex = 2
			int level = baseStackFrameIndex
			local si

			//ENUMERATE THE STACK WATCHES
			for ( ;; )
			{
				si = getstackinfos( level )
				if ( !si )
					break
				stack.append( si )
				level++
			}

			//EVALUATE ALL WATCHES
			foreach ( stackFrameIndex, stackFrame in stack )
			{
				if ( stackFrame.src != "NATIVE" )
				{
					if ( "watches" in this )
					{
						stackFrame.watches <- {}
						foreach ( i, watch in this.watches )
						{
							if ( stackFrame.src != "NATIVE" )
							{
								// adds the watch result to the debugger object collection and returns its index
								stackFrame.watches[i] <- evaluate_watch( stackFrame, stackFrameIndex + baseStackFrameIndex, watch )
							}
							else
							{
								stackFrame.watches[i] <- { status = "error", val = "(code function stack frame)" }
							}
							stackFrame.watches[i].exp <- watch
						}
					}
				}
			}

			beginelement( "calls" )

			foreach ( i, val in stack )
			{
				beginelement( "call" )
				attribute( "fnc", val.func )
				attribute( "src", val.src )
				attribute( "line", string( val.line ) )

				serialize_locals( getthread(), baseStackFrameIndex + i )

				if ( "watches" in val )
				{
					foreach ( watchid, watchval in val.watches )
					{
						beginelement( "w" )
							attribute( "id", string( watchid ) )
							attribute( "exp", watchval.exp )
							attribute( "status", watchval.status )
							attribute( "val", string( watchval.val ) )
						endelement( "w" )
					}
				}
				endelement( "call" )
			}
			endelement( "calls" )
		}

		if ( "threads" in getroottable() )
		{
			local threads = getroottable().threads
			local threadsList = threads.GetThreads()

			beginelement( "threads" )

			foreach ( threadId, threadObj in threadsList )
			{
				if ( threadObj == getthread() )
					continue

				beginelement( "thread" )
					local stack = []
					int level = 1
					local si

					attribute( "id", string( threadObj ) )
					attribute( "state", threadObj.getstatus() )
					for ( ;; )
					{
						si = threadObj.getstackinfos( level )
						if ( !si )
							break
						stack.append( si )
						level++
					}

					beginelement( "tcalls" )
						foreach ( i, val in stack )
						{
							beginelement( "tcall" )
								attribute( "fnc", val.func )
								attribute( "src", val.src )
								attribute( "line", string( val.line ) )

								serialize_locals( threadObj, 1 + i )
							endelement( "tcall" )
						}
					endelement( "tcalls" )
				endelement( "thread" )
			}
			endelement( "threads" )
		}

		beginelement( "objs" )
		serialize_debugger_object_collection()
		endelement( "objs" )

		if ( "collectgarbage" in getroottable() )
			collectgarbage()
	}
	catch( error )
	{
		print( "DEBUG SERIALIZATION ERROR: "+ error +"\n" )
	}
}

#endif // DEVELOPER
