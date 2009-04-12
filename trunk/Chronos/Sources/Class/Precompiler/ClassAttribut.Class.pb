Class ClassAttribut Extends Precompiler::StructureAttribut
  DefaultValue.s


  Procedure ClassAttribut(*Line.LineCode)
    *this\Line = *Line\Line
    *this\File = *Line\File
    If Mid(*Line\Text, 1, 1) = "*"
      *this\Ptr = #True
      *Line\Text = Mid(*Line\Text, 2)
    EndIf
    If FindString(*Line\Text, "=", 1)
      *this\DefaultValue = Trim(Mid(*Line\Text, FindString(*Line\Text, "=", 1) + 1))
      *Line\Text = StringField(*Line\Text, 1, "=")
    EndIf
    If FindString(*Line\Text, "[", 1)
      *this\Array = StringField(StringField(*Line\Text, 1, "]"), 2, "[")
      *Line\Text = StringField(*Line\Text, 1, "[") + StringField(*Line\Text, 2, "]")
    EndIf
    If FindString(*Line\Text, ".", 1)
      *this\Name = StringField(*Line\Text, 1, ".")
      *this\Type = StringField(*Line\Text, 2, ".")
    Else
      *this\Name = *Line\Text
      *this\Type = "i"
    EndIf
  EndProcedure
EndClass
; Procedure WriteConstructeurDeclaration(*this.ClassAttribut, FileID.i, BOM.l)
;   If *this\DefaultValue
;     WriteStringN(FileID, Chr(9) + "*this\" + RemoveString(*this\Name, "*") + " = " + *this\DefaultValue, BOM)
;   EndIf
; EndProcedure
; 
; 
; 
; 
; 
; Procedure.s getDeclaration(*this.ClassAttribut)
;   ProcedureReturn *this\Name + "." + *this\Type
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 7
; Folding = -
; EnableXP