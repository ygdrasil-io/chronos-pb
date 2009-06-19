Global CompilerFunction.s, CompilerStructure.s

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
	#CompilerSubSystem = "/SUBSYSTEM"
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
	#CompilerSubSystem = "-s"
CompilerEndCondition

#CompilerFlagGetStructureList = "STRUCTURELIST"
#CompilerFlagQuit = "END"
#CompilerFlagEndOutput = "OUTPUT	COMPLETE"
#CompilerFlagGetFunctionList = "FUNCTIONLIST"
#x86 = 0
#x64 = 1

Class Compiler
	Path.s
	FunctionList.s
	StructureList.s
	*Constante.Array = New Array()
	*Structure.Array = New Array()
	*Function.Array = New Array()
	LastFile.s
	
	Procedure GetStructure(Name.s)
		Protected n, *StructureP.CompilerStructure
		Name = LCase(Name)
		For n = 1 To *this\Structure.CountElement()
			*StructureP = *this\Structure.GetElement(n)
			If LCase(*StructureP\Name) = Name
				ProcedureReturn *StructureP
			EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
	
	
	Procedure Compiler(StructureCompiler.w)
		Protected n
		Select StructureCompiler
			Case #X86
				*this\Path = *System\Prefs.GetPreference("X86", "Compiler Path")
				CompilerIf #PB_Compiler_OS = #PB_OS_Linux
					SetEnvironmentVariable("PUREBASIC_HOME", *this\Path + "..")
					SetEnvironmentVariable("PATH", GetEnvironmentVariable("PATH") + ":" + *this\Path + "..")
				CompilerEndIf
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
			ProcedureReturn #False
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
	EndProcedure
	
	Procedure Build(Flag.s, Destination.s)
		*this\LastFile = Destination
		Debug *this\LastFile
		ProcedureReturn RunProgram(*this\Path, Flag + " " + #CompilerFlagBuild + " " + Chr(34) + Destination + Chr(34) + " " + #CompilerFlagQuiet, "", #PB_Program_Read | #PB_Program_Open | #PB_Program_Write | #PB_Program_Hide)
	EndProcedure
	
	Procedure ExecuteDebugger()
		RunProgram(GetPathPart(*this\Path) + #PB_Debugger, Chr(34) + *this\LastFile + Chr(34), GetPathPart(*this\LastFile), #PB_Program_Wait)
		If FileSize(*this\LastFile) > 0
			DeleteFile(*this\LastFile)
		EndIf
	EndProcedure
	
	Procedure ExecuteFile()
		RunProgram(*this\LastFile, "",GetPathPart(*this\LastFile), #PB_Program_Wait)
		If FileSize(*this\LastFile) > 0
			DeleteFile(*this\LastFile)
		EndIf
	EndProcedure
EndClass



Procedure.s Compiler_GetFunctionProtoFromName(*this.Compiler, txt.s)
	Protected n, *fct.CompilerFunction
	For n=1 To *this\Function.CountElement()
		*fct = *this\Function.GetElement(n)
		If LCase(txt) = LCase(*fct\Name)
			ProcedureReturn *fct\Declaration
		EndIf
	Next n
EndProcedure

Procedure Compiler_RunProgram(*this.Compiler, Param.s, WorkingDirectory.s)
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
