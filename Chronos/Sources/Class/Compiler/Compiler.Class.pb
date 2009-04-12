Class Compiler
	Path.s
	FunctionList.s
	StructureList.s
	*Constante.Array = New Array()
	*Structure.Array = New Array()
	*Function.Array = New Array()
	
	
	Procedure GetStructure(Name.s)
		Protected n, *StructureP.Structure
		Name = LCase(Name)
		For n = 1 To *this\Structure.CountElement()
			*StructureP = *this\Structure.GetElement(n)
			If LCase(*StructureP\Name) = Name
				ProcedureReturn *StructureP
			EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
EndClass

Procedure NewCompiler(StructureCompiler.w)
	Protected *this.Compiler = AllocateMemory(SizeOf(Compiler)), n
	*this\Constante = New Array()
	*this\Structure = New Array()
	*this\Function = New Array()
	Select StructureCompiler
		Case #X86
			*this\Path = *System\Prefs.GetPreference("X86", "Compiler Path")
		Case #X64
			*this\Path = *System\Prefs.GetPreference("X64", "Compiler Path")
	EndSelect
	*this\Path + #PB_Compiler
	If FileSize(*this\Path) <= 0
		FreeCompiler(*this)
		ProcedureReturn 0
	EndIf
	Protected ID = RunProgram(*this\Path, #CompilerFlagStandby, "", #PB_Program_Read | #PB_Program_Open | #PB_Program_Write | #PB_Program_Hide)
	If Not ID
		FreeCompiler(*this)
		ProcedureReturn 0
	EndIf
	Protected Sortie.s
	While ProgramRunning(ID)
		Sortie = ReadProgramString(ID)
		If Sortie = "READY"
			WriteProgramStringN(ID, #CompilerFlagGetStructureList)
			While ProgramRunning(ID)
				Sortie = ReadProgramString(ID)
				If Sortie = #CompilerFlagEndOutput
					Break
				Else
					*this\Structure.AddElement(NewCompilerStructure(Sortie))
				EndIf
			Wend
			
			WriteProgramStringN(ID, #CompilerFlagGetFunctionList)
			While ProgramRunning(ID)
				Sortie = ReadProgramString(ID)
				If Sortie = #CompilerFlagEndOutput
					Break
				Else
					*this\Function.AddElement(NewCompilerFunction(Sortie))
				EndIf
			Wend
			Break
		EndIf
	Wend
	WriteProgramStringN(ID, #CompilerFlagQuit)
	CloseProgram(ID)
	Select StructureCompiler
		Case #X86
			If *System\Prefs.GetPreference("GENERAL", "structure") = "X86"
				CompilerFunction = ""
				For n = 1 To *this\Function.CountElement()
					CompilerFunction + CompilerFunction_GetName(*this\Function.GetElement(n)) + " "
				Next
				CompilerStructure = ""
				For n = 1 To *this\Structure.CountElement()
					CompilerStructure + CompilerStructure_GetName(*this\Structure.GetElement(n)) + " "
				Next
			EndIf
		Case #X64
			If *System\Prefs.GetPreference("GENERAL", "structure") = "X64"
				CompilerFunction = ""
				For n = 1 To *this\Function.CountElement()
					CompilerFunction + CompilerFunction_GetName(*this\Function.GetElement(n)) + " "
				Next
				CompilerStructure = ""
				For n = 1 To *this\Structure.CountElement()
					CompilerStructure + CompilerStructure_GetName(*this\Structure.GetElement(n)) + " "
				Next
			EndIf
	EndSelect
	
	ProcedureReturn *this
EndProcedure


Procedure.s Compiler_GetFunctionProtoFromName(*this.Compiler, txt.s)
	Protected n, *fct.CompilerFunction
	For n=1 To *this\Function.CountElement()
		*fct = *this\Function.GetElement(n)
		If LCase(txt) = LCase(*fct\Name)
			ProcedureReturn *fct\Declaration
		EndIf
	Next n
EndProcedure

Procedure Compiler_RunProgram(*this.Compiler, Param.s)
	ProcedureReturn RunProgram(*this\Path, Param + " " + #CompilerFlagQuiet, "", #PB_Program_Read | #PB_Program_Open | #PB_Program_Write | #PB_Program_Hide)
EndProcedure

Procedure Build(*this.Compiler, Flag.s, Destination.s)
	ProcedureReturn RunProgram(*this\Path, Flag + " " + #CompilerFlagBuild + " " + Chr(34) + Destination + Chr(34) + " " + #CompilerFlagQuiet, "", #PB_Program_Read | #PB_Program_Open | #PB_Program_Write | #PB_Program_Hide)
EndProcedure

Procedure FreeCompiler(*this.Compiler)
	*this\Function.Free()
	*this\Structure.Free()
	*this\Constante.Free()
	FreeMemory(*this)
EndProcedure

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 117
; FirstLine = 54
; Folding = 9-
; EnableXP
; UseMainFile = ..\..\Chronos.pb
