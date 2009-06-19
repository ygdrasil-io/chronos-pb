;============================================================;
;Chronos                                                     																		;
;-Header                                                     																		;
;============================================================;
UsePNGImageDecoder()
#Chronos_version = 0
#MainName = "Chronos"
Global Version.s, Title.s
Version=Str(#Chronos_version)+"."+Str(Year(#PB_Compiler_Date)-2000)+"."+Str(Month(#PB_Compiler_Date))+"."+Str(Day(#PB_Compiler_Date))
Title = #MainName + " " + Version + " BETA 3"
#ChronosSourceFiltre = "Chronos Source File (*.pb, *.pbi)|*.pb;*.pbi"
#ChronosFiltre = "Chronos Suported File (*.pb, *.pbi, *.chp)|*.chp;*.pb;*.pbi"

CompilerCondition #PB_Compiler_OS = #PB_OS_Windows
	#Chronos_exe = #MainName+".exe"
	#PrefixeFile = "windows"
	#PB_CompilerName = "pbcompiler.exe"
	#Extension = ".exe"
	#PB_Debugger = "PBDebugger.exe"
CompilerEndCondition

CompilerCondition #PB_Compiler_OS = #PB_OS_Linux
	#Chronos_exe = #MainName
	#PrefixeFile = "linux"
	#PB_CompilerName = "pbcompiler"
	#Extension = ".out"
	#PB_Debugger = "pbdebugger"
CompilerEndCondition

CompilerCondition #PB_Compiler_OS = #PB_OS_MacOS
	#Chronos_exe = #MainName
	#PrefixeFile = "macos"
	#PB_CompilerName = "pbcompiler"
	#Extension = ".out"
	#PB_Debugger = "pbdebugger"
CompilerEndCondition

;============================================================;
;lib commune                                                 																	;
;============================================================;
XIncludeImport "DS.Lib.Array"
XIncludeImport "DS.Lib.Scintilla"
XIncludeImport "DS.Lib.Preferences"
XIncludeImport "DS.Lib.Node"
XIncludeImport "DS.Lib.Amphore.Amphore"
IncludeFile "Includes/String.pb"

;============================================================;
;application                                                	 																	;
;============================================================;
IncludeFile "Class/newPreferences.class.pb"
IncludeFile "Class/language.class.pb"
IncludeFile "Includes/Scintilla.pb"
IncludeFile "Class/IHM.Class.pb"
IncludeFile "Class/directory.Class.pb"
IncludeFile "Class/Fichier.Class.pb"
IncludeFile "Class/Template.Class.pb"
IncludeFile "Class/Projet.Class.pb"

;============================================================;
;compiler definition                                         																	;
;============================================================;
IncludeFile "Class/Compiler/Compiler.Class.pb"
IncludeFile "Class/Compiler/Structure.Class.pb"
IncludeFile "Class/Compiler/Function.Class.pb"

;============================================================;
;precompiler                                                																		;
;============================================================;
IncludeFile "Class/Precompiler/Line.Class.pb"
IncludeFile "Class/Precompiler/Precompiler.Class.pb"

;============================================================;
;IDE definition                                           																		;
;============================================================;
IncludeFile "Class/Definition/Definition.Class.pb"
IncludeFile "Class/Definition/Comment.Class.pb"
;IncludeFile "class/Definition/Atribut.class.pb"
IncludeFile "Class/Definition/Structure.Class.pb"
IncludeFile "Class/Definition/Function.Class.pb"

;============================================================;
;Systeme                                                	 																	;
;============================================================;
IncludeFile "Class/system.Class.pb"


Define Path.s, Filtre.s, TempFile.s, *Ptr
Define *panel.Panel
Define *Project.Project
Define *Directory.Directory
Define Parameter.s
Define.l CurrentPos, n, LineStart, LineEnd, Indent
Define.l Event
Define.b Precompilation
Define.b Run
Define.s File
Define.s Destination
Define.Scintilla *SCI
Define WorkingDirectory.s
Define Number
Define *Node.Node
Define *File.File
Define Text.s
Define *Comment.Comment::Item


*System = New System()
Repeat
	Event = WindowEvent()
	While Event
		*Project  = *System.GetCurrentProject()
		Select Event
			Case #PB_Event_Gadget
				;{
				Select EventType()
					Case #PB_EventType_DragStart
						Select EventGadget()
							Case GetGadget(*System, #GD_Explorer)
								DragFiles(GetGadgetText(GetGadget(*System, #GD_Explorer)))
						EndSelect
					Default
						IHM_EventGadget(*System, EventGadget(), *System)
				EndSelect
				;}
			Case #PB_Event_Menu
				;{
				Event = EventMenu()
				Select Event
					Case #TemplateMaker
						ShowWindow(*System, #WIN_TemplateMaker)
					Case #GenerateDoc
						
					Case #RemoveFile, #RemoveDirectory
						;{
						Number = GetGadgetState(*System\Gadget[#GD_TreeProject])
						If Number > 0
							*Node = *Project\Files.GetNode(Number)
							If *Node
								If  (*Node\Type = #Node_File And Event = #RemoveFile)  Or  (*Node\Type = #Node_Directory And Event = #RemoveDirectory)
									*Project.RemoveFile(Number)
									RefreshTreeProject(*System)
								EndIf
							EndIf
						EndIf
						;}
					Case #AddFileFromFile
						;{
						Path = OpenFileRequester("Select a file", "", #ChronosSourceFiltre, 1)
						If Path
							Number = GetGadgetState(*System\Gadget[#GD_TreeProject])
							If Number > 0
								*Node = *Project\Files.GetNode(Number)
								If *Node
									If  *Node\Type = #Node_Directory
										*Directory = *Node
										If CopyFile(Path, *Directory\Name + GetFilePart(Path))
											*Node.AddChild(File_LoadFile(Path))
											RefreshTreeProject(*System)
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						;}
					Case #AddEmptyFile
						;{
						Path = InputRequester("Add a file", "Write the file name", "")
						If Path
							Number = GetGadgetState(*System\Gadget[#GD_TreeProject])
							If Number > 0
								*Node = *Project\Files.GetNode(Number)
								If *Node
									If  *Node\Type = #Node_Directory
										*Directory = *Node
										Path = *Directory\Name +  Path
										If Not GetExtensionPart(Path) = "pb" Or Not GetExtensionPart(Path) = "pbi"
											Path + ".pb"
										EndIf
										If CreateFile(0, Path)
											CloseFile(0)
											*Node.AddChild(File_LoadFile(Path))
											RefreshTreeProject(*System)
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
						;}
					Case #BuildCurrentFile
						;{
						CompilerIf #PB_Compiler_OS = #PB_OS_Windows
							Filtre = "Executable|*.exe"
						CompilerEndIf
						Path = SaveFileRequester(GetText("GeneralMenu-BuildFile"), "", Filtre, 0)
						If Path
							*System.BuildCurrentFile(Path)
						EndIf
						;}
					Case #CompilerOptions
						;{
						ShowWindow(*System, #WIN_OptionCompilation)
						;}
					Case #SwitchStructure
						;{
						Select *system\Prefs.GetPreference("GENERAL", "structure")
							Case "X86"
								If FileSize(*system\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) > 0
									*system\Prefs.SetPreference("GENERAL", "structure", "X64")
								EndIf
							Case "X64"
								If FileSize(*system\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) > 0
									*system\Prefs.SetPreference("GENERAL", "structure", "X86")
								EndIf
						EndSelect
						*system\Prefs.SavePreference()
						*SCI = *System.GetCurrentScintillaGadget()
						CurrentPos = *SCI .GetPosition()
						SetStatusBarText(*System, 0, "Ligne: " + Str(*SCI.LineFromPosition(CurrentPos)) +  " Colone: " + Str(CurrentPos) + " Mode: " + *system\Prefs.GetPreference("GENERAL", "structure"))
						;}					
					Case #Option
						ShowWindow(*System, #WIN_Option)
					Case #AutoIndent
						AutoIdent(*System.GetCurrentScintillaGadget())
					Case #NewProject
						ShowWindow(*System, #WIN_NewProject)
					Case #new
						*System.AddPanel()
					Case #open
						LoadFile(*System)
					Case #save
						*System.SaveCurrentPanel()
					Case #quit
						*System.SystemEnd()
					Case #undo
						*SCI = *System.GetCurrentScintillaGadget()
						If *SCI.CanUndo()
							*SCI.Undo()
						EndIf
					Case #redo
						*SCI = *System.GetCurrentScintillaGadget()
						If *SCI.CanRedo()
							*SCI.Redo()
						EndIf
					Case #cut
					Case #copy
					Case #paste
					Case #SlctAll
					Case #search
						;{
						ShowWindow(*System, #WIN_Search)
						;}
					Case #BuildSourceCurrentFile
						Path = SaveFileRequester("Save source to ?", "", #ChronosSourceFiltre, 1)
						If Path
							*panel = GetCurrentPanel(*System)
							If Not *Panel\File\Path
								File = TempDir + "temp.pb"
								*Panel.SaveFileTo(File)
							Else
								File = *Panel\File\Path
								*System.SaveCurrentPanel()
							EndIf
							If *System.PrecompileFile(File,  Path)
								*System.AddPanel(Path)
							EndIf
						EndIf
					Case #compiler, #CompilerProject
						;{
						Run = #True
						Precompilation = #False
						If Event = #compiler
							*panel = GetCurrentPanel(*System)
							If Not *Panel\File\Path
								File = TempDir + "temp.pb"
								*Panel.SaveFileTo(File)
							Else
								File = *Panel\File\Path
								*System.SaveCurrentPanel()
							EndIf
							Precompilation = *System.precompilerIsEnable()
							Parameter = *System.MakeCompilerParamList()
							Destination = TempDir+"main.pb"
							WorkingDirectory = GetPathPart(File)
						Else
							If *Project
								*System.SaveProjectFiles()
								File = *Project.GetSourcesPath() + "main.pb"
								Destination = *Project.GetGeneratedSourcesPath() + "main.pb"
								Parameter = *Project.GetCompilerParamList()	
								Precompilation = *Project.PrecompilerIsEnable()
								WorkingDirectory = *Project.GetMediasPath()
							Else
								Run = #False
							EndIf
						EndIf
						If Precompilation
							Run = *System.PrecompileFile(File,  Destination)
							File = Destination
						EndIf
						If Run
							*System.RunProgram(File, Parameter, Precompilation, WorkingDirectory)
						EndIf
						;}
					Case #close
						;{
						*System.RemoveCurrentPanel()
						;}
					Case #closeAll
					Case #DebugerOn
						*System.SwitchDebuggerUse()
					case #UnCommentText
						*SCI = *System.GetCurrentScintillaGadget()
						If Not *SCI.GetSelectionStart() = *SCI.GetSelectionEnd()
							LineStart = *SCI.LineFromPosition(*SCI.GetSelectionStart())
							LineEnd = *SCI.LineFromPosition(*SCI.GetSelectionEnd())
							For n = LineStart To LineEnd
								Indent = *SCI.GetLineIdentation(n)
								*SCI.SetLineIdentation(n, 0)
								If *SCI.GetCharAt(*SCI.PositionFromLine(n)) = ';'
									*SCI.RemoveCharAt(*SCI.PositionFromLine(n))
								EndIf
								*SCI.SetLineIdentation(n, *SCI.GetLineIdentation(n) + Indent)
							Next n
						Endif
					case #CommentText
						*SCI = *System.GetCurrentScintillaGadget()
						If Not *SCI.GetSelectionStart() = *SCI.GetSelectionEnd()
							LineStart = *SCI.LineFromPosition(*SCI.GetSelectionStart())
							LineEnd = *SCI.LineFromPosition(*SCI.GetSelectionEnd())
							For n = LineStart To LineEnd
								*SCI.InsertText(*SCI.PositionFromLine(n), ";")
							Next n
						Endif
					Case #TabOnly
						*SCI = *System.GetCurrentScintillaGadget()
						If *SCI.GetSelectionStart() = *SCI.GetSelectionEnd()
							*SCI.AddText(Chr(9))
						Else
							LineStart = *SCI.LineFromPosition(*SCI.GetSelectionStart())
							LineEnd = *SCI.LineFromPosition(*SCI.GetSelectionEnd())
							For n = LineStart To LineEnd
								*SCI.SetLineIdentation(n, *SCI.GetLineIdentation(n) + *SCI.GetTabWidth())
							Next n
						Endif
				EndSelect
				;}
			Case #PB_Event_SysTray
			Case #PB_Event_CloseWindow
				;{
				Select EventWindow()
					Case GetWindow(*System, #WIN_OptionCompilation)
						IHM_HideWindow(*System, #WIN_OptionCompilation)
					Case GetWindow(*System, #WIN_Main)
						*System.SystemEnd()
					Case GetWindow(*System, #WIN_NewProject)
						IHM_HideWindow(*System, #WIN_NewProject)
						DisableWindow(*System\Window[#WIN_Main] , 0)
					Case GetWindow(*System, #WIN_Search)
						IHM_HideWindow(*System, #WIN_Search)
					Case GetWindow(*System,#WIN_TemplateMaker)
						IHM_HideWindow(*System, #WIN_TemplateMaker)
				EndSelect
				;}
			Case #PB_Event_Repaint
			Case #PB_Event_MoveWindow
			Case #PB_Event_MinimizeWindow
				ResizeWindows(*System, 0)
			Case #PB_Event_MaximizeWindow
				ResizeWindows(*System, 0)
			Case #PB_Event_RestoreWindow
			Case #PB_Event_SizeWindow
				ResizeWindows(*System, 0)
			Case #PB_Event_ActivateWindow
			Case #PB_Event_WindowDrop	
			Case #PB_Event_GadgetDrop
				;{
				*System.AddPanel(EventDropFiles())
				;}
		EndSelect
		Event = WindowEvent()
	Wend
	Delay(1)
ForEver

