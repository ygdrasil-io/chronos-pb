Enumeration 1
	#None
	#Procedure
	#StaticProcedure
	#Class
	#EndClass
	#Structure
	#EndStructure
	#FileInclude
	#Constant
	#Global
	#Define
	#EndProcedure
	#Enumeration
	#EndEnumeration
	#ImportInclude
	#Macro
	#EndMacro
	#CompilerCondition
	#CompilerEndCondition
	#Protected
EndEnumeration

Enumeration 1
	#Mode_Procedure
	#Mode_ProcedureC
	#Mode_ProcedureDLL
	#Mode_ProcedureCDLL
EndEnumeration

#Procedure_ModeList = "procedure procedurec proceduredll procedurecdll"

Procedure LineIs(Line.s)
	Line = LCase(Line)
	Protected n, Temp.s = StringField(Line, 1, " ")
	Select Asc(Mid(Line, 1, 1))
		Case '#'
			ProcedureReturn #Constant
		Case 'a' To 'z', 'A' To 'Z'
			If Temp = "compilercondition"
				ProcedureReturn #CompilerCondition
			EndIf
			If Temp = "compilerendcondition"
				ProcedureReturn #CompilerEndCondition
			EndIf
			If Left(Line, Len("Static Procedure")) = "static procedure"
				If Mid(Line, Len("Static Procedure") + 1, 1) = " " Or Mid(Line, Len("Static Procedure") + 1, 1) = "."
					ProcedureReturn #StaticProcedure
				EndIf
			EndIf
			If Left(Line, Len("Define")) = "define"
				If Mid(Line, Len("Define") + 1, 1) = " " Or Mid(Line, Len("Define") + 1, 1) = "."
					ProcedureReturn #Define
				EndIf
			EndIf
			If Left(Line, Len("Procedure")) = "procedure"
				If FindString(Temp, ".", 1)
					Temp = StringField(Temp, 1, ".")
				EndIf
				For n = 1 To CountString(#Procedure_ModeList, " ") + 1
					If Temp = StringField(#Procedure_ModeList, n, " ")
						ProcedureReturn #Procedure
					EndIf
				Next n
			EndIf
			If Temp = "endprocedure"
				ProcedureReturn #EndProcedure
			EndIf
			If Temp = "global"
				ProcedureReturn #Global
			EndIf
			If Temp = "structure"
				ProcedureReturn #Structure
			EndIf
			If Temp = "endstructure"
				ProcedureReturn #EndStructure
			EndIf
			If Temp = "includefile" Or Temp = "xincludefile"
				ProcedureReturn #FileInclude
			EndIf
			If Temp = "includeimport" Or Temp = "xincludeimport"
				ProcedureReturn #ImportInclude
			EndIf
			If Temp = "class"
				ProcedureReturn #Class
			EndIf
			If Temp = "endclass"
				ProcedureReturn #EndClass
			EndIf
			If Temp = "protected"
				ProcedureReturn #Protected
			EndIf
			If Temp = "enumeration"
				ProcedureReturn #Enumeration
			EndIf
			If Temp = "endenumeration"
				ProcedureReturn #EndEnumeration
			EndIf
			If Temp = "macro"
				ProcedureReturn #Macro
			EndIf
			If Temp = "endmacro"
				ProcedureReturn #EndMacro
			EndIf
	EndSelect
	ProcedureReturn #None
EndProcedure

Class Precompiler
	Class Element Extends LineCode
		PrecompilerCondition.s
		CFile.s
		Cline.l
		Procedure Free()
			FreeMemory(*this)
		EndProcedure
	EndClass
	;-imports
	IncludeFile "Constant.Class.pb"
	IncludeFile "attribut.Class.pb"
	IncludeFile "StructureAttribut.Class.pb"
	IncludeFile "Structure.Class.pb"
	IncludeFile "ProcedureAttribut.Class.pb"
	IncludeFile "Procedure.Class.pb"
	IncludeFile "Variable.Class.pb"
	IncludeFile "Method.Class.pb"
	IncludeFile "ClassAttribut.Class.pb"
	IncludeFile "Class.Class.pb"
	IncludeFile "Macro.Class.pb"
	
	*Class.Array = New Array()
	*Procedure.Array = New Array()
	*LocalV.Array = New Array()
	*GlobalV.Array = New Array()
	*LocalText.Array = New Array()
	*Constant.Array = New Array()
	*Macro.Array = New Array()
	*Structure.Array = New Array()
	*String.Array = New Array()
	*Body.Array = New Array()
	*Compiler.Compiler
	IncludeFileX.s
	IncludeImportX.s
	Error.b
	
	Procedure getLine(n)
		ProcedureReturn *this\LocalText.GetElement(n)
	EndProcedure
	
	Procedure restart(*Compiler.Compiler)
		Protected n, *Line.LineCode
		Protected *Struct.Precompiler::Structure
		*this\Class.RemoveAll()
		*this\Procedure.RemoveAll()
		*this\LocalV.RemoveAll()
		*this\GlobalV.RemoveAll()
		For n = 1 To *this\LocalText.CountElement()
			*Line = *this\LocalText.GetElement(n)
			*Line.Free()
		Next n
		*this\LocalText.RemoveAll()
		For n = 1 To *this\Body.CountElement()
			*Line = *this\Body.GetElement(n)
			*Line.Free()
		Next n
		*this\Body.RemoveAll()
		*this\Constant.RemoveAll()
		*this\Macro.RemoveAll()
		For n = 1 To *this\Structure.CountElement()
			*Struct = *this\Structure.GetElement(n)
			*Struct.Free()
		Next n
		*this\Structure.RemoveAll()
		*this\String.RemoveAll()
		*this\IncludeImportX = ""
		*this\IncludeFileX = ""
		*this\Error =  #False
		*this\Compiler = *Compiler
	EndProcedure
	
	Procedure start(File.s)
		Protected LigneNbr, CompilerCondition.s
		Protected FileID = OpenFile(#PB_Any, File)
		If Not FileID
			*System\IHM.WriteMessage("Cant read file : " + File)
			ProcedureReturn  #False
		Else
			*System\IHM.WriteMessage("Start to read:"+File)
		EndIf
		Protected BOM.b = ReadStringFormat(FileID), Line.s, Temp.s, start, val.l
		Protected LineNbr = 1
		While Not Eof(FileID)
			Line = ReadString(FileID, BOM)
			Line = FormatText(Line, *this\String)
			If Line
				Select LineIs(Line)
					Case #ImportInclude
						Temp = PeekS(*this\String.GetElement(Val(StringField(Line, 2, "$"))))
						Temp = MainPath + "API/" + ReplaceString(Temp, ".", "/") + ".Class.pb"
						If FindString(*this\IncludeImportX, LCase(Temp) + ";", 1) = #Null
							*this\IncludeImportX + LCase(Temp) + ";"
							If FileSize(Temp) < 0
								*System.CodeError(File, LineNbr, "File Not Found " + File)
								ProcedureReturn #False
							EndIf
							If Not *this.start(Temp)
								ProcedureReturn #False
							EndIf
						Else
							*System\IHM.WriteMessage("Import ingore " + Temp)
						EndIf
					Case #FileInclude
						Temp = PeekS(*this\String.GetElement(Val(StringField(Line, 2, "$"))))
						If FileSize(GetPathPart(File) + Temp) >= 0
							If Not *this.start(GetPathPart(File) + Temp) ;chemin relatif
								ProcedureReturn #False
							EndIf
						ElseIf FileSize(Temp) >= 0
							If Not *this.start(Temp) ;chemin absolue
								ProcedureReturn #False
							EndIf
						Else
							*System.CodeError(File, LineNbr, "File Not Found " + File) ;n'existe pas
							ProcedureReturn #False
						EndIf
					Default
						If Line
							*this\LocalText.AddElement(New LineCode(Line, File, LineNbr))
						EndIf
				EndSelect
			EndIf
			LineNbr + 1
		Wend
		CloseFile(FileID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure FormatCode()
		Protected *Line.LineCode
		Protected n, *StructureP.Precompiler::Structure, i, *Attribut.Precompiler::Attribut
		Protected *Constant.Precompiler::Constant
		Protected *Variable.Precompiler::Variable
		Protected *PProcedure.Precompiler::Procedure
		Protected *PAttribut.Precompiler::ProcedureAttribut
		Protected *PMacro.Precompiler::Macro
		Protected *SAttribut.Precompiler::StructureAttribut
		For n = 1 To *this\LocalText.CountElement()
			*Line = *this\LocalText.GetElement(n)
			*Line.Free()
		Next n
		*this\LocalText.RemoveAll()
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Code generated by Chronos                                 ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode("", "", #Null))
		*this\LocalText.AddElement(New LineCode("EnableExplicit ;Variable declaration enable", "", #Null))
		*this\LocalText.AddElement(New LineCode("", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Macro                                                     ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		For n = 1 To *this\Macro.CountElement()
			*PMacro = *this\Macro.GetElement(n)
			*this\LocalText.AddElement(*PMacro)
			For i = 1 To *PMacro\Body.CountElement()
				*this\LocalText.AddElement(*PMacro\Body.GetElement(i))
			Next i
			*this\LocalText.AddElement(New LineCode("EndMacro", *PMacro\File, *PMacro\Line))
		Next n
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Constantes                                                ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode("", "", #Null))
		For n = 1 To *this\Constant.CountElement()
			*Constant = *this\Constant.getElement(n)
			*Constant\Value = ReleaseString(*Constant\Value, *this\String)
			If *Constant\PrecompilerCondition
				*this\LocalText.AddElement(New LineCode("CompilerIf " + *Constant\PrecompilerCondition, *Constant\CFile, *Constant\CLine))
			EndIf
			*this\LocalText.AddElement(New LineCode(*Constant\Name+"="+*Constant\Value, *Constant\File, *Constant\Line))
			If *Constant\PrecompilerCondition
				*this\LocalText.AddElement(New LineCode("CompilerEndIf", "", #Null))
			EndIf
		Next n
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Structures                                                ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		For n = 1 To *this\Structure.CountElement()
			*this\LocalText.AddElement(New LineCode("", "", #Null))
			*StructureP = *this\Structure.GetElement(n)
			If *StructureP\Extend
				*StructureP\Extend = ReplaceString(*StructureP\Extend, "::", "_")
				If Not *this.GetStructure(*StructureP\Extend) And Not *this\Compiler.GetStructure(*StructureP\Extend)
					*System.CodeError(*StructureP\File, *StructureP\Line, "Structure " + *StructureP\Extend + " extending " + *StructureP\Name + " not found")
					ProcedureReturn #False
				EndIf
			EndIf
			*Line = New LineCode("Structure " + *StructureP\Name, *StructureP\File, *StructureP\Line)
			*this\LocalText.AddElement(*Line)
			If *StructureP\Extend
				*Line\Text + " Extends " + *StructureP\Extend
			EndIf
			For i = 1 To *StructureP\Attribut.CountElement()
				*SAttribut = *StructureP\Attribut.GetElement(i)
				*this\LocalText.AddElement(New LineCode(Chr(9) + *SAttribut.GetDeclaration(), *SAttribut\File, *SAttribut\Line))
			Next i
			*this\LocalText.AddElement(New LineCode("EndStructure", *StructureP\File, *StructureP\Line))
		Next n
		;-Variables
		;{
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Variables                                                 ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		;Global
		For n = 1 To *this\GlobalV.CountElement()
			*Variable = *this\GlobalV.getElement(n)
			*this\LocalText.AddElement(New LineCode("Global " + *Variable\Name + "."+*Variable\Type, *Variable\File, *Variable\Line))
		Next n
		;Define
		For n = 1 To *this\LocalV.CountElement()
			*Variable = *this\LocalV.getElement(n)
			*this\LocalText.AddElement(New LineCode("Define " + *Variable\Name + "."+*Variable\Type, *Variable\File, *Variable\Line))
		Next n
		;}
		;-Procedure
		;{
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Declare                                                   ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		For n = 1 To *this\Procedure.CountElement()
			*PProcedure = *this\Procedure.getElement(n)
			*Line = New LineCode("", *PProcedure\File, *PProcedure\Line)
			Select *PProcedure\ProcedureMode
				Case #Mode_Procedure
					*Line\Text = "Declare"
				Case #Mode_ProcedureC
					*Line\Text = "DeclareC"
				Case #Mode_ProcedureDLL
					*Line\Text = "DeclareDLL"
				Case #Mode_ProcedureCDLL
					*Line\Text = "DeclareCDLL"
			EndSelect
			*Line\Text + "."
			Select LCase(*PProcedure\Type)
				Case "i", "l",  "s",  "b",  "f",  "d",  "c",  "q",  "w"
					*Line\Text + *PProcedure\Type
				Default
					*Line\Text + "i"
			EndSelect
			*Line\Text + " " + *PProcedure\Name + "("
			For i = 1 To  *PProcedure\Attribut.CountElement()
				If i >1
					*Line\Text + ","
				EndIf
				*PAttribut = *PProcedure\Attribut.GetElement(i)
				*PAttribut\Type = ReplaceString(*PAttribut\Type, "::", "_")
				*PAttribut\DefaultValue = ReleaseString(*PAttribut\DefaultValue, *This\String)
				*Line\Text + *PAttribut.GetDeclaration()
			Next  i
			*Line\Text + ")"
			*this\LocalText.AddElement(*Line)
		Next n
		
		
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Procedures                                                ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		For n = 1 To *this\Procedure.CountElement()
			*PProcedure = *this\Procedure.getElement(n)
			*Line = New LineCode("", *PProcedure\File, *PProcedure\Line)
			Select *PProcedure\ProcedureMode
				Case #Mode_Procedure
					*Line\Text = "Procedure"
				Case #Mode_ProcedureC
					*Line\Text = "ProcedureC"
				Case #Mode_ProcedureDLL
					*Line\Text = "ProcedureDLL"
				Case #Mode_ProcedureCDLL
					*Line\Text = "ProcedureCDLL"
			EndSelect
			*Line\Text + "."
			Select LCase(*PProcedure\Type)
				Case "i", "l",  "s",  "b",  "f",  "d",  "c",  "q",  "w"
					*Line\Text + *PProcedure\Type
				Default
					*Line\Text + "i"
			EndSelect
			*Line\Text + " " + *PProcedure\Name + "("
			For i = 1 To  *PProcedure\Attribut.CountElement()
				If i >1
					*Line\Text + ","
				EndIf
				*PAttribut = *PProcedure\Attribut.GetElement(i)
				*Line\Text + *PAttribut.GetDeclaration()
			Next  i
			*Line\Text + ")"
			*this\LocalText.AddElement(*Line)
			For i = 1 To *PProcedure\LocalV.CountElement()
				*PAttribut = *PProcedure\LocalV.GetElement(i)
				*PAttribut\Type = ReplaceString(*PAttribut\Type, "::", "_")
				*this\LocalText.AddElement(New LineCode("Protected "+ *PAttribut\Name + "." + *PAttribut\Type, *PAttribut\File, *PAttribut\Line))
			Next i
			For i = 1 To  *PProcedure\Body.CountElement()
				*Line = *PProcedure\Body.GetElement(i)
				If Not *this.FormatText(*Line, *PProcedure\LocalV, *PProcedure\Attribut)
					ProcedureReturn #False
				EndIf
				*Line\Text = Chr(9) + *Line\Text
				*this\LocalText.AddElement(*Line)
			Next i
			*this\LocalText.AddElement(New LineCode("EndProcedure", *PProcedure\File, *PProcedure\Line))
		Next n
		
		
		
		
		;}
		;-Body
		;{
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode("; Body                                                      ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";                                                           ;", "", #Null))
		*this\LocalText.AddElement(New LineCode(";===========================================================;", "", #Null))
		For n = 1 To *this\Body.CountElement()
			*Line = *this\Body.getElement(n)
			If Not *this.FormatText(*Line)
				ProcedureReturn #False
			EndIf
			*this\LocalText.AddElement(New LineCode(*Line\Text, *Line\File, *Line\Line))
		Next n
		;}
		ProcedureReturn #True
	EndProcedure
	
	Procedure CheckConstructor(*Line.LineCode)
		Protected Text.s = LCase(*Line\Text), n = FindString(Text, "new ", 1)
		Protected Temp.s
		While n
			If n = 1 Or IsAcceptedBeforePointer(Mid(Text, n - 1, 1))
				temp = StringField(Mid(*Line\Text, n + 4), 1, "(")
				If IsCorrectClass(temp)
					If Not *this.GetClass(temp)
						*System.CodeError(*Line\File, *Line\Line, "Class " + temp + " not found")
						ProcedureReturn #False
					Else
						*Line\Text = Left(*Line\Text, n + 2) + "_" + Mid(*Line\Text, n + 4)
					EndIf
				EndIf
			EndIf
			n = FindString(Text, "new ", n + 1)
		Wend
		ProcedureReturn #True
	EndProcedure
	
	Procedure FormatText(*Line.LineCode, *Variable.Array = #Null, *Attribut.Array = #Null)
		*Line\Text = ReplaceString(*Line\Text, "::", "_")
		If Not *this.CheckConstructor(*Line)
			ProcedureReturn #False
		EndIf
		If *Variable = #Null
			*Variable = *this\LocalV
		EndIf
		If Not *this.FormatMethod(*Line, *Variable, *Attribut)
			ProcedureReturn #False
		EndIf
		*Line\Text = ReleaseString(*Line\Text, *this\String)
		ProcedureReturn #True
	EndProcedure
	
	Procedure FormatMethod(*Line.LineCode, *Variable.Array, *Attribut.Array = #Null)
		Protected *Var.Precompiler::Variable, Char.s, StartPointer.l, EndPointer.l, EndMethod.l, EndAttribut.l, i.l, n.l
		Protected Pointer.s, CountP.l, Var.s, Type.s, *Class.Precompiler::Class, Method.s, *Method.Precompiler::Method, Ending.l, AttributList.s
		Protected *NewLine.LineCode
		For n = 1 To Len(*Line\Text)
			If Mid(*Line\Text ,n, 1) = "*"
				StartPointer = n
				If n = 1 Or (n > 1 And IsAcceptedBeforePointer(Mid(*Line\Text ,n - 1, 1)))
					n + 2
					Char = Mid(*Line\Text ,n, 1)
					For n = n To  Len(*Line\Text)
						Char = Mid(*Line\Text ,n, 1)
						If Not IsAcceptedForAPointer(Char)
							Break
						EndIf
					Next n
					If n = Len(*Line\Text) + 1;fin de ligne
						Break
					EndIf
					Type = ""
					While Char = "." ;on a trouvé soit une structure soit une methode
						EndPointer = n
						n + 1
						For n = n To  Len(*Line\Text)
							Char = Mid(*Line\Text ,n, 1)
							If Not IsAcceptedForAPointer(Char)
								Break
							EndIf
						Next n
						If n = Len(*Line\Text) + 1;fin de ligne
							Break
						EndIf
						If Mid(*Line\Text ,n, 1) = "(" ;c'est une methode
							EndMethod = n
							Method = Mid(*Line\Text, EndPointer + 1, EndMethod - EndPointer - 1)
							If Type = "" ;si on connait deja le type -> methode imbriqué *p.m1().m2()...
								Pointer = Mid(*Line\Text, StartPointer, EndPointer - StartPointer)
								;PrintN(Pointer)
								;on recupere le type
								If FindString(Pointer, "\", 1)
									Var = StringField(Pointer, 1, "\")
								Else
									Var = Pointer
								EndIf
								*Var = #Null
								;PrintN("wooow")
								If Not *Attribut = #Null
									;PrintN("attribut")
									*Var = Precompiler::Static::GetVariable(*Attribut, Var)
								EndIf
								If Not *Var
									;PrintN("local")
									*Var = Precompiler::Static::GetVariable(*Variable, Var)
								EndIf
								If Not *Var
									;PrintN("global")
									*Var= Precompiler::Static::GetVariable(*this\GlobalV, Var)
								EndIf
								If Not *Var
									*System.CodeError(*Line\File, *Line\Line, Var + " Not found")
									ProcedureReturn #False
								EndIf
								;on recupere le type du pointeur
								Type = *Var\type
								Var = Pointer
								For i = 2 To CountString(Pointer, "\") + 1
									Type = *this.GetTypeFromStructureField(Type, StringField(Pointer, i, "\"))
									If Type = ""
										*System.CodeError(*Line\File, *Line\Line, "Type " + StringField(Pointer, i, "\") + " not found from " + *Var\type)
										ProcedureReturn #False
									EndIf
								Next i
							EndIf
							;on recupere la classe
							*Class = *this.GetClass(Type)
							If Not *Class
								*System.CodeError(*Line\File, *Line\Line, Type + " class not found")
								ProcedureReturn #False
							EndIf
							;on recupere la methode
							*Method = *Class.GetMethod(Method)
							If Not *Method
								*System.CodeError(*Line\File, *Line\Line, Method + " method not found")
								ProcedureReturn #False
							EndIf
							;on recupere les attributs
							CountP = 0
							For n = n To Len(*Line\Text)
								Select Mid(*Line\Text, n, 1)
									Case "("
										;PrintN("+")
										CountP + 1
									Case ")"
										;PrintN("-")
										CountP - 1
										If CountP = 0
											Break
										EndIf
								EndSelect
							Next n
							If n = Len(*Line\Text) + 1
								*System.CodeError(*Line\File, *Line\Line, "syntax error")
								ProcedureReturn #False
							EndIf
							Ending = n
							AttributList = Trim(Mid(*Line\Text, EndMethod + 1, Ending - EndMethod - 1))
							If AttributList
								If *NewLine
									*NewLine.Free()
								EndIf
								*NewLine = New LineCode(AttributList, *Line\File, *Line\Line)
								If Not *this.FormatMethod(*NewLine, *Variable, *Attribut)
									*NewLine.Free()
									ProcedureReturn #False
								EndIf
								AttributList = "," + *NewLine\Text
							EndIf
							AttributList = Pointer + AttributList
							Pointer = Type + "_" + Method + "(" + AttributList + ")"
							n + 1
							*Line\Text = Left(*Line\Text, StartPointer - 1) + Pointer + Mid(*Line\Text, n)
						Else
							Break
						EndIf
					Wend
				EndIf
			EndIf
		Next n
		ProcedureReturn #True
	EndProcedure
	
	Procedure SaveFile(File.s)
		Protected BOM = #PB_UTF8, FileID.i, n.l, *Line.LineCode
		If FileSize(File) >0
			FileID = OpenFile(#PB_Any, File)
		Else
			FileID = CreateFile(#PB_Any, File)
		EndIf
		If Not IsFile(FileID)
			MessageRequester("Error", "Can't read/open " + File)
			ProcedureReturn #False
		Else
			TruncateFile(FileID)
			WriteStringFormat(FileId, BOM)
			For n = 1 To *this\LocalText.CountElement()
				*Line = *this\LocalText.GetElement(n)
				WriteStringN(FileID, *line\Text,  BOM)
			Next n
			CloseFile(FileID)
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure LoadFileStructure()
		Protected n, *Line.LineCode, Temp.s, PrecompilerCondition.s
		Protected *Element.Precompiler::Element
		For n = 1 To *this\LocalText.CountElement()
			*Line = *this\LocalText.GetElement(n)
			Select LineIs(*Line\Text)
				Case #Macro
					n = *this.LoadMacro(n)
				Case #CompilerCondition
					If *Element
						*Element.Free()
						*Element = #Null
					EndIf
					*Element = New Precompiler::Element()
					*Element\File = *Line\File
					*Element\Line = *Line\Line
					*Element\PrecompilerCondition = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
				Case #CompilerEndCondition
					If *Element
						*Element.Free()
						*Element = #Null
					Else
						*System.CodeError(*Line\File, *Line\Line, "CompilerEndCondition Without Condition")
					EndIf
				Case #Enumeration
					n = *this.LoadEnumeration(n, *Element)
				Case #Constant
					*this\Constant.AddElement(New Precompiler::Constant(*Line, *Element))
				Case #Structure
					
					n = *this.LoadStructure(n)
				Case #Procedure
					n = *this.LoadProcedure(n)
				Case #Global
					*Line\Text = Mid(*Line\Text, Len("global ") + 1)
					*this.LoadVariable(n, #True)
				Case #Define
					If FindString(Left(*Line\Text, FindString(*Line\Text, " ", 1) - 1) , ".", 1)
						Temp = StringField(Left(*Line\Text, FindString(*Line\Text, " ", 1) - 1), 2, ".")
						*Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
						*this.LoadVariable(n, #False, Temp)
					Else
						*Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
						*this.LoadVariable(n, #False)
					EndIf
				Case #Class
					n = *this.LoadClass(n)
				Default
					If *Line\Text
						*this\Body.AddElement(New Linecode(*line\Text, *line\File, *line\Line))
					EndIf
			EndSelect
			If n = #False
				ProcedureReturn #False
			EndIf
		Next n
		ProcedureReturn #True
	EndProcedure
	
	Procedure GetStructure(Name.s, *StructureNotIn.Precompiler::Structure = #Null)
		Protected n, *StructureP.Precompiler::Structure
		Name = LCase(Name)
		For n = 1 To *this\Structure.CountElement()
			*StructureP = *this\Structure.GetElement(n)
			If LCase(*StructureP\Name) = Name
				If *StructureNotIn
					If Not *StructureP = *StructureNotIn
						ProcedureReturn *StructureP
					EndIf
				Else
					ProcedureReturn *StructureP
				EndIf
			EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
	
	Static Procedure GetVariable(*Array.Array, Name.s)
	Name = LCase(Name)
	Protected n, *ptr.Precompiler::Variable
	For n = 1 To *Array.CountElement()
		*ptr = *Array.GetElement(n)
		If LCase(*ptr\Name) = Name
			ProcedureReturn *ptr
		EndIf
	Next n
	ProcedureReturn #Null
EndProcedure


Procedure.s GetTypeFromStructureField(Type.s, Field.s)
	Protected n, *PStructure.Precompiler::Structure, *Field.Precompiler::Attribut
	Protected *Class.Precompiler::Class
	;PrintN("recherche dans le type" + Type)
	For n = 1 To *this\Structure.CountElement()
		*PStructure = *this\Structure.GetElement(n)
		If LCase(*PStructure\Name) = LCase(Type)
			*Field = *PStructure.GetField(Field)
			If Not *Field
				*Class = *this.GetClass(Type)
				If *Class
					;PrintN(Type + " extends " + *Class\Extend)
					If *Class\Extend
						;PrintN(*Class\Extend)
						*Class = *this.GetClass(*Class\Extend)
						If *Class
							ProcedureReturn *this.GetTypeFromStructureField(*Class\Name, Field)
						EndIf
					EndIf
				Else
					ProcedureReturn ""
				EndIf
				ProcedureReturn ""
			EndIf
			ProcedureReturn *Field\Type
		EndIf
	Next n
	ProcedureReturn ""
EndProcedure

EndClass
