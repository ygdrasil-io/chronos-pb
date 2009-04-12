Class Variable Extends Precompiler::Attribut
;   Procedure Variable(*Line.LineCode);construteur
;     Protected *this.Variable = AllocateMemory(SizeOf(Variable))
;     *this\Name = Name
;     *this\Type = Type
;     ProcedureReturn*this
;   EndProcedure



EndClass
; Procedure NewVariable(name.s, type.s);construteur
;   Protected *this.Variable = AllocateMemory(SizeOf(Variable))
;   *this\Name = Name
;   *this\Type = Type
;   ProcedureReturn*this
; EndProcedure
; 
; 
; Procedure.s LoadVariable_(Line.s, *Array.Array, DefaultType.s = "i");statique
;   Protected Current.s, Name.s
;   If FindString(Line, "=", 1)
;     Current = Mid(Line, 1, FindString(Line, "=", 1) - 1)
;     Line = Mid(Line, FindString(Line, "=", 1) + 1)
;   Else
;     Current = Line
;     Line = ""
;   EndIf
;   If FindString(Current, ".", 1)
;     Name = StringField(Current, 1, ".")
;     AddEllement(*Array, NewVariable(Name, Mid(Current, FindString(Current, ".", 1) + 1)))
;   Else
;     Name = Current
;     AddEllement(*Array, NewVariable(Name, DefaultType))
;   EndIf
;   If Line 
;     Name + "=" + Line
;   Else
;     Name = ""
;   EndIf
;   ProcedureReturn Name
; EndProcedure
; 
Procedure LoadVariable(n.l, IsGlobal.b, DefaultType.s = "i");statique
  Protected i, *Line.LineCode = *this\LocalText.GetElement(n), *NewLine.LineCode
  Protected *NewAttribut.Precompiler::Attribut
  Protected *Variable.Precompiler::Variable
  Protected CountP.i, Temp.s
  For i = 1 To Len(*Line\Text)
    Select Mid(*Line\Text, i, 1)
      Case "("
        CountP + 1
      Case ")"
        CountP - 1
      Case ","
        If CountP = 0
          Temp = Left(*Line\Text, i - 1)
          If FindString(Temp, "=", 1)
            *NewLine = New LineCode(StringField(StringField(Temp, 1, "="),1, ".") + Mid(Temp, FindString(Temp, "=", 1)), *Line\File, *Line\Line)
            *this\Body.AddElement(*NewLine)
            Temp = StringField(Temp, 1, "=")
          EndIf
          *NewAttribut = New Precompiler::Attribut()
          If FindString(Temp, ".", 1)
            *NewAttribut\Name = StringField(Temp, 1, ".")
            *NewAttribut\Type = StringField(Temp, 2, ".")
          Else
            *NewAttribut\Name = Temp
            *NewAttribut\Type = DefaultType
          EndIf
          If IsGlobal
            *this\GlobalV.AddElement(*NewAttribut)
          Else
            *this\LocalV.AddElement(*NewAttribut)
          EndIf
          *Line\Text = Mid(*Line\Text, i + 1)
          If Not *this.LoadVariable(n, IsGlobal, DefaultType)
            ProcedureReturn #False
          EndIf
        EndIf
        ProcedureReturn #True
    EndSelect
  Next i
  If FindString(*Line\Text, "=", 1)
    *NewLine = New LineCode(StringField(StringField(*Line\Text, 1, "="),1, ".") + Mid(*Line\Text, FindString(*Line\Text, "=", 1)), *Line\File, *Line\Line)
    *this\Body.AddElement(*NewLine)
    *Line\Text = StringField(*Line\Text, 1, "=")
  EndIf
  *NewAttribut = New Precompiler::Attribut()
  If FindString(*Line\Text, ".", 1)
    *NewAttribut\Name = StringField(*Line\Text, 1, ".")
    *NewAttribut\Type = StringField(*Line\Text, 2, ".")
  Else
    *NewAttribut\Name = *Line\Text
    *NewAttribut\Type = DefaultType
  EndIf
  *NewAttribut\Type = ReplaceString(*NewAttribut\Type, "::", "_")
  If IsGlobal
    *this\GlobalV.AddElement(*NewAttribut)
  Else
    *this\LocalV.AddElement(*NewAttribut)
  EndIf
  ProcedureReturn #True
EndProcedure
; 
; Procedure GetVariable(*Array.Array, Name.s)
;   Name = LCase(Name)
;   Protected n, *ptr.Variable
;   For n = 1 To CountEllement(*Array)
;     *ptr = GetEllement(*Array, n)
;     If LCase(*ptr\Name) = Name
;       ProcedureReturn *ptr
;     EndIf
;   Next n
;   ProcedureReturn #Null
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 89
; FirstLine = 46
; Folding = -
; EnableXP