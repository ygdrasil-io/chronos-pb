Class LineCode
    File.s
  Line.l
  Text.s
  Procedure LineCode(Text.s, File.s, Line.l)
    *this\Text = Text
    *this\File = File
    *this\Line = Line
  EndProcedure
  
  Procedure Free()
    FreeMemory(*this)
  EndProcedure
EndClass

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 10
; Folding = -
; EnableXP