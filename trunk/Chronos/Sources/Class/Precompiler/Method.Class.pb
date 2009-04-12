Class Method Extends Precompiler::Procedure
  ClassName.s
EndClass

Procedure LoadMethod(n, *Class.Precompiler::Class)
  Protected *Line.LineCode = *this\LocalText.GetElement(n), i
  Protected *ProcedureP.Precompiler::Method = New Precompiler::Method(), Countp.l
  Protected *Attribut.Precompiler::Attribut
  Protected *CAttribut. Precompiler::ClassAttribut
  Protected Type.l
  *ProcedureP\Attribut.Array = New Array()
  *ProcedureP\LocalV.Array = New Array()
  *ProcedureP\Body.Array = New Array()
  
  If LCase(StringField(*Line\Text, 1, " ")) = "static"
    *Line\Text = Mid(*Line\Text, 8)
    *Class\StaticMethod.AddElement(*ProcedureP)
    Type = 2
  Else
    If Not *Class.IsConstructor(*Line\Text)
      *Class\Method.AddElement(*ProcedureP)
      *ProcedureP\Attribut.AddElement(New Precompiler::ProcedureAttribut("*this." + *Class\Name, *Line\File, *Line\Line))
    Else
      Type = 1
      *Attribut = New Precompiler::Attribut()
      *Attribut\File = *Line\File
      *Attribut\Line = *Line\Line
      *Attribut\Name = "*this"
      *Attribut\Type = *Class\Name
      *ProcedureP\LocalV.AddElement(*Attribut)
      *ProcedureP\Body.AddElement(New LineCode("*this=allocatememory(sizeof("+*Class\Name+"))", *Line\File, *Line\Line))
      For i = 1 To *Class\Attribut.CountElement()
        *CAttribut = *Class\Attribut.GetElement(i)
        If *CAttribut\DefaultValue
          *ProcedureP\Body.AddElement(New LineCode(Chr(9) + "*this\" + *CAttribut\Name + "=" + *CAttribut\DefaultValue, *CAttribut\File, *CAttribut\Line))
        EndIf
      Next i
      
      *Class\Constructor.AddElement(*ProcedureP)
    EndIf
  EndIf
  *ProcedureP\File = *Line\File
  *ProcedureP\Line = *Line\Line
  *this\Procedure.AddElement(*ProcedureP)
  Protected Temp.s = StringField(*Line\Text, 1, " "), Count.l
  If FindString(Temp, ".", 1)
    *ProcedureP\Type = StringField(Temp, 2, ".")
    Temp = StringField(Temp, 1, ".")
  Else
    *ProcedureP\Type = "i"
  EndIf
  Select LCase(Temp)
    Case "procedure"
      *ProcedureP\ProcedureMode = #Mode_Procedure
    Case "procedurec"
      *ProcedureP\ProcedureMode = #Mode_ProcedureC
    Case "proceduredll"
      *ProcedureP\ProcedureMode = #Mode_ProcedureDLL
    Case "procedurecdll"
      *ProcedureP\ProcedureMode = #Mode_ProcedureCDLL
  EndSelect
  *Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
  Select Type
    Case 1 ;Constructeur
      *ProcedureP\ClassName = *Class\Name
      *ProcedureP\Name = "New_" + *Class\Name
    Case 2 ;Methode Statique
      *ProcedureP\ClassName = StringField(*Line\Text, 1, "(")
      *ProcedureP\Name = *Class\Name + "_Static_" + *ProcedureP\ClassName
    Default ;Methode
      *ProcedureP\ClassName = StringField(*Line\Text, 1, "(")
      *ProcedureP\Name = *Class\Name + "_" + *ProcedureP\ClassName
  EndSelect
  *Line\Text = Mid(*Line\Text, FindString(*Line\Text, "(", 1) + 1)
  Temp = ""
  For i = 1 To Len(*Line\Text)
    Select Mid(*Line\Text, i, 1)
      Case "("
        Count + 1
      Case ")"
        Count - 1
        If Count = -1
          Break
        EndIf
      Case ","
        If Count = 0
          *ProcedureP\Attribut.AddElement(New Precompiler::ProcedureAttribut(Temp, *Line\File, *Line\Line))
          Temp = ""
          i+1
        EndIf
    EndSelect
    Temp + Mid(*Line\Text, i, 1)
  Next i
  If Temp
    *ProcedureP\Attribut.AddElement(New Precompiler::ProcedureAttribut(Temp, *Line\File, *Line\Line))
  EndIf

  For i = n + 1 To *this\LocalText.CountElement()
    *Line = *this\LocalText.GetElement(i)
    Select LineIs(*Line\Text)
      Case #Protected
          *Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
          If Not *This.LoadAttribut(*Line, *ProcedureP\LocalV, *ProcedureP\body)
            ProcedureReturn #False
          EndIf
      Case #EndProcedure
        If Type = 1
          *ProcedureP\Body.AddElement(New LineCode(Chr(9) + "ProcedureReturn *this", *Line\File, *Line\Line))
        EndIf
        ProcedureReturn i
      Default 
        If *Line\Text
          *ProcedureP\body.AddElement(New LineCode(*Line\Text, *Line\File, *Line\Line))
        EndIf
    EndSelect
    If i = #False
      ProcedureReturn #False
    EndIf
  Next i
  *Line = *this\LocalText.GetElement(n)
  *System.CodeError(*Line\File, *Line\Line, "Procedure Ending not found")
  ProcedureReturn #False
EndProcedure

; Procedure Method_CountAtribut(Text.s)
;   Protected n, Count, QuoteCount, DoubleQuoteCount, LBracketCount, RBracketCount, Empty.b = #True
;   For n = 1 To Len(Text)
;     Select Mid(Text, n, 1)
;       Case "'"
;         QuoteCount + 1
;       Case Chr('"')
;         DoubleQuoteCount + 1
;       Case "("
;         LBracketCount + 1
;       Case ")" 
;         If LBracketCount = RBracketCount 
;           If Count > 1
;             Count + 1
;             ProcedureReturn Count
;           Else
;             If Not Empty
;               Count + 1
;             EndIf
;             ProcedureReturn Count
;           EndIf
;         EndIf
;         RBracketCount + 1
;       Case ","
;         If LBracketCount = RBracketCount And QuoteCount%2 = 0 And DoubleQuoteCount%2=0
;           Count + 1
;         EndIf
;       Case " "
;       Default 
;         Empty = #False
;     EndSelect
;   Next n
;   ProcedureReturn -1;erreur
; EndProcedure
; 
; Procedure.s GetAtribut(Text.s, Number)
;   Protected n, Count, QuoteCount, DoubleQuoteCount, LBracketCount, RBracketCount, Empty.b = #True, Lastn = 0
;   For n = 1 To Len(Text)
;     Select Mid(Text, n, 1)
;       Case "'"
;         QuoteCount + 1
;       Case Chr('"')
;         DoubleQuoteCount + 1
;       Case "("
;         LBracketCount + 1
;       Case ")" 
;         If LBracketCount = RBracketCount 
;           If Count > 1
;             Count + 1
;             If Count = Number
;               ProcedureReturn Mid(Text, Lastn + 1, n - Lastn - 1)
;             Else
;               Lastn = n
;             EndIf
;           Else
;             If Not Empty
;               Count + 1
;               If Count = Number
;                 ProcedureReturn Mid(Text, Lastn + 1, n - Lastn - 1)
;               EndIf
;             EndIf
;             ProcedureReturn ""
;           EndIf
;         EndIf
;         RBracketCount + 1
;       Case ","
;         If LBracketCount = RBracketCount And QuoteCount%2 = 0 And DoubleQuoteCount%2=0
;           Count + 1
;         EndIf
;       Case " "
;       Default 
;         Empty = #False
;     EndSelect
;   Next n
;   ProcedureReturn ""
; EndProcedure

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 32
; Folding = -
; EnableXP