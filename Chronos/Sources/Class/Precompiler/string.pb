Procedure.s StockString(Line.s, *StringList.Array)
  Protected n = FindString(Line, Chr(34), 1), *String, Text.s
  While n
    Text = Mid(Line, n + 1, FindString(Line, Chr(34), n + 1) - n - 1)
    *String = AllocateMemory(Len(Text) + 1)
    PokeS(*String,Text)

    AddEllement(*StringList, *String)
    FindString(Line, Chr(34), 1)
    Line = Left(Line, n - 1) + "$" + Str(CountEllement(*StringList)) + "$" + Mid(Line, FindString(Line, Chr(34), n + 1) + 1)
    n = FindString(Line, Chr(34), 1)
  Wend
  ProcedureReturn Line
EndProcedure

Procedure.s ReleaseString(Line.s, *StringList.Array)
  Protected n, Var.s
  For n = 1 To Len(Line)
    If Mid(Line, n, 1) = "$"
      Var = ""
      While n <= Len(Line)
        n + 1
        If Mid(Line, n, 1) = "$"
          Break
        ElseIf Mid(Line, n, 1) >= "0" And Mid(Line, n, 1) <= "9"
          Var + Mid(Line, n, 1)
        Else
          Var = ""
          Break;
        EndIf
      Wend
      If Var
        Line = Left(Line, n - Len(Var) - 2) + Chr(34) + PeekS(GetEllement(*StringList, Val(Var))) + Chr(34) + Mid(Line, n + 1)
        n + Len(PeekS(GetEllement(*StringList, Val(Var)))) - Len(Var)
      EndIf
    EndIf
  Next n
  ProcedureReturn Line
EndProcedure

Procedure.s RemoveComment(Line.s) ;suprime les commentaires
  Protected n
  For n = 1 To Len(Line)
    Select Mid(Line, n, 1)
      Case "'"
        n + 2
      Case Chr(34)
        n + 1
        While n <= Len(Line)
          If Mid(Line, n, 1) = Chr(34)
            Break
          EndIf
          n + 1
        Wend 
      Case ";"
        n - 1
        Break
    EndSelect
  Next n
  ProcedureReturn Left(Line, n)
EndProcedure

Procedure.s ReplaceChar(Line.s)
  Protected n, Count
  For n = 1 To Len(Line)
    Select Mid(Line, n, 1)
      Case Chr(34)
        If count
          Count = #False
        Else
          Count = #True
        EndIf
      Case "'"
        If Not Count
          Line = Left(Line, n - 1) + Str(Asc(Mid(Line, n+1, 1))) + Mid(Line, n + 3)
        EndIf
    EndSelect
  Next n
  ProcedureReturn Line
EndProcedure

Procedure.s FormatText(Line.s, *String.Array)
  Line = RemoveComment(Line)
  Line = ReplaceChar(Line)
  Line = StockString(Line, *String)
  Line = ReplaceString(Line, Chr(9)," ")
  While FindString(Line, "  ", 1)
    Line = ReplaceString(Line, " " + " ", " ")
  Wend
  Protected CharList.s = "+-=/\%|!~,()<>.:", n
  For n=1 To Len(CharList)
    Line = ReplaceString(Line, Mid(CharList, n, 1) + " ", Mid(CharList, n, 1))
    Line = ReplaceString(Line, " " + Mid(CharList, n, 1), Mid(CharList, n, 1))
  Next n
  Line = ReplaceString(Line, "* ","*")

  ProcedureReturn Trim(Line)
EndProcedure

Procedure IsAcceptedBeforePointer(Char.s)
  Select Char
    Case "(", ",", "+", "-", "/", "*", "|", "%", " ", "=", ">", "<"
      ProcedureReturn #True
    Default
      ProcedureReturn #False
  EndSelect
EndProcedure

Procedure IsAcceptedForAPointer(Char.s)
  Select Asc(Char)
    Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_', '\'
      ProcedureReturn #True
    Default
      ProcedureReturn #False
  EndSelect
EndProcedure

;=================
;-a coriger
;=================
Procedure checkSyntax(Line.s)
;   If Not (CountString(Line, Chr('"'))%2 =0) Or Not (CountString(Line, Chr('(')) = CountString(Line, Chr(')')))
;     ProcedureReturn #False
;   EndIf
  ProcedureReturn #True
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 101
; FirstLine = 66
; Folding = --
; EnableXP