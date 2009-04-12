Procedure NewProgrammingLanguage(Name.s, Extension.s, Patern.s)
   Protected *this.ProgrammingLanguage = AllocateMemory(SizeOf(ProgrammingLanguage))
   *this\Name = Name
   *this\Extension = Extension
   *this\Patern = Patern
   ProcedureReturn *this
EndProcedure
; IDE Options = PureBasic 4.30 Beta 5 (Linux - x86)
; CursorPosition = 5
; Folding = -
; EnableXP