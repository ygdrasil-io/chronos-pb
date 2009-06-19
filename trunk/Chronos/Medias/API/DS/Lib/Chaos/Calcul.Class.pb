XIncludeImport "DS.Lib.Debug"
XIncludeImport "DS.Lib.Array"
XIncludeImport "DS.Lib.Chaos.Chaos"

Enumeration 1
	#Function
	#operation
	#param
	#random
	#value
EndEnumeration


#Calcul_Value = "0123456789"
#Calcul_FormatOperator = "* / + -"
#Calcul_FormatFonction = "FactD DivD AddD SubD"



Class Operation
	
	Class String
		StaticProcedure FindEndPosition(text.s, position.w)
			Protected n.w ,x.w
			For x=position To Len(text)
				If Mid(text, x, 1) = "("
					n+1
				EndIf
				If Mid(text, x, 1) = ")"
					If n = 1
						ProcedureReturn x
					Else
						n -1
					EndIf
				EndIf
			Next x
			ProcedureReturn #Error
		EndProcedure
		
		;===========================================================
		;renvoie vrai si l'expression un operateur
		;===========================================================
		StaticProcedure IsOperator(char.s)
			Protected n.w, operator.s
			For n=1 To 4
				operator = StringField(#Calcul_FormatOperator, n, " ")
				If operator = char
					ProcedureReturn #True
				EndIf
			Next n
			ProcedureReturn #False
		EndProcedure
		
		;===========================================================
		;renvoie expression + function(argument1,
		;===========================================================
		StaticProcedure.s GetLeftExpression(text.s, function.s)
			Protected char.s, n.w, Parenthese_Found.w
			For n = Len(text) To 0 Step -1
				char = Mid(text, n, 1)
				If Operation::String::Static::IsOperator(char)
					If Parenthese_Found = 0
						ProcedureReturn Left(text, n) + function + "(" + Right(text, Len(text) - n) + ","
					EndIf
				EndIf
				If char = ")"
					Parenthese_Found + 1
				EndIf
				If char = "(" Or char = ","
					If Parenthese_Found = 0
						ProcedureReturn Left(text, n) + function + "(" + Right(text, Len(text) - n) + ","
					EndIf
					If char = "("
						Parenthese_Found - 1
					EndIf
				EndIf
			Next n
			ProcedureReturn function  + "(" + text + ","
		EndProcedure
		
		;===========================================================
		;renvoie argument2) + expression
		;===========================================================
		StaticProcedure.s GetRightExpression(text.s)
			Protected char.s, n.w, Parenthese_Found.w
			For n = 1 To Len(text) - 1
				char = Mid(text, n, 1)
				If Operation::String::Static::IsOperator(char)
					If Parenthese_Found = 0
						ProcedureReturn Left(text, n) + ")" + Right(text, Len(text) - n)
					EndIf
				EndIf
				
				If char = ")" Or char = ","
					If char = ")"
						Parenthese_Found - 1
					EndIf
					If Parenthese_Found = 0
						ProcedureReturn Left(text, n) + ")" + Right(text, Len(text) - n)
					EndIf
				EndIf
				
				If char = "("
					Parenthese_Found + 1
				EndIf
			Next n
			ProcedureReturn text + ")"
		EndProcedure
		
		;===========================================================
		;formate le texte en remplacant les operateurs par des fonctions
		;===========================================================
		StaticProcedure.s FormatOperation(text.s)
			If Not Len(text)
				ProcedureReturn ""
			EndIf
			Protected n.b, operator.s, function.s, i.w, x.b, char.s
			For n=1 To 4
				operator = StringField(#Calcul_FormatOperator, n, " ")
				function =  StringField(#Calcul_FormatFonction, n, " ")
				i = FindString(text, operator, 1)
				While i
					text = Operation::String::Static::GetLeftExpression(Left(text, i - 1), function) + Operation::String::Static::GetRightExpression(Right(text,Len(text) - i))
					i = FindString(text, operator, 1)
				Wend
			Next
			ProcedureReturn text
		EndProcedure
		
		;===========================================================
		;renvoie le parametre sous forme de string
		;===========================================================
		StaticProcedure.s FindNextArgument(text.s, index.b)
			;Debug "argument a trouver " + Str(index) + " dans " + text
			If Not Len(text) Or index <=0
				ProcedureReturn ""
			EndIf
			Protected Parenthese_Found = 0
			Protected Virgule_Found = 0
			Protected Index_text.w
			Protected Index_LastVirgule
			Protected Char_Current.s
			For Index_text = 1 To Len(text)
				Char_Current = Mid(text, Index_text, 1)
				Select Char_Current
					Case "("
						Parenthese_Found + 1
					Case ")"
						Parenthese_Found - 1
						If Parenthese_Found < 0
							ProcedureReturn ""
						EndIf
					Case ","
						If Parenthese_Found = 0;si on trouve une virgule qui n'est pas entre parenthese
							Virgule_Found + 1
							If Virgule_Found = index
								ProcedureReturn Mid(text, Index_LastVirgule, Index_text - Index_LastVirgule - 1)
							EndIf
							Index_LastVirgule = Index_text + 1
						EndIf ;sinon on ignore
				EndSelect
			Next Index_text
			ProcedureReturn Mid(text, Index_LastVirgule, Index_text - Index_LastVirgule)
		EndProcedure
		
		;===========================================================
		;renvoie le numero de parametre si c'est un parametre
		;===========================================================
		StaticProcedure IsParam(text.s)
			Protected x
			If Len(text)> 2
				ProcedureReturn #False
			EndIf
			If Mid(text, 1, 1) = "$"
				Protected value.b = Val(Mid(text, 2, 1))
				For x=1 To 9
					If value = x
						ProcedureReturn x
					EndIf
				Next x
			EndIf
			ProcedureReturn #False
		EndProcedure
		
		;===========================================================
		;renvoie vrai si l'expression est un valeur (type flotant)
		;===========================================================
		StaticProcedure IsValue(text.s)
			Protected x.w, char.s, n.b, found.b, virgule.b
			For x=0 To Len(text)
				char = Mid(text, x, 1)
				found = 0
				For n=0 To Len(#Calcul_Value)
					If (Mid(#Calcul_Value, n, 1) = char)
						found = 1
					EndIf
				Next n
				
				If char = "."
					If virgule
						ProcedureReturn #False
					Else
						virgule = 1
					EndIf
					found = 1
				EndIf
				
				If found = 0
					ProcedureReturn #False
				EndIf
			Next x
			ProcedureReturn #True
		EndProcedure
	EndClass
	
	
	
	Class Operation
		type.b
		value.d
		*operationList.Array = New Array()
		*Function.Chaos::Function
		
		;===========================================================
		;on crée les operations en cascade
		;===========================================================
		Procedure Operation(*Chaos.Chaos, text.s)
			If Not Len(text)
				*this.Free()
				ProcedureReturn #False
			EndIf
			text = ReplaceString(text, " ", "")
			;===========================================================
			;si l'operation est une simple valeur
			;===========================================================
			If Not (Operation::String::Static::IsValue(text) = #False)
				*this\type = #value
				*this\value = ValD(text)
				ProcedureReturn *this
			EndIf
			;===========================================================
			;si l'operation est un parametres
			;===========================================================
			Protected Param.b = Operation::String::Static::IsParam(text)
			If Param
				*this\type = #param
				*this\value = Param
				ProcedureReturn *this
			EndIf
			;===========================================================
			;si l'operation comporte des fonctions
			;===========================================================
			Protected FctFound.s
			Protected n.w, i.w, x.w,  NbrParam.b
			Protected Index_Param.b
			Protected *Function.Chaos::Function
			n = FindString(text, "(" ,1)
			If n
				FctFound = Left(text, n - 1)
				*Function = *Chaos.GetFunctionByName(FctFound, #PB_String_NoCase)
				If *Function
					NbrParam = *Function.GetNbrParam()
					*this\type = #Function
					*this\Function = *Function
					text = Left(text, Len(text) - 1)
					text = Right(text, Len(text) - Len(FctFound) - 1)
					;si aucun parametre
					If NbrParam = 0
						If Len(text) = 0
							ProcedureReturn *this
						Else
							*this.Free()
							ProcedureReturn #False
						EndIf
					EndIf
					If NbrParam >= 1
						If Len(text) = 0
							*this.Free()
							ProcedureReturn #False
						Else
							
							For Index_Param = 1 To NbrParam
								*this\operationList.AddElement(New Operation::Operation(*Chaos, Operation::String::Static::FindNextArgument(text, Index_Param)))
								If Not *this\operationList.GetElement(*this\operationList.CountElement())
									*this.Free()
									ProcedureReturn #False
								EndIf
							Next Index_Param
							ProcedureReturn *this
						EndIf
					EndIf
				EndIf
			Else
				*this.Free()
				ProcedureReturn #False
			EndIf
		EndProcedure
		
		Procedure Free()
			Protected n, *operation.Operation::Operation
			For n = 1 To *this\operationList.CountElement()
				*operation = *this\operationList.GetElement(n)
				If *operation
					*operation.Free()
				EndIf
			Next
			*this\operationList.Free()
			FreeMemory(*this)
		EndProcedure
		
		Procedure.d Execute(*param.i)
			Protected n.w, *operation.Operation::Operation
			Select *this\type
				Case #param
					ProcedureReturn PeekD(*param + SizeOf(double)*(*this\value-1))
				Case #random
					ProcedureReturn (Random(100)*0.01)
				Case #value
					ProcedureReturn *this\value
				Case #Function
					If *this\function\NbrParam
						Protected *arg = AllocateMemory(*this\function\SizeParam)
						For n=1 To *this\function\NbrParam
							*operation = *this\operationList.GetElement(n)
							PokeD(*arg + SizeOf(double) * (n-1), *operation.Execute(*param))
						Next n
						Protected retour.d = *this\Function.ExecuteD(*arg)
						FreeMemory(*arg)
						ProcedureReturn retour
					Else
						ProcedureReturn *this\Function.ExecuteD(#Null)
					EndIf
			EndSelect
		EndProcedure
	EndClass
	
	*FirstOperation.Operation::Operation
	*Chaos.chaos
	
	Procedure Operation(*Chaos.Chaos, text.s)
		Protected n.w = CountString(text, "(")
		If Len(text)=0 Or Not (n = CountString(text, ")"))
			FreeMemory(*this)
			ProcedureReturn #Error
		EndIf
		text = LCase(Operation::String::Static::FormatOperation(RemoveString(text, " ")))
		*this\FirstOperation = New Operation::Operation(*Chaos, text)
		If *this\FirstOperation
			*this\Chaos = *Chaos
		Else
			FreeMemory(*this)
			ProcedureReturn #Error
		EndIf
	EndProcedure
	
	Procedure.d Execute(*param.i = #Null)
		ProcedureReturn *this\FirstOperation.Execute(*param)
	EndProcedure
	
	Procedure Free()
		*this\FirstOperation.Free()
		FreeMemory(*this)
	EndProcedure
EndClass

