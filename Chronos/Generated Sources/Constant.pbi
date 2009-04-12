#Debug=#True
#KeyWordColor=$F90806
#MacroColor=$578A49
#YAPI_version=0
#MainName="Chronos"
#YAPI_ConfigPath="."+#MainName
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#Chronos_exe=#MainName+".exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#DefMaker_exe="DefMaker.exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#PrefixeFile="windows"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#PB_CompilerName="pbcompiler.exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#PrecompilerName="precompiler.exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#Extension=".exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#Chronos_exe=#MainName
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#DefMaker_exe="DefMaker"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#PrefixeFile="linux"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#PB_CompilerName="pbcompiler"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#PrecompilerName="Precompiler"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#Extension=".out"
CompilerEndif
#ErrorNoInputFile=1
#ErrorNoCompilerFound=2
#ParameterNotReconised=3
#ErrorCompilation=4
#Directory=1
#ProjectIsDynamicLib=1
#ProjectIsApp=2
#ProjectIsStaticLib=3
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#PB_Compiler="pbcompiler.exe"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagVersion="/VERSION"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagStandby="/STANDBY"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagUnicode="/UNICODE"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagASM="/INLINEASM"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagOnError="/LINENUMBERING"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagSafeThread="/THREAD"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagDebugger="/DEBUGGER"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagBuild="/EXE"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Windows
#CompilerFlagQuiet="/QUIET"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#PB_Compiler="pbcompiler"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagVersion="-v"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagStandby="-sb"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagUnicode="-u"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagASM="-i"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagOnError="-"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagSafeThread="-t"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagDebugger="-d"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagBuild="-e"
CompilerEndif
CompilerIf #PB_Compiler_OS=#PB_OS_Linux Or #PB_Compiler_OS=#PB_OS_MacOS
#CompilerFlagQuiet="-q"
CompilerEndif
#CompilerFlagGetStructureList="STRUCTURELIST"
#CompilerFlagQuit="END"
#CompilerFlagEndOutput="OUTPUT	COMPLETE"
#CompilerFlagGetFunctionList="FUNCTIONLIST"
#x86=0
#x64=1
#WIN_Main=0
#WIN_Search=1
#WIN_NewProject=2
#WIN_Option=3
#WIN_OptionCompilation=4
#WIN_OptionProject=5
#Menu_Main=0
#Menu_ProjectDirectory=1
#Menu_ProjectFile=2
#NB_ToolBar=1
#NB_Win=10
#NB_Menu=5
#NB_Gadget=100
#NB_StatusBar=1
#NB_Image=50
#New=0
#NewProject=1
#AutoIndent=2
#Open=3
#Save=4
#SaveAs=5
#Close=6
#CloseAll=7
#Quit=8
#Undo=9
#redo=10
#cut=11
#copy=12
#paste=13
#SlctAll=14
#search=15
#Compiler=16
#CompilerProject=17
#CompilerOptions=18
#BuildCurrentFile=19
#SwitchStructure=20
#TabOnly=21
#Option=22
#KillProgram=23
#RemoveFile=24
#RemoveDirectory=25
#AddFileFromFile=26
#AddEmptyFile=27
#GD_projet=0
#GD_FirstPanel=1
#GD_Explorer=2
#GD_SecondPanel=3
#GD_ListComilateur=4
#GD_Scintilla=5
#GD_MainPanel=6
#GD_TreeProject=7
#GD_ProjectFile=8
#GD_ProjectComment=9
#GD_ProjectClass=10
#GD_ProjectProcedure=11
#GD_ProjectProject=12
#GD_ProjectAddFile=13
#GD_ProjectOption=14
#GD_ProjectAPI=15
#GD_ProjectClose=16
#GD_ProjectStructure=17
#GD_ProjectBuild=18
#GD_CancelProjectOption=19
#GD_ConfirmProjectOption=20
#GD_EnableProjectASM=21
#GD_EnableProjectUnicode=22
#GD_EnableProjectSafeThread=23
#GD_EnableProjectOnError=24
#GD_EnableProjectXPSkin=25
#GD_EnableProjectAdministratorMode=26
#GD_EnableProjectUserMode=27
#GD_EnableProjectPrecompiler=28
#GD_ProjectTypeList=29
#GD_SearchString=30
#GD_SearchReplaceString=31
#GD_SearchNext=32
#GD_SearchReplaceAll=33
#GD_SearchReplace=34
#GD_TextNewPathCompiler=35
#GD_SetPathAddCompiler=36
#GD_ConfirmAddCompiler=37
#GD_TreeTemplate=38
#GD_SetPathNewProject=39
#GD_PathNewProject=40
#GD_CancelNewProject=41
#GD_CreateNewProject=42
#GD_NameNewProject=43
#GD_TreeOption=44
#GD_OptionConfirm=45
#GD_OptionCancel=46
#GD_OptionDone=47
#GD_FrameLanguage=48
#GD_ListLanguage=49
#GD_FrameColor=50
#GD_TextColor_Text=51
#GD_TextColor_KeyWord=52
#GD_TextColor_Function=53
#GD_TextColor_Constant=54
#GD_TextColor_String=55
#GD_TextColor_Operator=56
#GD_TextColor_Comment=57
#GD_ImageColor_Text=58
#GD_ImageColor_KeyWord=59
#GD_ImageColor_Function=60
#GD_ImageColor_Constant=61
#GD_ImageColor_String=62
#GD_ImageColor_Operator=63
#GD_ImageColor_Comment=64
#GD_FramePath=65
#GD_X86Path_Text=66
#GD_X64Path_Text=67
#GD_X86Path=68
#GD_X64Path=69
#GD_X86Path_Select=70
#GD_X64Path_Select=71
#GD_ConfirmSetCompilerOption=72
#GD_CancelSetCompilerOption=73
#GD_EnableASM=74
#GD_EnableUnicode=75
#GD_EnableSafeThread=76
#GD_EnableOnError=77
#GD_EnableXPSkin=78
#GD_EnableAdministratorMode=79
#GD_EnableUserMode=80
#GD_EnablePrecompiler=81
#OptionLang=1
#OptionColor=2
#OptionCompiler=3
#ImageColor_Text=0
#ImageColor_KeyWord=1
#ImageColor_Function=2
#ImageColor_Constant=3
#ImageColor_String=4
#ImageColor_Operator=5
#ImageColor_Comment=6
#ImageIcon_File=7
#ImageIcon_Comment=8
#ImageIcon_Class=9
#ImageIcon_Procedure=10
#ImageIcon_Project=11
#ImageIcon_AddFile=12
#ImageIcon_Option=13
#ImageIcon_API=14
#ImageIcon_Kill=15
#ImageIcon_CloseProject=16
#ImageIcon_Structure=17
#ImageIcon_Build=18
#ImageIcon_Directory=19
#ImageIcon_FileTree=20
#LexerState_Function=0
#LexerState_Space=1
#LexerState_Comment=2
#LexerState_NonKeyword=3
#LexerState_Keyword=4
#LexerState_FoldKeyword=5
#LexerState_Constant=6
#LexerState_String=7
#LexerState_FoldKeywordUp=8
#LexerState_FoldKeywordDown=9
#LexerState_Operator=10
#SCI_Folding_KEY_UP="procedure macro class"
#SCI_Folding_KEY_Down="endprocedure endmacro endclass"
#SCI_Indent_KEY_UP_="procedure procedurec procedurecdll proceduredll"
#SCI_Indent_KEY_UP="if while repeat procedure procedurec procedurecdll proceduredll for class compilerif structure enumeration macro  foreach compilercondition"
#SCI_Indent_KEY_UP2="select "
#SCI_Indent_KEY_Down="endif endprocedure next wend forever until endclass compilerendif endstructure endenumeration endmacro compilerendcondition"
#SCI_Indent_KEY_Down2="endselect"
#SCI_Indent_KEY_Transition="else case elseif compilerelse default"
#None=1
#Procedure=2
#StaticProcedure=3
#Class=4
#EndClass=5
#Structure=6
#EndStructure=7
#FileInclude=8
#Constant=9
#Global=10
#Define=11
#EndProcedure=12
#Enumeration=13
#EndEnumeration=14
#ImportInclude=15
#Macro=16
#EndMacro=17
#CompilerCondition=18
#CompilerEndCondition=19
#Protected=20
#Mode_Procedure=1
#Mode_ProcedureC=2
#Mode_ProcedureDLL=3
#Mode_ProcedureCDLL=4
#Procedure_ModeList="procedure procedurec proceduredll procedurecdll"
#None=1
#Procedure=2
#StaticProcedure=3
#Class=4
#EndClass=5
#Structure=6
#EndStructure=7
#FileInclude=8
#Constant=9
#Global=10
#Define=11
#EndProcedure=12
#Enumeration=13
#EndEnumeration=14
#ImportInclude=15
#Macro=16
#EndMacro=17
#CompilerCondition=18
#CompilerEndCondition=19
#Protected=20
#File=0
#Project=1
