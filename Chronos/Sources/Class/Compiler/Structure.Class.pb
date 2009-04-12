Procedure NewCompilerStructure(Name.s)
	Protected *this.CompilerStructure = AllocateMemory(SizeOf(CompilerStructure))
	*this\Name = Name
	*this\atribut = New Array()
	ProcedureReturn *this
EndProcedure

Procedure.s CompilerStructure_GetName(*this.CompilerStructure)
	ProcedureReturn *this\Name
EndProcedure

Procedure FreeCompilerStructure(*this.CompilerStructure)
	FreeMemory(*this)
EndProcedure


; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableXP
