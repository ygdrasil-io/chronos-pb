Class Attribut Extends LineCode
  Name.s
  Type.s


EndClass

  Procedure LoadAttribut(*Line.LineCode, *List.Array, *Body.Array)
    Protected n, Temp.s, CountP.l, *Attribut.Precompiler::Attribut, *NewLine.LineCode
    *Attribut = New Precompiler::Attribut()
    *Attribut\File = *Line\File
    *Attribut\Line = *Line\Line
    *List.AddElement(*Attribut)
    
    For n = 1 To Len(*Line\Text)
      Select Mid(*Line\Text, n, 1)
        Case "("
          CountP + 1
        Case ")"
          CountP - 1
        Case ","
          If CountP = 0
            Temp = Left(*Line\Text, n - 1)
            *Line\Text = Mid(*Line\Text, n + 1)
            If FindString(Temp, "=", 1)
              *NewLine = New LineCode(StringField(StringField(Temp, 1, "="), 1, ".") + Mid(Temp, FindString(Temp, "=", 1)), *Line\File, *Line\Line)
              *Body.AddElement(*NewLine)
              Temp = StringField(Temp, 1, "=")
            EndIf
            If FindString(Temp, ".", 1)
              *Attribut\Name = StringField(Temp, 1, ".")
              *Attribut\Type = StringField(Temp, 2, ".")
            Else
              *Attribut\Name = Temp
              *Attribut\Type = "i"
            EndIf
            ProcedureReturn *this.LoadAttribut(*Line, *List, *Body)
          EndIf
      EndSelect
    Next n
    If FindString(*Line\Text, "=", 1)
      *NewLine = New LineCode(StringField(StringField(*Line\Text, 1, "="), 1, ".") + Mid(*Line\Text, FindString(*Line\Text, "=", 1)), *Line\File, *Line\Line)
      *Body.AddElement(*NewLine)
      *Line\Text = StringField(*Line\Text, 1, "=")
    EndIf
    If FindString(*Line\Text, ".", 1)
      *Attribut\Name = StringField(*Line\Text, 1, ".")
      *Attribut\Type = StringField(*Line\Text, 2, ".")
    Else
      *Attribut\Name = *Line\Text
      *Attribut\Type = "i"
    EndIf
    ProcedureReturn #True
  EndProcedure



; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 47
; FirstLine = 2
; Folding = -
; EnableXP