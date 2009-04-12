Class Constant Extends Precompiler::Element
  Name.s
  Value.s
  Procedure Constant(*Line.LineCode, *Element.Precompiler::Element)
  *this\Name = StringField(*Line\Text, 1, "=")
  *this\Value = ReplaceString(Mid(*Line\Text, FindString(*Line\Text, "=", 1) + 1), "::", "_")
  *this\File = *Line\File
  *this\Line = *Line\Line
  If *Element
    *this\PrecompilerCondition = *Element\PrecompilerCondition
    *this\CFile = *Element\File
    *this\CLine = *Element\Line
  EndIf
  EndProcedure
  
  
EndClass

Procedure LoadEnumeration(n, *Element.Precompiler::Element)
  Protected *Line.LineCode, Temp.s
  Protected Value.s, x = 0
  *Line = *this\LocalText.GetElement(n)
  If FindString(*Line\Text, " ", 1)
    Value = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
  EndIf
  For n = n + 1 To *this\LocalText.CountElement()
    *Line = *this\LocalText.GetElement(n)
    Select LineIs(*Line\Text)
      Case #EndEnumeration
        ProcedureReturn n
      Case #Constant 
        *Line\Text + "=" 
        If Value 
          *Line\Text + Value + "+" + Str(x)
        Else
          *Line\Text + Str(x)
        EndIf
        *this\Constant.AddElement(New Precompiler::Constant(*Line , *Element))
        x + 1
    EndSelect
  Next n
  ProcedureReturn #False
EndProcedure

Procedure IsConstant(Name.s)
  ProcedureReturn #False
EndProcedure
; Procedure NewConstant(Text.s, CompilerCondition.s)
;   Protected *this.Constant = AllocateMemory(SizeOf(Constant)), Var.s, n
;   *this\Text = Text
;   ;PrintN("new constant " + StringField(Text, 1, "="))
;   *this\CompilerCondition = CompilerCondition
;   ProcedureReturn *this
; EndProcedure
; 
; 
; Procedure.s Constant_WriteDeclaration(*this.Constant, FileID, BOM)
;   If  *this\CompilerCondition
;     WriteStringN(FileID, "CompilerIf " + *this\CompilerCondition, BOM)
;     WriteStringN(FileID, *this\Text, BOM)
;     WriteStringN(FileID, "CompilerEndif", BOM)
;   Else
;     WriteStringN(FileID, *this\Text, BOM)
;   EndIf
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 35
; Folding = -
; EnableXP