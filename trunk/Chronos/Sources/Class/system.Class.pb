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

Class System
	*Panel.Array = New Array()
	*File.Array = New Array()
	*IHM.IHM
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
			*this\Compiler[#X86] = NewCompiler(#X86)
		EndIf
		If *this\Prefs.GetPreference("X64", "Compiler Path")
			*this\Compiler[#X64] = NewCompiler(#X64)
		EndIf
		MainPath = *this\Prefs.GetPreference("GENERAL", "MainPath")
		LoadLanguage()
		*this\IHM = NewIHM()
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
		LoadTemplates(*this)
		ResizeWindows(*this\IHM, #WIN_Main)
		ShowWindow(*this\IHM, #WIN_Main)
		IHM_WriteMessage(*this\IHM, "Chronos started")
	EndProcedure
	
	Procedure RemoveCurrentPanel(History.b = #True)
		ProcedureReturn *this.RemovePanel(*this\CurrentPanel, History)
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
					IHM_SetCurrentPanel(*this\IHM, n - 1)
					SetCurrentPanel(*this, n)
				EndIf
				ProcedureReturn
			EndIf
			If *this\Panel.CountElement() = 1
				Debug 1
				*New = *this.GetCurrentPanel()
				If *New\File\Path = "" And SCI_GetLength(*New\ScintillaGadget)
					*this.RemoveCurrentPanel()
				EndIf
			EndIf
			*New = New Panel()
			*New\File = File_LoadFile(file)
			*New\ScintillaGadget = NewScintillaGadget(*this\IHM, GetFilePart(file))
			ScintillaSendMessage(*New\ScintillaGadget , #SCI_SETTEXT, 0, @*New\File\Text)
			SCI_ResizeMargins(*New\ScintillaGadget)
			AutoIdent(*New\ScintillaGadget)
			Highlight(*New\ScintillaGadget, SCI_GetLineEndPosition(*New\ScintillaGadget, SCI_GETLINECOUNT(*New\ScintillaGadget)))
			SCI_EmptyUndoBuffer(*New\ScintillaGadget)
		ElseIf  *File
			n = IsOpenFile(*this, *File\Path)
			If n ;si on a trouvé une occurence
				If Not *this\CurrentPanel = n
					IHM_SetCurrentPanel(*this\IHM, n - 1)
					SetCurrentPanel(*this, n)
				EndIf
				ProcedureReturn
			EndIf
			*New = New Panel()
			*New\File = *File
			*New\ScintillaGadget = NewScintillaGadget(*this\IHM, GetFilePart(*New\File\Path))
			ScintillaSendMessage(*New\ScintillaGadget , #SCI_SETTEXT, 0, @*New\File\Text)
			SCI_ResizeMargins(*New\ScintillaGadget)
			AutoIdent(*New\ScintillaGadget)
			Highlight(*New\ScintillaGadget, SCI_GetLineEndPosition(*New\ScintillaGadget, SCI_GETLINECOUNT(*New\ScintillaGadget)))
			SCI_EmptyUndoBuffer(*New\ScintillaGadget)
		Else
			*New = New Panel()
			*New\File = NewFile()
			*New\ScintillaGadget = NewScintillaGadget(*this\IHM, "<New>")
		EndIf
		*System\Panel.SetElement(*System\Panel.CountElement() + 1, *New)
		*this\CurrentPanel = *System\Panel.CountElement()
	EndProcedure
	
	Procedure OpenProject(File.s)
		Protected *Project = OpenProject(File)
		If *Project
			System_CloseProject(*this)
			*this\OpenProject = *Project
			IHM_ShowProjectTree(*this\IHM, *this\OpenProject)
			ResizeWindows(*this\IHM, #WIN_Main)
			*this\Prefs.SetPreference("GENERAL", "OpenedProject", File)
			*this\Prefs.SavePreference()
		Else
			MessageRequester("error", "project  not loaded")
		EndIf
	EndProcedure
	
	Procedure PrecompileFile(File.s, Destination.s)
		*this\Precompiler.restart(*this.GetCurrentCompiler())
		*System\IHM.WriteMessage("Start Precompilation")
		If *this\Precompiler.start(File)
			If *this\Precompiler.LoadFileStructure()
				If *this\Precompiler.FormatCode()
					If *this\Precompiler.SaveFile(Destination)
						ProcedureReturn #True
					EndIf
				EndIf
			EndIf
		EndIf
		*System\IHM.WriteMessage("Precompilation failed")
		ProcedureReturn #False
		;Protected ID = RunProgram(*this\Prefs.GetPreference("GENERAL", "MainPath") + #PrecompilerName, File + " " + Destination, "", #PB_Program_Wait )
		;ProcedureReturn 	ProgramExitCode(ID)
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
			Text = ReplaceString(*this\Prefs.GetPreference("GENERAL", "OpenedFile"), "\", "/")
			For n = 1 To CountString(Text, ";") + 1
				Temp = StringField(Text, n, ";")
				If Not Temp =  *Panel\File\Path
					If NewText
						NewText + ";"
					EndIf
					NewText + Temp
				EndIf
			Next n
			*this\Prefs.SetPreference("GENERAL", "OpenedFile", NewText)
			*this\Prefs.SavePreference()
			
			
		EndIf
		IHM_RemovePanel(*this\IHM, number - 1)
		*this\CurrentPanel - 1
		*this\Panel.FreeElement(number)
		*Panel.Free()
		If *this\CurrentPanel = 0
			If *this\Panel.CountElement() = 0
				*this.AddPanel()
			EndIf
			*this\CurrentPanel = 1
		EndIf
		IHM_SetCurrentPanel(*this\IHM, *this\CurrentPanel - 1)
		ProcedureReturn #True
	EndProcedure
	
	Procedure precompilerIsEnable()
		ProcedureReturn Val(*this\Prefs.GetPreference("Compiler Options", "Precompiler"))
	EndProcedure
	
	Procedure BuildCurrentFile(Destination.s)
		Protected *panel.Panel = GetCurrentPanel(*this)
		Protected Run = #True, ID.i, Retour.s, Final.s
		Protected Flag.s
		Protected *Line.LineCode
		If *this.PrecompilerIsEnable()
			Run = *System.PrecompileFile(*Panel\File\Path,  TempDir + "main.pb")
			Flag.s = Chr(34) + TempDir + "main.pb" + Chr(34) + MakeCompilerParamList(*this)
		Else
			Flag.s = Chr(34) + *Panel\File\Path + Chr(34) + MakeCompilerParamList(*this)
		EndIf
		If Run
			Select  *this\Prefs.GetPreference("GENERAL", "structure")
				Case "X86"
					ID = Build(*System\Compiler[#X86], Flag, Destination)
				Case "X64"
					ID = Build(*System\Compiler[#X64], Flag, Destination)
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
				Debug Final
				If *this.PrecompilerIsEnable()
					;*Line = *this\Precompiler.getLine(Val(StringField(Final, 3, " ")))
					;*this.CodeError(*Line\File, *Line\Line, StringField(Final, CountString(Final, "-") + 1, "-"))
				Else
					If FindString(*Panel\File\Path, ";", 1)
						*this.CodeError(StringField(Final, 2, "'"), Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
					Else
						*this.CodeError(*Panel\File\Path, Val(StringField(Final, 3, " ")), StringField(Final, CountString(Final, "-") + 1, "-"))
					EndIf
				EndIf
			EndIf
		EndIf
	EndProcedure
	
	Procedure CodeError(File.s, Line.l, Error.s)
		*this\IHM.WriteMessage("Error:" + Error)
		*this.AddPanel(File)
		Protected *Ptr = GetCurrentScintillaGadget(*this.System)
		line - 1
		SCI_GoToPoS(*Ptr, SCI_PositionFromLine(*Ptr, line))
		SCI_SetSel(*Ptr, SCI_PositionFromLine(*Ptr, line), SCI_PositionFromLine(*Ptr, line) + SCI_LineLength(*Ptr, line))
		MessageRequester("", Error)
	EndProcedure
	
	
	Procedure RunProgram(File.s, Param.s, Precompilation.b)
		Protected ID.i, *Ptr, Retour.s, Final.s
		Protected *Line.LineCode
		Select  *this\Prefs.GetPreference("GENERAL", "structure")
			Case "X86"
				If *System\Compiler[#X86]
					ID = Compiler_RunProgram(*System\Compiler[#X86], Chr(34) + File + Chr(34) + Param)
				EndIf
			Case "X64"
				If *System\Compiler[#X64]
					ID = Compiler_RunProgram(*System\Compiler[#X64], Chr(34) + File + Chr(34) + Param)
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
EndClass



Procedure.s MakeCompilerParamList(*this.System)
	Protected Param.s
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

Procedure GetCurrentCompiler(*this.System)
	Select *this\Prefs.GetPreference("GENERAL", "structure")
		Case "X86"
			ProcedureReturn *System\Compiler[#X86]
		Case "X64"
			ProcedureReturn *System\Compiler[#X64]
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

Procedure UpdateOpenFile(*this.System,  type.i, File.s)
	Protected Text.s
	Select type
		Case  #File
			Text = *this\Prefs.GetPreference("GENERAL", "OpenedFile")
			If FindString(file, ";", 1) Or Text
				*this\Prefs.SetPreference("GENERAL", "OpenedFile", Text+";"+file)
			Else
				*this\Prefs.SetPreference("GENERAL", "OpenedFile", file)
			EndIf
	EndSelect
	*this\Prefs.SavePreference()
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

Procedure SaveCurrentPanel(*this.System)
	Protected *Panel.Panel = *this\Panel.GetElement(*this\CurrentPanel)
	Select SaveFile(*Panel\File, *Panel\ScintillaGadget)
		Case 1
			IHM_PanelSaved(*this\IHM, *this\CurrentPanel - 1, *Panel\File\File)
		Default
	EndSelect
	If *this\OpenProject
		If Project_IsFile(*this\OpenProject, *Panel\file)
			LoadStructure(*Panel\file)
		EndIf
	EndIf
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
	Protected *Ptr = GetCurrentScintillaGadget(*System)
	If SCI_CanUndo(*Ptr)
		DisableMenuItem(*this\IHM\menu[0],#undo,0)
	Else
		DisableMenuItem(*this\IHM\menu[0],#undo,1)
	EndIf
	If SCI_CanRedo(*Ptr)
		DisableMenuItem(*this\IHM\menu[0],#redo,0)
	Else
		DisableMenuItem(*this\IHM\menu[0],#redo,1)
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
		IHM_PanelModified(*this\IHM, *this\CurrentPanel - 1)
		*Panel\File\Saved = 0
	EndIf
EndProcedure

Procedure LoadTemplates(*this.System)
	Protected DirID = ExamineDirectory(#PB_Any, *this\Prefs.GetPreference("GENERAL", "MainPath") + "Templates/" , "*.chtp")
	If Not IsDirectory(DirID)
		ProcedureReturn 0
	EndIf
	Protected *Template
	While NextDirectoryEntry(DirID)
		*Template = NewTemplate(*this\Prefs.GetPreference("GENERAL", "MainPath") + "Templates/"  + DirectoryEntryName(DirID))
		If Not *Template
			ProcedureReturn 0
		EndIf
		IHM_AddTemplate(*System\IHM, *Template)
		*System\Template.SetElement(*System\Template.CountElement()+1, *Template)
	Wend
	FinishDirectory(DirID)
	ProcedureReturn 1
EndProcedure

Procedure CreateProject(*this.System, number.i, Path.s, Name.s)
	GenerateProject(*this\Template.GetElement(number) , Path, Name)
EndProcedure

Procedure GetCurrentProject(*this.System)
	ProcedureReturn *this\OpenProject
EndProcedure

Procedure System_CloseProject(*this.System)
	If *this\OpenProject
		IHM_CloseProject(*this\IHM)
		FreeProject(*this\OpenProject)
		*this\OpenProject = #Null
		*this\Prefs.SetPreference("GENERAL", "OpenedProject", "")
		*this\Prefs.SavePreference()
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
			DisableMenuItem(*this\IHM\menu[0], #SwitchStructure, 1)
		EndIf
	ElseIf FileSize(*this\Prefs.GetPreference("X86", "Compiler Path") + #PB_CompilerName) > 0
		If FileSize(*this\Prefs.GetPreference("X64", "Compiler Path") + #PB_CompilerName) < 0
			DisableMenuItem(*this\IHM\menu[0], #SwitchStructure, 1)
		EndIf
	Else
		DisableMenuItem(*this\IHM\menu[0], #Compiler, 1)
		DisableMenuItem(*this\IHM\menu[0], #CompilerProject, 1)
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

Procedure SystemEnd(*this.System)
	Protected n
	For n = 1 To *this\Panel.CountElement()
		If *this.RemoveCurrentPanel(#False) = -1
			ProcedureReturn
		EndIf
	Next n
	End
EndProcedure

