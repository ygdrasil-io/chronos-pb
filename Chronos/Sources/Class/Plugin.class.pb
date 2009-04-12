Procedure NewPlugin(Path.s)
   Protected ID = OpenLibrary(#PB_Any, Path)
   If IsLibrary(ID)
    Protected *This.Plugin = AllocateMemory(SizeOf(plugin))
      *This\Name = ""
      *This\ID = ID
      *This\Function = CreateArray()
      Protected *ptr = GetFunction( *This\ID, "Init")
      If *ptr
        CompilerIf #PB_Compiler_OS = #PB_OS_Windows
          CallFunctionFast(*ptr, *System)
        CompilerElse
          CallCFunctionFast(*ptr, *System)
        CompilerEndIf
      Else
        Debug "erreur"
      EndIf
      Debug CountEllement(*System\ProgrammingLanguage)
    ProcedureReturn *This
   Else
    ProcedureReturn 0
   EndIf
EndProcedure


; IDE Options = PureBasic 4.30 Beta 5 (Windows - x86)
; CursorPosition = 6
; Folding = -
; EnableXP