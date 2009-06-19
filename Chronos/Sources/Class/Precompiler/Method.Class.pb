Class Method Extends Precompiler::Procedure
	ClassName.s
	Declared.b
	
	Procedure.s GetDeclaration(Attributs.s)
		Protected n.l, i.l, j.l
		Protected *Attribut.Precompiler::Attribut
		Protected Found.b
		Protected Final.s, Number.s, Text.s
		If *this\Declared
			For n = 1 to *this\Attribut.CountElement()
				*Attribut = *this\Attribut.GetElement(n)
				Text = *Attribut\Name
				Found = #False
				j = 1
				While j <= Len(Text)
					If Mid(Text, j, 1) = "$"
						Number = ""
						For i = j + 1 to Len(Text)
							If IsNumber(Mid(Text, i, 1))
								Number + Mid(Text, i, 1)
							Else
								Break
							EndIf
						Next i
						If Not Number = ""
							If i <= Len(Text) And Mid(Text, j, 1) = "$"
								Found = #False
							Else
								Found = #True
							EndIf
						EndIf
						If Found = #True
							Text = Left(Text, j - 1) + GetAttributNumber(Attributs, Val(Number)) + Mid(Text, i)
							Found = #False
						EndIf
					EndIf
					j + 1
				Wend
				If Final
					Final + ","
				EndIf
				Final + Text
			Next n
			ProcedureReturn *this\Name + "(" + Final + ")"
		Else
			ProcedureReturn *this\Name + "(" + Attributs + ")"
		EndIf
	EndProcedure
EndClass

Procedure LoadMethod(n, *Class.Precompiler::Class)
	Protected *Line.LineCode = *this\LocalText.GetElement(n), i
	Protected *ProcedureP.Precompiler::Method = New Precompiler::Method(), Countp.l
	Protected *Attribut.Precompiler::Attribut
	Protected *CAttribut.Precompiler::ClassAttribut
	Protected *MAttribut.Precompiler::Attribut
	Protected Type.l, Char.s, Temp.s
	*ProcedureP\Attribut.Array = New Array()
	*ProcedureP\LocalV.Array = New Array()
	*ProcedureP\Body.Array = New Array()
	If LineIs(*Line\Text) = #Declare
		*ProcedureP\Declared = #True
		If LCase(Left(*Line\Text, len("static"))) = "static"
			*Class\StaticMethod.AddElement(*ProcedureP)
			Type = 2
		Else
			Type = 1
		EndIf
		*Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
		*ProcedureP\ClassName = StringField(*Line\Text, 1, " ")
		*Line\Text = Mid(*Line\Text, FindString(LCase(*Line\Text), " as ", 1) + 4)
		*ProcedureP\Name = StringField(*Line\Text, 1, "(")
		If Type = 1
			If LCase(*ProcedureP\ClassName) = LCase(*Class\Name)
				*Class\Constructor.AddElement(*ProcedureP)
			Else
				*Class\Method.AddElement(*ProcedureP)
			EndIf
		EndIf
		*Line\Text = Mid(*Line\Text, FindString(*Line\Text, "(", 1) + 1)
		*Line\Text = Left(*Line\Text, Len(*Line\Text) - 1)
		For i = 1 To Len(*Line\Text)
			Char = Mid(*Line\Text, i, 1)
			Select Char
				Case ","
					If Countp = 0
						*MAttribut = New Precompiler::Attribut()
						*MAttribut\Name = Temp
						*MAttribut\File = *Line\File
						*MAttribut\Line = *Line\Line
						*ProcedureP\Attribut.AddElement(*MAttribut)
						Temp = ""
						Char = ""
					EndIf
				case "("
					Countp+1
				case ")"
					Countp-1
			EndSelect
			Temp + Char
		next i
		*MAttribut = New Precompiler::Attribut()
		*MAttribut\Name = Temp
		*MAttribut\File = *Line\File
		*MAttribut\Line = *Line\Line
		*ProcedureP\Attribut.AddElement(*MAttribut)
		ProcedureReturn n
	EndIf
	
	If LCase(Left(*Line\Text, len("static"))) = "static"
		*Line\Text = Mid(*Line\Text, 7)
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
	Temp = StringField(*Line\Text, 1, " ")
	Protected Count.l
	If FindString(Temp, ".", 1)
		*ProcedureP\Type = ReplaceString(StringField(Temp, 2, "."), "::", "_")
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
