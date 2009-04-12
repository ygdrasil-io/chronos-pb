Class ProcedureAttribut Extends Precompiler::Attribut
  DefaultValue.s
  
  Procedure ProcedureAttribut(Definition.s, File.s, Line.l)
    If FindString(Definition, "=", 1)
      *this\DefaultValue = Trim(Mid(Definition, FindString(Definition, "=", 1) + 1))
      Definition = Mid(Definition, 1, FindString(Definition, "=", 1) - 1) 
    EndIf
    If FindString(Definition, ".", 1)
      *this\Name = StringField(Definition, 1, ".")
      *this\Type = StringField(Definition, 2, ".")
    Else
      *this\Name = Definition
      *this\Type = "i"
    EndIf
    *this\File = File
    *this\Line = Line
  EndProcedure
  
  Procedure.s GetDeclaration()
    Protected Def.s = *this\Name  + "." + *this\Type 
    If  *this\DefaultValue
      Def + "=" + *this\DefaultValue
    EndIf
  ProcedureReturn Def
EndProcedure
EndClass
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 15
; Folding = -
; EnableXP