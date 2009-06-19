Class Procedure Extends LineCode
	Name.s
	Type.s
	ProcedureMode.b
	*Attribut.Array = New Array()
	*LocalV.Array = New Array()
	*Body.Array = New Array()
	
EndClass

Procedure LoadProcedure(n)
	Protected *Line.LineCode = *this\LocalText.GetElement(n), i
	Protected *ProcedureP.Precompiler::Procedure = New Precompiler::Procedure(), Countp.l
	*ProcedureP\File = *Line\File
	*ProcedureP\Line = *Line\Line
	*this\Procedure.AddElement(*ProcedureP)
	Protected Temp.s = StringField(*Line\Text, 1, " "), Count.l
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
	*ProcedureP\Name = StringField(*Line\Text, 1, "(")
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




; Procedure Procedure_WriteDeclarations(*ProcedureList.Array , FileID, BOM)
;   Protected n, *ProcedureP.Procedure, Text.s, i
;   For n = 1 To CountEllement(*ProcedureList)
;     *ProcedureP = GetEllement(*ProcedureList, n)
;     Select *ProcedureP\ProcedureMode
;       Case #Mode_Procedure
;         Text = "Declare"
;       Case #Mode_ProcedureC
;         Text = "DeclareC"
;       Case #Mode_ProcedureDLL
;         Text = "DeclareDLL"
;       Case #Mode_ProcedureCDLL
;         Text = "DeclareCDLL"
;     EndSelect
;     Text + "."
;     Select LCase(*ProcedureP\Type)
;       Case "i", "l",  "s",  "b",  "f",  "d",  "c",  "q",  "w"
;           Text + *ProcedureP\Type
;       Default
;           Text + "i"
;     EndSelect
;     Text + " " + *ProcedureP\Name + "("
;     For i = 1 To  CountEllement(*ProcedureP\Atribut)
;       If i >1
;         Text + ","
;       EndIf
;       Text + ProcedureAttribut_GetDeclaration(GetEllement(*ProcedureP\Atribut, i))
;     Next  i
;     Text + ")"
;     WriteStringN(FileID, Text, BOM)
;   Next n
; EndProcedure
;
; Procedure Procedure_WriteBody(*ProcedureList.Array , FileID, BOM)
;   Protected n, *ProcedureP.Procedure, Text.s, i, *Attribut.Attribut
;   For n = 1 To CountEllement(*ProcedureList)
;     *ProcedureP = GetEllement(*ProcedureList, n)
;     Select *ProcedureP\ProcedureMode
;       Case #Mode_Procedure
;         Text = "Procedure"
;       Case #Mode_ProcedureC
;         Text = "ProcedureC"
;       Case #Mode_ProcedureDLL
;         Text = "ProcedureDLL"
;       Case #Mode_ProcedureCDLL
;         Text = "ProcedureCDLL"
;     EndSelect
;     Text + "."
;     Select LCase(*ProcedureP\Type)
;       Case "i", "l",  "s",  "b",  "f",  "d",  "c",  "q",  "w"
;           Text + *ProcedureP\Type
;       Default
;           Text + "i"
;     EndSelect
;     Text + " " + *ProcedureP\Name + "("
;     For i = 1 To  CountEllement(*ProcedureP\Atribut)
;       If i >1
;         Text + ","
;       EndIf
;       Text + ProcedureAttribut_GetDeclaration(GetEllement(*ProcedureP\Atribut, i))
;     Next  i
;     Text + ")"
;     WriteStringN(FileID, Text, BOM)
;     For i = 1 To CountEllement(*ProcedureP\LocalV)
;       *Attribut = GetEllement(*ProcedureP\LocalV, i)
;       WriteStringN(FileID, "Protected " + *Attribut\Name + "." + *Attribut\Type, BOM)
;     Next i
;     WriteStringN(FileID, *ProcedureP\Body, BOM)
;     WriteStringN(FileID, "EndProcedure", BOM)
;   Next n
; EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 65
; FirstLine = 30
; Folding = -
; EnableXP
