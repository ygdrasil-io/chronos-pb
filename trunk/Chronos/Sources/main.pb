;============================================================;
;Chronos                                                     																		;
;-Header                                                     																		;
;============================================================;
UsePNGImageDecoder()
#Debug = #True
;============================================================;
;lib commune                                                 																	;
;============================================================;
XIncludeImport "DS.Lib.Array"
XIncludeImport "DS.Lib.Scintilla"
XIncludeImport "DS.Lib.Preferences"
XIncludeImport "DS.Lib.Node"

IncludeFile "Class/String.Class.pb"

;============================================================;
;declaration                                                 																		;
;============================================================;
IncludeFile "Includes/declare.pbi.pb"

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
;inside definition                                           																		;
;============================================================;
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
Define CurrentPos.l
Define.l Event
Define.b Precompilation
Define.b Run
Define.s File
Define.s Destination
*System = New System()
Repeat
	Event = WindowEvent()
	While Event
		*Project  = GetCurrentProject(*System)
		Select Event
			Case #PB_Event_Gadget
				;{
				Select EventType()
					Case #PB_EventType_DragStart
						Select EventGadget()
							Case GetGadget(*System\IHM, #GD_Explorer)
								DragFiles(GetGadgetText(GetGadget(*System\IHM, #GD_Explorer)))
						EndSelect
					Default
						IHM_EventGadget(*System\IHM, EventGadget(), *System)
				EndSelect
				;}
			Case #PB_Event_Menu
				;{
				Event = EventMenu()
				Select Event
					Case #RemoveFile, #RemoveDirectory
						;{
						If Not GetGadgetState(*System\IHM\Gadget[#GD_TreeProject])
							MessageRequester("Error", "You can't delete this directory")
						Else
							Project_RemoveFile(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject]))
							IHM_SetCurrentProjectTree(*System\IHM,  #GD_ProjectFile)
						EndIf
						;}
					Case #AddFileFromFile
						;{
						*Directory = Project_GetFile(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject]))
						Path = OpenFileRequester("Select a file", "", ChronosSourceFiltre, 1)
						If Path
							If CopyFile(Path, Project_GetFilePath(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject])) + GetFilePart(Path))
								Path = Project_GetFilePath(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject])) + GetFilePart(Path)
								Directory_AddFile(*Directory, File_LoadFile(Path))
								IHM_SetCurrentProjectTree(*System\IHM,  #GD_ProjectFile)
							Else
								MessageRequester("Error", "File creation failed")
							EndIf
						EndIf
						;}
					Case #AddEmptyFile
						;{
						*Directory = Project_GetFile(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject]))
						Path = InputRequester("Add a file", "Write the file name", "")
						If Path
							Path = Project_GetFilePath(*Project, GetGadgetState(*System\IHM\Gadget[#GD_TreeProject])) +  Path
							If GetExtensionPart(Path) <> "pb" Or GetExtensionPart(Path) <> "pbi"
								Path + ".pb"
							EndIf
							If CreateFile(0, Path)
								CloseFile(0)
								Directory_AddFile(*Directory, File_LoadFile(Path))
								IHM_SetCurrentProjectTree(*System\IHM,  #GD_ProjectFile)
							Else
								MessageRequester("Error", "File creation failed")
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
						ShowWindow(*System\IHM, #WIN_OptionCompilation)
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
						CurrentPos = SCI_GetPosition(GetCurrentScintillaGadget(*System))
						SetStatusBarText(*System\IHM, 0, "Ligne: " + Str(SCI_LineFromPosition(GetCurrentScintillaGadget(*System), CurrentPos)) +  " Colone: " + Str(CurrentPos) + " Mode: " + *system\Prefs.GetPreference("GENERAL", "structure"))
						;}					
					Case #Option
						ShowWindow(*System\IHM, #WIN_Option)
					Case #AutoIndent
						AutoIdent(GetCurrentScintillaGadget(*System))
					Case #NewProject
						ShowWindow(*System\IHM, #WIN_NewProject)
					Case #new
						*System.AddPanel()
					Case #open
						LoadFile(*System\IHM)
					Case #save
						SaveCurrentPanel(*System)
					Case #quit
						SystemEnd(*System)
					Case #undo
						*Ptr = GetCurrentScintillaGadget(*System)
						If SCI_CanUndo(*Ptr)
							SCI_Undo(*Ptr)
						EndIf
					Case #redo
						*Ptr = GetCurrentScintillaGadget(*System)
						If SCI_CanRedo(*Ptr)
							SCI_Redo(*Ptr)
						EndIf
					Case #cut
					Case #copy
					Case #paste
					Case #SlctAll
					Case #search
						;{
						ShowWindow(*System\IHM, #WIN_Search)
						;}
					Case #compiler, #CompilerProject
						;{
						Run = #True
						Precompilation = #False
						If Event = #compiler
							*panel = GetCurrentPanel(*System)
							If Not *Panel\File\Path
								File = TempDir + "temp.pb"
							Else
								File = *Panel\File\Path
							EndIf
							Precompilation = *System.precompilerIsEnable()
							Parameter = MakeCompilerParamList(*System)
							Destination = TempDir+"main.pb"
						Else
							File = GetSourcesPath(*Project) + "main.pb"
							Destination = GetGeneratedSourcesPath(*Project) + "main.pb"
							Parameter = GetCompilerParamList(*Project)	
							Precompilation = *Project.PrecompilerIsEnable()
						EndIf
						If Precompilation
							Run = *System.PrecompileFile(File,  Destination)
							File = Destination
						EndIf
						Parameter + " " + #CompilerFlagDebugger
						If Run
							*System.RunProgram(File, Parameter, Precompilation)
							EndIf					
							;}
						Case #close
							;{
							*System.RemoveCurrentPanel()
							;}
						Case #closeAll
						Case #TabOnly
							SCI_AddText(GetCurrentScintillaGadget(*System), Chr(9))
					EndSelect
					;}
				Case #PB_Event_SysTray
				Case #PB_Event_CloseWindow
					;{
					Select EventWindow()
						Case GetWindow(*System\IHM, #WIN_OptionCompilation)
							IHM_HideWindow(*System\IHM, #WIN_OptionCompilation)
						Case GetWindow(*System\IHM, #WIN_Main)
							SystemEnd(*System)
						Case GetWindow(*System\IHM, #WIN_NewProject)
							IHM_HideWindow(*System\IHM, #WIN_NewProject)
							DisableWindow(*System\IHM\Window[#WIN_Main] , 0)
						Case GetWindow(*System\IHM, #WIN_Search)
							IHM_HideWindow(*System\IHM, #WIN_Search)
					EndSelect
					;}
				Case #PB_Event_Repaint
				Case #PB_Event_MoveWindow
				Case #PB_Event_MinimizeWindow
					ResizeWindows(*System\IHM, 0)
				Case #PB_Event_MaximizeWindow
					ResizeWindows(*System\IHM, 0)
				Case #PB_Event_RestoreWindow
				Case #PB_Event_SizeWindow
					ResizeWindows(*System\IHM, 0)
				Case #PB_Event_ActivateWindow
				Case #PB_Event_WindowDrop	
				Case #PB_Event_GadgetDrop
					;{
					Select EventGadget()
						Case GetGadget(*System\IHM, #GD_MainPanel)
							*System.AddPanel(EventDropFiles())
					EndSelect
					;}
			EndSelect
			Event = WindowEvent()
		Wend
		Delay(1)
	ForEver
		
