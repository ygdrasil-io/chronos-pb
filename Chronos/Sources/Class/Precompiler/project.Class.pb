Procedure LoadProject(File.s)
  Protected FileID = OpenFile(#PB_Any, File), *this.Project = AllocateMemory(SizeOf(Project))
  If FileID
    Protected DOM = ReadStringFormat(FileID), txt.s
    While Not Eof(FileID)
      txt = ReadString(FileID, DOM)
      Select LCase(StringField(txt, 1, ":"))
        Case "directory"
          *this\Directory = GetPathPart(File)+StringField(txt, 2, ":") + #PathSlash
      EndSelect
    Wend
    *this\MainFile = *this\Directory + "Sources" + #PathSlash + "main.pb"
    CloseFile(FileID)
    ProcedureReturn *this 
  Else
    ProcedureReturn 0
  EndIf
EndProcedure

Procedure.s GetMainFile(*this.Project)
  ProcedureReturn *this\MainFile
EndProcedure

Procedure.s GetDir(*this.Project)
  ProcedureReturn *this\Directory + "Generated Sources" + #PathSlash
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 24
; Folding = -
; EnableXP