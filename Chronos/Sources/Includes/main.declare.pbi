#KeyWordColor = $F90806 
#MacroColor = $578A49
Global KeyWord.s , KeyWordUp.s, KeyWordDown.s, KeyWordNone.s, GlobalKeyWord.s = "", Operator.s

Operator = "= + * / | - &"
KeyWordUp = "Procedure If For While Repeat Reapeat Class Structure Enumeration Method Select CompilerIf CompilerSelect"
KeyWordDown = "EndProcedure EndIf Next Wend Until ForEver EndClass EndStructure EndEnumeration EndMethod EndSelect CompilerEndIf CompilerEndSelect"
KeyWordNone = "Else To IncludeFile EnableExplicit DisableExplicit Case Default End CompilerElse ProcedureReturn Global Define Protected Debug NewList XIncludeFile As New Extends CompilerCase "
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
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
     #Chronos_exe = #MainName+".exe"
     #DefMaker_exe = "DefMaker.exe"
     #PrefixeFile = "windows"
     #PB_CompilerName = "pbcompiler.exe"
     #PrecompilerName = "precompiler.exe"
     #Extension = ".exe"
  CompilerElse
     #Chronos_exe = #MainName
     #DefMaker_exe = "DefMaker"
     #PrefixeFile = "linux"
     #PB_CompilerName = "pbcompiler"
     #PrecompilerName = "Precompiler"
     #Extension = ".out"
  CompilerEndIf
  
Enumeration 1
  #ErrorNoInputFile
  #ErrorNoCompilerFound
  #ParameterNotReconised
  #ErrorCompilation
EndEnumeration
  
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

  Declare.s Template_GetName(*this.Template, Language.s)
;}

;=====================================================
;-Projet
;=====================================================
;{
  ;=====================================================
  ;-Definition
  ;=====================================================
  ;{
    Structure Comment
      value.s
      line.i
      File.s
    EndStructure
    Structure Definition_Constante
      
    EndStructure
    
    Structure Definition_Class
      Name.s
      *Constante.Array
      *Structure.Array
      *Methode.Array
      *Constructor
      *Destructor
    EndStructure
  ;}
  ;=====================================================
  ;-File
  ;=====================================================
  ;{
    Structure File
      Path.s
      File.s
      Text.s
      Saved.b
      *Comment.Array
    EndStructure
    Global NewList *OpenedFile()
    Declare File_LoadFile(Path.s)
    Declare NewFile()
    Declare FreeFile(*this.File)
    Declare AddComment(*this.File,  Comment.s,  Line.i, Path.s)
   ;}

  #ProjectIsDynamicLib = 1
  #ProjectIsApp = 2
  #ProjectIsStaticLib = 3
  
  Structure AdvancedProjectOption
    ThemesXP.b
    AdminRight.b
    NoRightNeeded.b
  EndStructure
  
  Structure ProjectOption
   SafeThread.b
   Unicode.b
   ASM.b
   OnError.b
  EndStructure
  
  #WindowsX86 = 0
  #WindowsX64 = 1
  #LinuxX86 = 2
  #LinuxX64 = 3
  Structure Project
    Path.s
    File.s
    Name.s
    *Files.Array
    Options.ProjectOption[4]
    WindowsAdvanceOption.AdvancedProjectOption[2]
    *Ressources.Array
    Mode.b
  EndStructure
  

  
  Structure Ressource
   Path.s
   include.b
  EndStructure 
  
  Declare.i NewProject(Path.s, Name.s)
  Declare.i SaveProject(*this.Project)
  Declare.i GetFileList(*this.Project) 
  Declare.s GetSourcesPath(*this.Project)
;}

