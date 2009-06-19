Procedure FindStringNotInString(Txt.s , TxtToFind.s, char, position = 1)
	position = FindString(Txt , TxtToFind, position)
	While position
		If CountString(Left(Txt, position), Chr(char)) % 2 = 0
			ProcedureReturn position
		EndIf
		position = FindString(Txt , TxtToFind, position + 1)
	Wend
	ProcedureReturn 0
EndProcedure

Procedure.s GetTemporayFile(name.s)
	Protected File.s = GetTemporaryDirectory() , n
	While Not FileSize(File + name + Str(n) + ".pb") = -1
		n + 1
	Wend
	ProcedureReturn File + name + Str(n) + ".pb"
EndProcedure

Procedure.s GetTemporayDirectory(name.s)
	Protected File.s = GetTemporaryDirectory() , n
	While FileSize(File + name + Str(n)) = -2
		n + 1
	Wend
	ProcedureReturn File + name + Str(n) + "/"
EndProcedure

#Format_PossibleCharBeforePointer = " if not xor and or to "

Procedure.s CheckAfterPointer(Line.s)
	While FindString(Line , "* ", 1)
		Line = ReplaceString(Line, "* ", "*")
	Wend
	ProcedureReturn Line
EndProcedure

#Format_PossibleCharBeforeSyntax = "protected global static define procedurereturn select for while until debug case"

Procedure.s CheckBeforePointer(Line.s)
	Protected n, i, Temp.s
	If FindString(LCase(Line), "define.", 1) = 1
		ProcedureReturn StringField(Line, 1, " ") + " " + CheckBeforePointer(Mid(Line, FindString(Line, " ", 1) + 1))
	EndIf
	For n = 1 To CountString(#Format_PossibleCharBeforeSyntax, " ") + 1
		If FindString(LCase(Line), StringField(#Format_PossibleCharBeforeSyntax, n, " ") + " ", 1) = 1
			ProcedureReturn StringField(Line, 1, " ") + " " + CheckBeforePointer(Mid(Line, FindString(Line, " ", 1) + 1))
		EndIf
	Next n
	n = FindString(Line , " *", 1)
	While n
		Temp = ""
		For i = n - 1 to 1 Step -1
			If (Mid(Line, i, 1) <"a" Or Mid(Line, i, 1) >"z") And  (Mid(Line, i, 1) <"A" Or Mid(Line, i, 1) >"Z")
				Break
			EndIf
			Temp = Mid(Line, i, 1) + Temp
		Next
		If Temp
			If Not FindString(#Format_PossibleCharBeforePointer, " " + LCase(Temp) + " ", 1)
				Line = Left(Line , n - 1) + "*" + Mid(Line, n + 2)
				n - 1
			Endif
		EndIf
		n = FindString(Line , " *",  n + 1)
	Wend
	ProcedureReturn Line
EndProcedure

Procedure.s CheckPointer(Line.s)
	If Not FindString(Line, "*", 1)
		ProcedureReturn Line
	EndIf
	Line = CheckBeforePointer(Line)
	Line = CheckAfterPointer(Line)
	ProcedureReturn Line
EndProcedure


#Format_CharList = "+-=/\%|!~,()<>.:"
Procedure.s FormatText(Line.s, *String.Array)
	Protected n
	Line = RemoveComment(Line)
	Line = ReplaceChar(Line)
	Line = StockString(Line, *String)
	Line = ReplaceString(Line, Chr(9)," ")
	While FindString(Line, "  ", 1)
		Line = ReplaceString(Line, " " + " ", " ")
	Wend
	For n=1 To Len(#Format_CharList)
		Line = ReplaceString(Line, Mid(#Format_CharList, n, 1) + " ", Mid(#Format_CharList, n, 1))
		Line = ReplaceString(Line, " " + Mid(#Format_CharList, n, 1), Mid(#Format_CharList, n, 1))
	Next n
	ProcedureReturn CheckPointer(Trim(Line))
EndProcedure

Procedure.s StockString(Line.s, *StringList.Array)
	Protected n = FindString(Line, Chr(34), 1), *String, Text.s
	While n
		Text = Mid(Line, n + 1, FindString(Line, Chr(34), n + 1) - n - 1)
		*String = AllocateMemory(Len(Text) + 1)
		PokeS(*String,Text)
		
		*StringList.AddElement(*String)
		FindString(Line, Chr(34), 1)
		Line = Left(Line, n - 1) + "$" + Str(*StringList.CountElement()) + "$" + Mid(Line, FindString(Line, Chr(34), n + 1) + 1)
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
				Line = Left(Line, n - Len(Var) - 2) + Chr(34) + PeekS(*StringList.GetElement(Val(Var))) + Chr(34) + Mid(Line, n + 1)
				n + Len(PeekS(*StringList.GetElement(Val(Var)))) - Len(Var)
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


Procedure IsAcceptedBeforePointer(Char.s)
	Select Char
		Case "(", ",", "+", "-", "/", "*", "|", "%", " ", "=", ">", "<", "@"
			ProcedureReturn #True
		Default
			ProcedureReturn #False
	EndSelect
EndProcedure

Procedure IsCorrectClass(Text.s)
	Protected char.s, n
	Text = LCase(Text)
	If Not Text
		ProcedureReturn #False
	EndIf
	char = Mid(Text, 1, 1)
	If char < "a" Or char > "z"
		ProcedureReturn #False
	EndIf
	For n = 2 To Len(Text)
		char = Mid(Text, n, 1)
		If (char < "a" Or char > "z") And (char < "0" Or char > "9") And char <> "_"
			ProcedureReturn #False
		EndIf
	Next n
	ProcedureReturn #True
EndProcedure

Procedure IsAcceptedForAPointer(Char.s)
	Select Asc(Char)
		Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_', '\'
			ProcedureReturn #True
		Default
			ProcedureReturn #False
	EndSelect
EndProcedure

Procedure IsAcceptedForName(Char.s)
	Select Asc(Char)
		Case 'A' To 'Z', 'a' To 'z', '0' To '9', '_', '\'
			ProcedureReturn #True
		Default
			ProcedureReturn #False
	EndSelect
EndProcedure

Procedure IsNumber(Char.s)
	Select Asc(Char)
		Case '0' To '9'
			ProcedureReturn #True
		Default
			ProcedureReturn #False
	EndSelect
EndProcedure

Procedure.s GetAttributNumber(Text.s, n.l)
	If n <= 0
		ProcedureReturn ""
	EndIf
	Protected i.l, CountP.l, Start.l = 1, Count.l = 1
	For i = 1 To Len(Text)
		Select Mid(Text, i, 1)
			Case "("
				CountP + 1
			Case ")"
				CountP - 1
			Case ","
				If CountP = 0
					Count + 1
					If Count = n
						Start = i + 1
					ElseIf Count = n + 1
						ProcedureReturn Mid(Left(Text, i - 1), Start)
					EndIf
				EndIf
		EndSelect
	Next i
	ProcedureReturn Mid(Text, Start)
EndProcedure	
