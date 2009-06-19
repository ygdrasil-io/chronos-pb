Enumeration 1
	#None
	#Procedure
	#StaticProcedure
	#Class
	#EndClass
	#Structure
	#EndStructure
	#FileInclude
	#Constant
	#Global
	#Define
	#EndProcedure
	#Enumeration
	#EndEnumeration
	#ImportInclude
	#Macro
	#EndMacro
	#CompilerCondition
	#CompilerEndCondition
	#Protected
EndEnumeration

Enumeration
	#File
	#Project
EndEnumeration

Global *System.System
Global MainPath.s
Global TempDir.s = GetTemporaryDirectory()

Class System Extends IHM
	*Panel.Array = New Array()
	*File.Array = New Array()
	CurrentPanel.w
	*Prefs.Preference
	*Plugin.Array = New Array()
	*Constante.Array = New Array()
	*Struct.Array = New Array()
	*Function.Array = New Array()
	*Template.Array = New Array()
	*Compiler.Compiler[2]
	*OpenProject.Project
	*NewPrefs.Array = New Array()
	*Precompiler.Precompiler = New Precompiler()
	Debuger.b = #True
	
	Procedure System()
		Protected n
		*System = *this
		*this\Prefs = New Preference(#MainName)
		If Not *this\Prefs.IsGroup("GENERAL")
			*this\Prefs.SetPreference("GENERAL", "Lang", "English")
			*this\Prefs.SetPreference("GENERAL", "MainPath", GetPathPart(ProgramFilename()))
			*this\Prefs.SetPreference("GENERAL", "Structure", "X86")
			*this\Prefs.SetPreference("Color", "KeyWord", Str(RGB(0, 102, 102)))
			*this\Prefs.SetPreference("Color", "Text", Str(0))
			*this\Prefs.SetPreference("Color", "Function", Str(RGB(0, 102, 102)))
			*this\Prefs.SetPreference("Color", "Constant", Str(RGB(169, 64, 147)))
			*this\Prefs.SetPreference("Color", "String", Str(RGB(255, 139, 37)))
			*this\Prefs.SetPreference("Color", "Operator", Str($733CC2))
			*this\Prefs.SetPreference("Color", "Comment", Str($bb00))
			*this\Prefs.SetPreference("X64", "Compiler Path", "")
			*this\Prefs.SetPreference("X64", "Compiler Path", "")
			
			*this\Prefs.SetPreference("Compiler Options", "ASM", "0")
			*this\Prefs.SetPreference("Compiler Options", "Unicode", "0")
			*this\Prefs.SetPreference("Compiler Options", "SafeThread", "0")
			*this\Prefs.SetPreference("Compiler Options", "OnError", "0")
			*this\Prefs.SetPreference("Compiler Options", "XPSkin", "0")
			*this\Prefs.SetPreference("Compiler Options", "AdministratorMode", "0")
			*this\Prefs.SetPreference("Compiler Options", "UserMode", "0")
			*this\Prefs.SetPreference("Compiler Options", "Precompiler", "0")
			*this\Prefs.SavePreference()
		Else
			If *this\Prefs.GetPreference("GENERAL", "structure") = ""
				If *this\Prefs.GetPreference("X64", "Compiler Path")
					*this\Prefs.SetPreference("GENERAL", "structure", "X64")
				Else
					*this\Prefs.SetPreference("GENERAL", "structure", "X86")
				EndIf
			EndIf
			;*this\Prefs.SetPreference("GENERAL", "MainPath", GetPathPart(ProgramFilename()))
			*this\Prefs.SavePreference()
		EndIf
		
		
		If *this\Prefs.GetPreference("X86", "Compiler Path")
			*this\Compiler[#X86] = New Compiler(#X86)
			If Not *this\Compiler[#X86]
				Debug "erreur"
			EndIf
		EndIf
		If *this\Prefs.GetPreference("X64", "Compiler Path")
			*this\Compiler[#X64] = New Compiler(#X64)
			If Not *this\Compiler[#X64]
				Debug "erreur"
			EndIf
		EndIf
		MainPath = *this\Prefs.GetPreference("GENERAL", "MainPath")
		LoadLanguage()
		
		If Not *this.LoadIHM()
			*this.SystemEnd()
		EndIf
		If *this\Prefs.GetPreference("GENERAL", "OpenedFile")
			For n = 1 To CountString(*this\Prefs.GetPreference("GENERAL", "OpenedFile"), ";") + 1
				*this.AddPanel(StringField(*this\Prefs.GetPreference("GENERAL", "OpenedFile"), n, ";"))
			Next n
		Else
			*this.AddPanel()
		EndIf
		If *this\Prefs.GetPreference("GENERAL", "OpenedProject")
			*this.OpenProject(*this\Prefs.GetPreference("GENERAL", "OpenedProject"))
		EndIf
		If Not *this.LoadTemplates()
			MessageRequester("error", "template loading error")
		EndIf
		ResizeWindows(*this, #WIN_Main)
		ShowWindow(*this, #WIN_Main)
		*this.WriteMessage("Chronos started")
	EndProcedure
	
	Procedure SwitchDebuggerUse()
		If *System\Debuger
			*System\Debuger = #False
		Else
			*System\Debuger = #True
		EndIf
		SetMenuItemState(*System\menu[#Menu_Main], #DebugerOn, *System\Debuger)
	EndProcedure
	
	Procedure.Scintilla GetCurrentScintillaGadget()
		If *this\CurrentPanel
			Protected *Panel.Panel = *this\Panel.GetElement(*this\CurrentPanel)
			If *Panel
				ProcedureReturn *Panel\ScintillaGadget
			Else
				ProcedureReturn #False
			EndIf
		Else
			ProcedureReturn #False
		EndIf
	EndProcedure
	
	Procedure RemoveCurrentPanel()
		ProcedureReturn *this.RemovePanel(*this\CurrentPanel)
	EndProcedure
	
	Procedure.Panel GetCurrentPanel()
		ProcedureReturn *this\Panel.GetElement(*this\CurrentPanel)
	EndProcedure
	
	Procedure AddPanel(File.s = "", *File.File  = #Null)
		Protected *New.Panel
		Protected n
		If file
			File = ReplaceString(File, "\", "/")
			If FileSize(File) < 0
				ProcedureReturn
			EndIf
			n = IsOpenFile(*this, File)
			If n ;si on a trouvé une occurence
				If Not *this\CurrentPanel = n
					IHM_SetCurrentPanel(*this, n - 1)
					SetCurrentPanel(*this, n)
				EndIf
				ProcedureReturn
			EndIf
			If *this\Panel.CountElement() = 1
				*New = *this.GetCurrentPanel()
				If *New\File\Path = "" And Not *New\ScintillaGadget.GetLength()
					*this.RemoveCurrentPanel()
				EndIf
			EndIf
			*New = New Panel()
			*New\File = File_LoadFile(file)
			*New\ScintillaGadget = NewScintillaGadget(*this, GetFilePart(file))
			*New\ScintillaGadget.InsertText(0, *New\File\Text)
		ElseIf  *File
			n = IsOpenFile(*this, *File\Path)
			If n ;si on a trouvé une occurence
				If Not *this\CurrentPanel = n
					IHM_SetCurrentPanel(*this, n - 1)
					SetCurrentPanel(*this, n)
				EndIf
				ProcedureReturn
			EndIf
			*New = New Panel()
			*New\File = *File
			*New\ScintillaGadget = NewScintillaGadget(*this, GetFilePart(*New\File\Path))
			*New\ScintillaGadget.InsertText(0, *New\File\Text)
		Else
			*New = New Panel()
			*New\File = New File()
			*New\ScintillaGadget = NewScintillaGadget(*this, "<New>")
		EndIf
		*New\ScintillaGadget.ResizeMargins()
		AutoIdent(*New\ScintillaGadget)
		Highlight(*New\ScintillaGadget, *New\ScintillaGadget.GetLineEndPosition(*New\ScintillaGadget.GetLineCount()))
		If *New\File\Path
			If Not FindString(*this\Prefs.GetPreference("GENERAL", "OpenedFile"), *New\File\Path, 1)
				*this\Prefs.SetPreference("GENERAL", "OpenedFile", *this\Prefs.GetPreference("GENERAL", "OpenedFile")+";"+*New\File\Path)
				*this\Prefs.SavePreference()
			EndIf
		EndIf
		*New\ScintillaGadget.EmptyUndoBuffer()
		*System\Panel.AddElement(*New)
		*this\CurrentPanel = *System\Panel.CountElement()
	EndProcedure
	
	Procedure OpenProject(File.s)
		Protected *Project.Project = New Project(File)
		If *Project
			If *Project.load()
				System_CloseProject(*this)
				*this\OpenProject = *Project
				IHM_ShowProjectTree(*this, *this\OpenProject)
				ResizeWindows(*this, #WIN_Main)
				*this\Prefs.SetPreference("GENERAL", "OpenedProject", File)
				*this\Prefs.SavePreference()
			Else
				MessageRequester("error", "project  not loaded")
			EndIf
		Else
			MessageRequester("error", "project  not loaded")
		EndIf
	EndProcedure
	
	Procedure PrecompileFile(File.s, Destination.s)
		*this\Precompiler.restart(*this.GetCurrentCompiler())
		*System.WriteMessage("Start Precompilation")
		If *this\Precompiler.start(File)
			If *this\Precompiler.LoadFileStructure()
				If *this\Precompiler.FormatCode()
					If *this\Precompiler.SaveFile(Destination)
						ProcedureReturn #True
					EndIf
				EndIf
			EndIf
		EndIf
		*System.WriteMessage("Precompilation failed")
		ProcedureReturn #False
	EndProcedure
	
	Procedure RemovePanel(number.w, History.b = #True)
		Protected *Panel.Panel = *System\Panel.GetElement(number), Text.s, Temp.s, n, NewText.s
		If Not *Panel\File\Saved
			Protected result = MessageRequester(GetText("Misc-Warning"), GetText("Misc-FileNotSaved"), #PB_MessageRequester_YesNoCancel)
			Select result
				Case #PB_MessageRequester_Cancel
					ProcedureReturn -1
				Case #PB_MessageRequester_Yes
					
				Case #PB_MessageRequester_No
					
			EndSelect
		EndIf
		If *Panel\File\Path
			If History = #True
				AddToHistory(*this, *Panel\File\Path)
			EndIf
		EndIf
		IHM_RemovePanel(*this, number - 1)
		*this\CurrentPanel - 1
		*this\Panel.FreeElement(number)
		*Panel.Free()
		If *this\CurrentPanel = 0
			If *this\Panel.CountElement() = 0
				*this.AddPanel()
			EndIf
			*this\CurrentPanel = 1
		EndIf
		IHM_SetCurrentPanel(*this, *this\CurrentPanel - 1)
		ProcedureReturn #True
	EndProcedure
	
	Procedure precompilerIsEnable()
		ProcedureReturn Val(*this\Prefs.GetPreference("Compiler Options", "Precompiler"))
	EndProcedure
	
	Procedure.b BuildFile(File.s, Destination.s, Flag.s, Precompiler.b, Architecture.s)
		Protected *panel.Panel = GetCurrentPanel(*this)
		Protected ID.i, Retour.s, Final.s
		Protected *Line.LineCode
		
		Flag = Chr(34) + File + Chr(34) + Flag
		Select  Architecture
			Case "X86"
				ID = Build(*this\Compiler[#X86], Flag, Destination)
			Case "X64"
				ID = Build(*this\Compiler[#X64], Flag, Destination)
		EndSelect
		If ID
			While ProgramRunning(ID)
				Retour = ReadProgramString(ID)
				If Retour
					If Final
						Final + ";"
					EndIf
					Final + Retour
				EndIf
			Wend
		EndIf
		If Final
			If Precompiler
				*Line = *this\Precompiler.getLine(Val(StringField(Final, 3, " ")))
				*this.CodeError(*Line\File, *Line\Line, StringField(Final, CountString(Final, "-") + 1, "-"))
				ProcedureReturn #False
			Else
				If FindString(File, ";", 1)
					*this.CodeError(StringField(Final, 2, "'"), Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
					ProcedureReturn #False
				Else
					*this.CodeError(File, Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
					ProcedureReturn #False
				EndIf
			EndIf
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure BuildProject()
		If *this\OpenProject
			Protected Precompiler.b = *this\OpenProject.PrecompilerIsEnable()
			Protected Flags.s
			Protected File.s
			Protected Run = #True
			*this.SaveProjectFiles()
			File = *this\OpenProject.GetSourcesPath() + "main.pb"
			Flags = *this\OpenProject.GetCompilerParamList()
			If Precompiler
				Run = *System.PrecompileFile(File,  *this\OpenProject.GetGeneratedSourcesPath() + "main.pb")
				File = *this\OpenProject.GetGeneratedSourcesPath() + "main.pb"
			EndIf
			If Run
				If *this\Compiler[#X64]
					Run = *this.BuildFile(File, *this\OpenProject.GetBinariePath("X64"), Flags, Precompiler, "X64")
				EndIf
			EndIf
			If Run
				If *this\Compiler[#X86]
					*this.BuildFile(File, *this\OpenProject.GetBinariePath("X86"), Flags, Precompiler, "X86")
				EndIf
			EndIf
		EndIf
	EndProcedure
	
	Procedure.b BuildCurrentFile(Destination.s)
		Protected *panel.Panel = GetCurrentPanel(*this)
		Protected Run.b = #True, Precompiler.b
		Protected Flag.s, File.s
		Protected *Line.LineCode
		If *this.PrecompilerIsEnable()
			Precompiler = #True
			Run = *System.PrecompileFile(*Panel\File\Path,  TempDir + "main.pb")
			File = TempDir + "main.pb"
		Else
			File = *Panel\File\Path
		EndIf
		If Run
			Flag = *this.MakeCompilerParamList()
			ProcedureReturn *this.BuildFile(File, Destination, Flag, Precompiler, *System\Prefs.GetPreference("GENERAL", "structure"))
		EndIf
		ProcedureReturn #False
	EndProcedure
	
	Procedure CodeError(File.s, Line.l, Error.s)
		*this.WriteMessage("Error:" + Error)
		*this.AddPanel(File)
		Protected *Ptr.Scintilla = *this.GetCurrentScintillaGadget()
		line - 1
		*Ptr.GoToPoS(*Ptr.PositionFromLine(line))
		*Ptr.SetSel(*Ptr.PositionFromLine(line), *Ptr.PositionFromLine(line) + *Ptr.LineLength(line))
		MessageRequester("", Error + " at line " + str(Line + 1))
	EndProcedure
	
	Procedure RunProgram(File.s, Param.s, Precompilation.b, WorkingDirectory.s)
		Protected ID.i, *Ptr, Retour.s, Final.s
		Protected *Line.LineCode
		If *System\Debuger
			Param + " " + #CompilerFlagDebugger
		EndIf
		Select  *this\Prefs.GetPreference("GENERAL", "structure")
			Case "X86"
				If *System\Compiler[#X86]
					ID = Compiler_Build(*System\Compiler[#X86], Chr(34) + File + Chr(34) + Param, WorkingDirectory + "exe"+#Extension)
				EndIf
			Case "X64"
				If *System\Compiler[#X64]
					ID = Compiler_Build(*System\Compiler[#X64], Chr(34) + File + Chr(34) + Param, WorkingDirectory + "exe"+#Extension)
				EndIf
		EndSelect
		If ID
			While ProgramRunning(ID)
				Retour = ReadProgramString(ID)
				If Retour
					If Final
						Final + ";"
					EndIf
					Final + Retour
				EndIf
			Wend
		EndIf
		If Final
			If Not FindString(Final, "-", 1)
				MessageRequester("Error", Final)
				ProcedureReturn
			EndIf
			If Precompilation
				*Line = *this\Precompiler.getLine(Val(StringField(Final, 3, " ")))
				*this.CodeError(*Line\File, *Line\Line, StringField(Final, CountString(Final, "-") + 1, "-"))
			Else
				If FindString(Final, ";", 1)
					*this.CodeError(StringField(Final, 2, "'"), Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
				Else
					*this.CodeError(File, Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
				EndIf
			EndIf
		Else		
			Select  *this\Prefs.GetPreference("GENERAL", "structure")
				Case "X86"
					If *System\Compiler[#X86]
						If *System\Debuger
							CreateThread(@Compiler_ExecuteDebugger(), *System\Compiler[#X86])
						Else
							CreateThread(@Compiler_ExecuteFile(), *System\Compiler[#X86])
						EndIf
					EndIf
				Case "X64"
					If *System\Compiler[#X64]
						If *System\Debuger
							CreateThread(@Compiler_ExecuteDebugger(), *System\Compiler[#X64])
						Else
							CreateThread(@Compiler_ExecuteFile(), *System\Compiler[#X64])
						EndIf
					EndIf
			EndSelect
		EndIf
	EndProcedure
	
	Procedure GetCurrentCompiler()
		Select *this\Prefs.GetPreference("GENERAL", "structure")
			Case "X86"
				ProcedureReturn *System\Compiler[#X86]
			Case "X64"
				ProcedureReturn *System\Compiler[#X64]
		EndSelect
	EndProcedure
	
	Procedure SystemEnd()
		Protected n, File.s, *Panel.Panel, Count.l = *this\Panel.CountElement()
		For n = 1 To Count
			*Panel = *This.GetCurrentPanel()
			If *Panel\File\Path
				If File
					File + ";"
				EndIf
				File + *Panel\File\Path
			Endif
			If *this.RemoveCurrentPanel() = -1
				ProcedureReturn
			EndIf
		Next n
		*this\Prefs.SetPreference("GENERAL", "OpenedFile", File)
		*this\Prefs.SavePreference()
		End
	EndProcedure
	
	Procedure SaveProjectFiles()
		Protected n, *Panel.Panel, Count.l = *this\Panel.CountElement()
		For n = 1 To Count
			*Panel = *This.GetCurrentPanel()
			If *Panel\File
				If *this\OpenProject.IsFile(*Panel\File)
					*this.SavePanel(n)
				Endif
			Endif
		Next n
	EndProcedure
	
	Procedure SaveCurrentPanel()
		*this.SavePanel(*this\CurrentPanel)
	EndProcedure
	
	Procedure SavePanel(n)
		Protected *Panel.Panel = *this\Panel.GetElement(n)
		Select SaveFile(*Panel\File, *Panel\ScintillaGadget)
			Case 1
				IHM_PanelSaved(*this, n - 1, *Panel\File\File)
			Default
		EndSelect
		If *this\OpenProject
			If Project_IsFile(*this\OpenProject, *Panel\file)
				LoadStructure(*Panel\file)
			EndIf
		EndIf
	EndProcedure
	
	Procedure GetCurrentProject()
		ProcedureReturn *this\OpenProject
	EndProcedure
	
	Procedure CloseProject()
		If *this\OpenProject
			IHM_CloseProject(*this)
			FreeProject(*this\OpenProject)
			*this\OpenProject = #Null
			*this\Prefs.SetPreference("GENERAL", "OpenedProject", "")
			*this\Prefs.SavePreference()
		EndIf
	EndProcedure
	
	Procedure.s MakeCompilerParamList()
		Protected Param.s
		If Not *this\Prefs.GetPreference("Compiler Options", "SubSystem") = ""
			Param + " " + #CompilerSubSystem + " " + *this\Prefs.GetPreference("Compiler Options", "SubSystem")
		EndIf
		If *this\Prefs.GetPreference("Compiler Options", "ASM") = "1"
			Param + " " + #CompilerFlagASM
		EndIf
		If *this\Prefs.GetPreference("Compiler Options", "Unicode") = "1"
			Param + " " + #CompilerFlagUnicode
		EndIf
		If *this\Prefs.GetPreference("Compiler Options", "SafeThread") = "1"
			Param + " " + #CompilerFlagSafeThread
		EndIf
		If *this\Prefs.GetPreference("Compiler Options", "OnError") = "1"
			Param + " " + #CompilerFlagOnError
		EndIf
		CompilerIf #PB_Compiler_OS = #PB_OS_Windows
			If *this\Prefs.GetPreference("Compiler Options", "XPSkin") = "1"
				Param + " " + "/XP"
			EndIf
			If *this\Prefs.GetPreference("Compiler Options", "AdministratorMode") = "1"
				Param + " " + "/ADMINISTRATOR"
			EndIf
			If *this\Prefs.GetPreference("Compiler Options", "UserMode") = "1"
				Param + " " + "/USER"
			EndIf
		CompilerEndIf
		
		ProcedureReturn Param
	EndProcedure
	
	Procedure.s GetTemplatePath()
		ProcedureReturn *this\Prefs.GetPreference("GENERAL", "MainPath") + "Templates/"
	EndProcedure
	
	Procedure.s GetImagePath()
		ProcedureReturn *this\Prefs.GetPreference("GENERAL", "MainPath") + "images/"
	EndProcedure
	
	Procedure LoadTemplates()
		Protected DirID = ExamineDirectory(#PB_Any, *this\Prefs.GetPreference("GENERAL", "MainPath") + "Templates/" , "*.cht")
		If Not IsDirectory(DirID)
			ProcedureReturn #False
		EndIf
		Protected *Template.Template
		While NextDirectoryEntry(DirID)
			*Template = New Template()
			If Not *Template
				ProcedureReturn #False
			EndIf
			If Not *Template.load(*this.getTemplatePath()  + DirectoryEntryName(DirID))
				ProcedureReturn #False
			EndIf
			*System\Template.addElement(*Template)
		Wend
		FinishDirectory(DirID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure CreateProject(number.i, Path.s, Name.s)
		Protected *Template.Template = *this\Template.GetElement(number)
		*Template.GenerateProject(Path, Name)
	EndProcedure
EndClass




Procedure GetCurrentCompiler(*this.System)
	Select *this\Prefs.GetPreference("GENERAL", "structure")
		Case "X86"
			ProcedureReturn *this\Compiler[#X86]
		Case "X64"
			ProcedureReturn *this\Compiler[#X64]
	EndSelect
EndProcedure

Procedure.s GetFunctionProtoFromName(*this.System, txt.s)
	Protected Proto.s
	Select *this\Prefs.GetPreference("GENERAL", "structure")
		Case "X86"
			If *System\Compiler[#X86]
				Proto = Compiler_GetFunctionProtoFromName(*System\Compiler[#X86], txt)
				If Proto
					ProcedureReturn Proto
				EndIf
			EndIf
		Case "X64"
			If *System\Compiler[#X64]
				Proto = Compiler_GetFunctionProtoFromName(*System\Compiler[#X86], txt)
				If Proto
					ProcedureReturn Proto
				EndIf
			EndIf
	EndSelect
	ProcedureReturn ""
EndProcedure

Procedure IsOpenFile(*this.System, File.s)
	Protected n, *Panel.Panel
	For n=1 To *System\Panel.CountElement()
		*Panel = *System\Panel.GetElement(n)
		If *Panel\File\Path = File
			ProcedureReturn n
		EndIf
	Next n
	ProcedureReturn 0
EndProcedure

Procedure AddToHistory(*this.System, File.s)
	;	If File
	;		If *this\Prefs.GetPreference(*this\Prefs, "GENERAL", "History") = ""
	;			*this\Prefs.SetPreference(*this\Prefs, "GENERAL", "History", File)
	;		Else
	;			If CountString(*this\Prefs.GetPreference(*this\Prefs, "GENERAL", "History"), ";") = 8
	;				*this\Prefs.SetPreference(*this\Prefs, "GENERAL", "History", Mid(GetPreference(*this\Prefs, "GENERAL", "History"), FindString(GetPreference(*this\Prefs, "GENERAL", "History"), ";", 1) + 1) + ";" + File)
	;			Else
	;				SetPreference(*this\Prefs, "GENERAL", "History", GetPreference(*this\Prefs, "GENERAL", "History") + ";" + File)
	;			EndIf
	;		EndIf
	;		SavePreference(*this\Prefs)
	;	EndIf
EndProcedure



Procedure GetCurrentScintillaGadget(*this.System)
	If *this\CurrentPanel
		Protected *Panel.Panel = *this\Panel.GetElement(*this\CurrentPanel)
		If *Panel
			ProcedureReturn *Panel\ScintillaGadget
		Else
			ProcedureReturn 0
		EndIf
	Else
		ProcedureReturn 0
	EndIf
EndProcedure



Procedure CheckUndoRedo(*this.System)
	Protected *Ptr.Scintilla = GetCurrentScintillaGadget(*System)
	If *Ptr.CanUndo()
		DisableMenuItem(*this\menu[0],#undo,0)
	Else
		DisableMenuItem(*this\menu[0],#undo,1)
	EndIf
	If *Ptr.CanRedo()
		DisableMenuItem(*this\menu[0],#redo,0)
	Else
		DisableMenuItem(*this\menu[0],#redo,1)
	EndIf
EndProcedure

Procedure SetCurrentPanel(*this.System, NewElement.w)
	*this\CurrentPanel = NewElement
	CheckUndoRedo(*this)
EndProcedure

Procedure GetCurrentPanel(*this.System)
	ProcedureReturn *this\Panel.GetElement(*this\CurrentPanel)
EndProcedure

Procedure CurrentFileModified(*this.System, Gadget.i)
	Protected *Panel.Panel = *this\Panel.GetElement(*this\CurrentPanel)
	If Gadget <> *Panel\ScintillaGadget
		ProcedureReturn
	EndIf
	If *Panel\File\Saved = 1
		IHM_PanelModified(*this, *this\CurrentPanel - 1)
		*Panel\File\Saved = 0
	EndIf
EndProcedure



Procedure SavePreferences(*this.System)
	Protected *Prefs.NewPrefs, n
	For n=1 To *this\NewPrefs.CountElement()
		*Prefs = *this\NewPrefs.GetElement(n)
		*this\Prefs.SetPreference(*Prefs\Group, *Prefs\Name, *Prefs\Value)
	Next n
	RemoveNewPreferences(*this)
	*this\Prefs.SavePreference()
	If *this\Prefs.GetPreference("GENERAL", "structure") = "X64" And FileSize(*this\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) > 0
		If FileSize(*this\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) < 0
			DisableMenuItem(*this\menu[0], #SwitchStructure, 1)
		EndIf
	ElseIf FileSize(*this\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) > 0
		If FileSize(*this\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) < 0
			DisableMenuItem(*this\menu[0], #SwitchStructure, 1)
		EndIf
	Else
		DisableMenuItem(*this\menu[0], #Compiler, 1)
		DisableMenuItem(*this\menu[0], #CompilerProject, 1)
	EndIf
EndProcedure

Procedure RemoveNewPreferences(*this.System)
	Protected *Pref.NewPrefs
	While *this\NewPrefs.CountElement()
		*this\NewPrefs.FreeElement(1)
	Wend
EndProcedure

Procedure TryOpenFile(*this.System, File.s)
	Protected *Panel.Panel = *System\Panel.GetElement(*this\CurrentPanel)
	If FileSize(GetPathPart(*Panel\File\Path) + File) >= 0
		*this.AddPanel(GetPathPart(*Panel\File\Path) + File)
	ElseIf FileSize(GetPathPart(File)) >= 0
		*this.AddPanel(File)
	EndIf
EndProcedure

Procedure.s GetFunctionList(*this.System)
	If  *this\OpenProject
		ProcedureReturn Project_GetFunctionList(*this\OpenProject)
	Else
		ProcedureReturn ""
	EndIf
EndProcedure

