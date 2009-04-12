Class Macro Extends LineCode
  *Body.Array = New Array()

EndClass


Procedure LoadMacro(n)
  Protected *PMacro.Precompiler::Macro = New Precompiler::Macro(), i
  *this\Macro.AddElement(*PMacro)
  Protected *Line.LineCode = *this\LocalText.getElement(n)
  *PMacro\Text = *Line\Text
  *PMacro\File = *Line\File
  *PMacro\Line = *Line\Line
  *PMacro\Text = ReleaseString(*PMacro\Text, *this\String)
  For i = n + 1 To *this\LocalText.CountElement()
    *Line.LineCode = *this\LocalText.GetElement(i)
    Select LineIs(*Line\Text)
      Case #EndMacro
        ProcedureReturn i
      Default 
        *Line\Text = ReleaseString(*Line\Text, *this\String)
        *PMacro\Body.AddElement(New LineCode(*Line\Text, *Line\File, *Line\Line))
    EndSelect
  Next i
  *Line.LineCode = *this\LocalText.getElement(n)
  *System.CodeError(*Line\File, *Line\Line, "EndMacro not found")
  ProcedureReturn #False
EndProcedure

; Procedure NewMacro(Text.s)
;   Protected *this.Macro = AllocateMemory(SizeOf(Macro))
;   *this\Text = Text
;   ProcedureReturn *this
; EndProcedure
; 
; Procedure.s Macro_GetText(*this.Macro)
;   ProcedureReturn *this\Text
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 20
; Folding = -
; EnableXP