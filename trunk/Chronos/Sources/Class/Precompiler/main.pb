;=============================================================;
;Chronos Precompiler                                                                                                                                      ;
;=============================================================;
EnableExplicit
IncludeFile "../../CommonsLib/Array.pb"
IncludeFile "../../CommonsLib/Preferences/declaration.pb"
IncludeFile "../../CommonsLib/Preferences/Preferences.class.pb"
IncludeFile "../../CommonsLib/AdvanceString.pb"
IncludeFile "declare.pbi"
IncludeFile "string.pb"
IncludeFile "Line.Class.pb"
IncludeFile "Macro.class.pb"
IncludeFile "attribut.Class.pb"
IncludeFile "Constant.class.pb"
IncludeFile "StructureAttribut.class.pb"
IncludeFile "Structure.class.pb"
IncludeFile "ProcedureAttribut.class.pb"
IncludeFile "ClassAttribut.class.pb"
IncludeFile "Procedure.class.pb"  
IncludeFile "Variable.class.pb"
IncludeFile "Method.class.pb"
IncludeFile "Class.class.pb"
IncludeFile "precompiler.class.pb"
Define *Prefs = NewPreferences("Chronos")
*Precompiler = NewCompiler(GetPreference(*Prefs, "GENERAL", "MainPath") + "API/" )
If OpenConsole()
	ConsoleTitle("Chronos Precompiler")
	Define Ending.s, Count.b = CountProgramParameters(), File.s
	Define Exec = #False, GenerateDestination.s = "", back.s, Destination.s
	Define Parameter.s
	If Not Count = 2
		PrintN("Error:File Not Found")
	EndIf
	File = ProgramParameter()
	Destination = ProgramParameter()
	PrintN("Start Chronos")
	LoadFile(*Precompiler, File)
	PrintN("Load All Files Succes")
	LoadStructure(*Precompiler)
	PrintN("Load Structure Files Succes")
	FormatCode(*Precompiler)
	PrintN("Format Code Files Succes")
	WriteFile(*Precompiler, Destination)
	PrintN("Precompilation Done")
EndIf
; IDE Options = PureBasic 4.30 (Linux - x86)
; ExecutableFormat = Console
; CursorPosition = 14
; FirstLine = 1
; Folding = -
; UseIcon = ..\default.ico
; Executable = ../Precompiler