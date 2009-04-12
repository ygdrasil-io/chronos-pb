Procedure CreateSystem()
  *Precompiler = NewCompiler()
  If OpenConsole()
    ConsoleTitle("Chronos Precompiler")
    Protected Ending.s, Count.b = CountProgramParameters(), File.s
    Protected Exec = #False, GenerateDestination.s = "", back.s, Destination.s
    Protected Parameter.s
    If Not Count = 2
      PrintN("Error:File Not Found")
    EndIf
    File = ProgramParameter()
    Destination = ProgramParameter()
    PrintN("Start Chronos")
    LoadFile(*Precompiler, File)
    LoadStructure(*Precompiler)
    FormatCode(*Precompiler)
    WriteFile(*Precompiler, Destination)
  EndIf
EndProcedure


; IDE Options = PureBasic 4.30 (Windows - x86)
; Folding = -
; EnableXP
; UseMainFile = main.pb
; Executable = Precompiler.exe