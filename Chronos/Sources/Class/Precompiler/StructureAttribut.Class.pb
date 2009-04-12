Class StructureAttribut Extends Precompiler::Attribut
  Array.s
  Ptr.b

  Procedure StructureAttribut(Text.s)
    If Mid(Text, 1, 1) = "*"
      *this\Ptr = #True
      Text = Mid(Text, 2)
    EndIf
    If FindString(Text, ".", 1)
      *this\Type = StringField(Text, 2, ".")
      Text = StringField(Text, 1, ".")
    Else
      *this\Type = "i"
    EndIf
    If FindString(Text, "[", 1)
      *this\Name = StringField(Text, 1, "[")
      *this\Array = StringField(StringField(Text, 2, "["), 1, "]")
    Else
      *this\Name = Text
    EndIf
  EndProcedure

  Procedure.s GetDeclaration()
    Protected retour.s
    If *this\Ptr
      retour = "*"
    EndIf
    retour + *this\Name + "." + *this\Type
    If *this\Array
      retour + "[" + *this\Array + "]"
    EndIf
    ProcedureReturn retour
  EndProcedure
EndClass

; Procedure.s StructureAttribut_Get(*this.Precompiler::StructureAttribut)
;   Protected Text.s
;   If *this\Ptr = #True
;     Text = "*"
;   EndIf
;   Text + *this\Name + "." + *this\Type
;   If *this\Array
;     Text + "[" + *this\Array + "]"
;   EndIf
;   ProcedureReturn Text
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 23
; Folding = -
; EnableXP