;=====================================================
;-Compiler
;=====================================================
;{
  CompilerIf #PB_Compiler_OS = #PB_OS_Windows 
    #PB_Compiler = "pbcompiler.exe"
    #CompilerFlagVersion = "/VERSION"
    #CompilerFlagStandby = "/UNICODE /STANDBY"
  CompilerElse
    #PB_Compiler = "pbcompiler"
    #CompilerFlagVersion = "-v"
    #CompilerFlagStandby = "-sb"
  CompilerEndIf
  #CompilerFlagGetStructureList = "STRUCTURELIST"
  #CompilerFlagQuit = "END"
  #CompilerFlagEndOutput = "OUTPUT	COMPLETE"
  #CompilerFlagGetFunctionList = "FUNCTIONLIST"
  #x86 = 0
  #x64 = 1
  Structure Compiler
    Numero.w
    *Constante.Array
    *Struct.Array
    *Function.Array
  EndStructure
  
  Structure Struct
    Name.s
    *atribut.Array
  EndStructure
  
  Structure Atribut
    Name.s
    Type.s
    Array.b
  EndStructure
  
  Structure Function
    Name.s
    *ListAtribut.Array
    Atribut.s
    Desc.s   
  EndStructure 
  Global CurrenCompiler = 0
  Global NewList *CompilerList.Compiler()
  

;}

;=====================================================
;-Preferences
;=====================================================
;{
  Global *Lang
;}

;=====================================================
;-Language
;=====================================================
;{
  Structure Language
    Name.s
    Section.Array
  EndStructure
  
  Structure LanguageSection
    Name.s
    Expression.Array
  EndStructure
  
  Structure LanguageExpression
    Expression.S
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
EndEnumeration

#NB_ToolBar = 1
#NB_Win = 10
#NB_Menu = 2
#NB_Gadget = 100
#NB_StatusBar = 1
#NB_Image = 50

Enumeration
  #New
  #NewProject
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
  #SwitchStructure
  #TabOnly
  #Option
  ;Popup
  #Properties
  #AddSource
  #AddRes
  #AddProject
  #Popup_Delete
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
EndEnumeration

Structure IHM
  Window.i[#NB_Win]
  Menu.i[#NB_Menu]
  Gadget.i[#NB_Gadget]
  StatusBar.i[#NB_StatusBar]
  ToolBar.i[#NB_ToolBar]
  Image.i[#NB_Image]
  OptionModified.b
  ProjectTreeMode.i
EndStructure

;=====================================================
;-Panel
;=====================================================
;{
  Structure Panel
    *File.File
    *ScintillaGadget
  EndStructure
;}

Global *IHM.IHM
Declare SetStatusBarText(*this.IHM, Champ, txt.s)
Declare NewScintillaGadget(*this.IHM, PanelName.s)
Declare GetGadget(*IHM.IHM, numero.i)
;}
;=====================================================
;-Scintilla
;=====================================================
;{
Structure CharacterRange
  cpMin.l;
  cpMax.l;
EndStructure
Structure TextToFind
 chrg.CharacterRange
 lpstrText.l
 chrgText.CharacterRange
EndStructure

Declare ScintillaCallBack(Gadget, *scinotify.SCNotification)

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




;=====================================================
;-System
;=====================================================
;{
  Structure System
    *Panel.Array
    *File.Array
    *IHM.IHM
    CurrentPanel.w
    *Prefs
    *Plugin.Array
    *Constante.Array
    *Struct.Array
    *Function.Array
    *Template.Array
    *Compiler.Compiler[2]
    *OpenProject.Project
    *NewPrefs.Array
  EndStructure
  
  Global *System.System
  Declare TryOpenFile(*this.System, File.s)
  Declare SystemEnd(*this.System)
  Declare AddPanel(*this.System, file.s = "")
  Declare RemoveCurrentPanel(*this.System, History.b = #True)
  Declare SetCurrentPanel(*this.System, NewElement.w)
  Declare CurrentFileModified(*this.System, Gadget.i)
  Declare SaveCurrentPanel(*this.System)
  Declare LoadPlugin(*this.System)
  Declare GetCurrentScintillaGadget(*this.System)
  Declare.s GetFunctionProtoFromName(*this.System, txt.s)
  Declare LoadTemplates(*this.System)
  Declare CreateProject(*this.System, number.i, Path.s, Name.s)
  Declare System_OpenProject(*this.System, File.s)
  Declare GetCurrentProject(*this.System)
  Declare SavePreferences(*this.System)
  Declare RemoveNewPreferences(*this.System)
  Declare GetCurrentPanel(*this.System)
  Declare.s GetBinariePath(*this.Project)
  Declare IHM_SetCurrentProjectTree(*this.IHM,  gadget.i)
;}
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 144
; FirstLine = 98
; Folding = ---
; UseMainFile = ..\Chronos.pb