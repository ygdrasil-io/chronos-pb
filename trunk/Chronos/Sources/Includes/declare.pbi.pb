#KeyWordColor = $F90806
#MacroColor = $578A49
Global KeyWordUp.s, KeyWordDown.s, KeyWordNone.s, Function.s, CompilerFunction.s, CompilerStructure.s
KeyWordUp = "ProcedureCDLL PorcedureC ProcedureDLL CompilerCondition Procedure If For While Repeat Reapeat Class Structure Enumeration Method Select CompilerIf CompilerSelect"
KeyWordDown = "EndProcedure EndProcedure EndProcedure CompilerEndCondition EndProcedure EndIf Next Wend Until ForEver EndClass EndStructure EndEnumeration EndMethod EndSelect CompilerEndIf CompilerEndSelect"
KeyWordNone = "And ElseIf XIncludeImport Or Not ForEach IncludeImport Else To IncludeFile EnableExplicit DisableExplicit Case Default End CompilerElse ProcedureReturn Global Define Protected Debug NewList XIncludeFile As New Extends CompilerCase"
;=====================================================
;-global
;=====================================================
;{
#YAPI_version = 0
#MainName = "Chronos"
#YAPI_ConfigPath = "."+#MainName
Global Version.s, Title.s
Version=Str(#YAPI_version)+"."+Str(Year(#PB_Compiler_Date)-2000)+"."+Str(Month(#PB_Compiler_Date))+"."+Str(Day(#PB_Compiler_Date))
Title = #MainName + " " + Version + " Alpha"

CompilerCondition #PB_Compiler_OS = #PB_OS_Windows
	#Chronos_exe = #MainName+".exe"
	#DefMaker_exe = "DefMaker.exe"
	#PrefixeFile = "windows"
	#PB_CompilerName = "pbcompiler.exe"
	#PrecompilerName = "precompiler.exe"
	#Extension = ".exe"
CompilerEndCondition

CompilerCondition #PB_Compiler_OS = #PB_OS_Linux Or #PB_Compiler_OS = #PB_OS_MacOS
	#Chronos_exe = #MainName
	#DefMaker_exe = "DefMaker"
	#PrefixeFile = "linux"
	#PB_CompilerName = "pbcompiler"
	#PrecompilerName = "Precompiler"
	#Extension = ".out"
CompilerEndCondition

Enumeration 1
	#ErrorNoInputFile
	#ErrorNoCompilerFound
	#ParameterNotReconised
	#ErrorCompilation
EndEnumeration

Global ChronosSourceFiltre.s = "Chronos Source File (*.pb, *.pbi)|*.pb;*.pbi"
Global ChronosFiltre.s = "Chronos Suported File (*.pb, *.pbi, *.chp)|*.chp;*.pb;*.pbi"

;}

;=====================================================
;-NewPrefs
;=====================================================
;{
Structure NewPrefs
	Group.s
	Name.s
	Value.s
EndStructure
;}

;=====================================================
;-Template
;=====================================================
;{
Structure TemplateName
	Name.s
	Language.s
EndStructure

Structure Template
	Path.s
	IgnoreDir.i
	IgnoreFile.i
	*Name.Array
	*Icon.i
	Mode.b
EndStructure


;}

;=====================================================
;-Projet
;=====================================================
;{
;=====================================================
;-Definition
;=====================================================
;{
Structure Definition
	name.s
	line.i
	File.s
EndStructure

Structure Comment Extends Definition
EndStructure

Structure Function Extends Definition
	Declaration.s
EndStructure

Structure Structure Extends Definition
	StructureAtribut.Array
EndStructure



;}
;=====================================================
;-File
;=====================================================
;{
#Directory = 1
Structure Directory
	*File.Array
	*Dir.Array
	Name.s
EndStructure

Structure File
	Path.s
	File.s
	Text.s
	Saved.b
	*Comment.Array
	*Function.Array
EndStructure

;}

#ProjectIsDynamicLib = 1
#ProjectIsApp = 2
#ProjectIsStaticLib = 3

Structure ProjectOption
	SafeThread.b
	Unicode.b
	ASM.b
	OnError.b
	ThemesXP.b
	AdminMode.b
	UserMode.b
	Precompilation.b
EndStructure




Structure Ressource
	Path.s
	include.b
EndStructure


;}

;=====================================================
;-Compiler
;=====================================================
;{

CompilerCondition #PB_Compiler_OS= #PB_OS_Windows
	#PB_Compiler = "pbcompiler.exe"
	#CompilerFlagVersion = "/VERSION"
	#CompilerFlagStandby = "/STANDBY"
	#CompilerFlagUnicode = "/UNICODE"
	#CompilerFlagASM = "/INLINEASM"
	#CompilerFlagOnError = "/LINENUMBERING"
	#CompilerFlagSafeThread = "/THREAD"
	#CompilerFlagDebugger = "/DEBUGGER"
	#CompilerFlagBuild = "/EXE"
	#CompilerFlagQuiet = "/QUIET"
CompilerEndCondition
CompilerCondition #PB_Compiler_OS = #PB_OS_Linux Or #PB_Compiler_OS = #PB_OS_MacOS
	#PB_Compiler = "pbcompiler"
	#CompilerFlagVersion = "-v"
	#CompilerFlagStandby = "-sb"
	#CompilerFlagUnicode = "-u"
	#CompilerFlagASM = "-i"
	#CompilerFlagOnError = "-"
	#CompilerFlagSafeThread = "-t"
	#CompilerFlagDebugger = "-d"
	#CompilerFlagBuild = "-e"
	#CompilerFlagQuiet = "-q"
CompilerEndCondition

#CompilerFlagGetStructureList = "STRUCTURELIST"
#CompilerFlagQuit = "END"
#CompilerFlagEndOutput = "OUTPUT	COMPLETE"
#CompilerFlagGetFunctionList = "FUNCTIONLIST"
#x86 = 0
#x64 = 1

Structure CompilerStructure
	Name.s
	*atribut.Array
EndStructure

Structure Atribut
	Name.s
	Type.s
	Array.b
EndStructure

Structure CompilerFunction
	Name.s
	Declaration.s
EndStructure

;}




;=====================================================
;-IHM
;=====================================================
;{
Enumeration
	#WIN_Main
	#WIN_Search
	#WIN_NewProject
	#WIN_Option
	#WIN_OptionCompilation
	#WIN_OptionProject
EndEnumeration

Enumeration
	#Menu_Main
	#Menu_ProjectDirectory
	#Menu_ProjectFile
EndEnumeration

#NB_ToolBar = 1
#NB_Win = 10
#NB_Menu = 5
#NB_Gadget = 100
#NB_StatusBar = 1
#NB_Image = 50

Enumeration
	#New
	#NewProject
	#AutoIndent
	#Open
	#Save
	#SaveAs
	#Close
	#CloseAll
	#Quit
	#Undo
	#redo
	#cut
	#copy
	#paste
	#SlctAll
	#search
	#Compiler
	#CompilerProject
	#CompilerOptions
	#BuildCurrentFile
	#SwitchStructure
	#TabOnly
	#Option
	#KillProgram
	;Popup
	#RemoveFile
	#RemoveDirectory
	#AddFileFromFile
	#AddEmptyFile
	
	
EndEnumeration


Enumeration
	#GD_projet
	#GD_FirstPanel
	#GD_Explorer
	#GD_SecondPanel
	#GD_ListComilateur
	#GD_Scintilla
	#GD_MainPanel
	;projet
	#GD_TreeProject
	#GD_ProjectFile
	#GD_ProjectComment
	#GD_ProjectClass
	#GD_ProjectProcedure
	#GD_ProjectProject
	#GD_ProjectAddFile
	#GD_ProjectOption
	#GD_ProjectAPI
	#GD_ProjectClose
	#GD_ProjectStructure
	#GD_ProjectBuild
	;projet-option
	#GD_CancelProjectOption
	#GD_ConfirmProjectOption
	#GD_EnableProjectASM
	#GD_EnableProjectUnicode
	#GD_EnableProjectSafeThread
	#GD_EnableProjectOnError
	#GD_EnableProjectXPSkin
	#GD_EnableProjectAdministratorMode
	#GD_EnableProjectUserMode
	#GD_EnableProjectPrecompiler
	#GD_ProjectTypeList
	;other  interface generale
	#GD_SearchString
	#GD_SearchReplaceString
	#GD_SearchNext
	#GD_SearchReplaceAll
	#GD_SearchReplace
	
	
	#GD_TextNewPathCompiler
	#GD_SetPathAddCompiler
	#GD_ConfirmAddCompiler
	
	#GD_TreeTemplate
	#GD_SetPathNewProject
	#GD_PathNewProject
	#GD_CancelNewProject
	#GD_CreateNewProject
	#GD_NameNewProject
	
	#GD_TreeOption
	#GD_OptionConfirm
	#GD_OptionCancel
	#GD_OptionDone
	#GD_FrameLanguage
	#GD_ListLanguage
	#GD_FrameColor
	#GD_TextColor_Text
	#GD_TextColor_KeyWord
	#GD_TextColor_Function
	#GD_TextColor_Constant
	#GD_TextColor_String
	#GD_TextColor_Operator
	#GD_TextColor_Comment
	#GD_ImageColor_Text
	#GD_ImageColor_KeyWord
	#GD_ImageColor_Function
	#GD_ImageColor_Constant
	#GD_ImageColor_String
	#GD_ImageColor_Operator
	#GD_ImageColor_Comment
	#GD_FramePath
	#GD_X86Path_Text
	#GD_X64Path_Text
	#GD_X86Path
	#GD_X64Path
	#GD_X86Path_Select
	#GD_X64Path_Select
	
	#GD_ConfirmSetCompilerOption
	#GD_CancelSetCompilerOption
	#GD_EnableASM
	#GD_EnableUnicode
	#GD_EnableSafeThread
	#GD_EnableOnError
	#GD_EnableXPSkin
	#GD_EnableAdministratorMode
	#GD_EnableUserMode
	#GD_EnablePrecompiler
EndEnumeration

Enumeration 1
	#OptionLang
	#OptionColor
	#OptionCompiler
EndEnumeration
;-IHM-image
Enumeration
	#ImageColor_Text
	#ImageColor_KeyWord
	#ImageColor_Function
	#ImageColor_Constant
	#ImageColor_String
	#ImageColor_Operator
	#ImageColor_Comment
	
	#ImageIcon_File
	#ImageIcon_Comment
	#ImageIcon_Class
	#ImageIcon_Procedure
	#ImageIcon_Project
	#ImageIcon_AddFile
	#ImageIcon_Option
	#ImageIcon_API
	#ImageIcon_Kill
	#ImageIcon_CloseProject
	#ImageIcon_Structure
	#ImageIcon_Build
	
	#ImageIcon_Directory
	#ImageIcon_FileTree
EndEnumeration


;}
;=====================================================
;-Scintilla
;=====================================================
;{

Enumeration 0
	#LexerState_Function
	#LexerState_Space
	#LexerState_Comment
	#LexerState_NonKeyword
	#LexerState_Keyword
	#LexerState_FoldKeyword
	#LexerState_Constant
	#LexerState_String
	#LexerState_FoldKeywordUp
	#LexerState_FoldKeywordDown
	#LexerState_Operator
EndEnumeration

;}




; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 404
; FirstLine = 365
; Folding = --
; EnableXP