;===========================================================
;@Library Chaos
;@Author Alexandre Mommers
;@Version 0
;@Lang French
;@Description Chaos est une bibliotheque dédié au scriptage en tout genre
;===========================================================

XIncludeImport "DS.Lib.Array"



Enumeration 1
	#Function
	#operation
	#param
	#random
	#value
EndEnumeration


Enumeration 1
	#Fct_Cos
	#Fct_Sin
	#Fct_Pow
	#Fct_AddD
	#Fct_SubD
	#Fct_DivD
	#Fct_FactD
EndEnumeration

#Fct_Cos_Name = "Cos"
#Fct_Sin_Name = "Sin"
#Fct_Pow_Name = "Pow"
#Fct_AddD_Name = "AddD"
#Fct_SubD_Name = "SubD"
#Fct_DivD_Name = "DivD"
#Fct_FactD_Name = "FactD"

Class Chaos
	*script.Array = New Array()
	*variable.Array = New Array()
	*function.Array = New Array()
	
	Class Variable
		*valeur.i
		type.l
		name.s
		
		Procedure Variable(Name.s, Type.l)
			*this\name = Name
			*this\type = Type
			ProcedureReturn *this
		EndProcedure
		
		Procedure.s GetName()
			ProcedureReturn *this\name
		EndProcedure
	EndClass
	
	Class Function
		Const.b
		param.i[20]
		NbrParam.b
		SizeParam.b
		Name.s
		RetourType.i
		
		Procedure Function(Name.s, const.i, RetourType.l)
			*this\Const = const
			*this\name = Name
			*this\RetourType = RetourType
			ProcedureReturn *this
		EndProcedure
		
		Procedure.s GetName()
			ProcedureReturn *this\name
		EndProcedure
		
		Procedure.w GetNbrParam()
			ProcedureReturn *this\NbrParam
		EndProcedure
		
		Procedure.Chaos::Function AddParameter(type.i)
			*this\param[*this\NbrParam] = type
			*this\NbrParam + 1
			Select type
				Case #PB_Double
					*this\SizeParam + SizeOf(double)
			EndSelect
			ProcedureReturn *this
		EndProcedure		
		
		Procedure.d ExecuteD(*param = #Null)
			Select *this\Const
				Case #Fct_Cos
					ProcedureReturn Cos(PeekD(*param))
				Case #Fct_Sin
					ProcedureReturn Sin(PeekD(*param))
				Case #Fct_Pow
					ProcedureReturn Pow(PeekD(*param), PeekD(*param+SizeOf(double)))
				Case #Fct_AddD
					ProcedureReturn PeekD(*param) + PeekD(*param+SizeOf(double))
				Case #Fct_SubD
					ProcedureReturn PeekD(*param) - PeekD(*param+SizeOf(double))
				Case #Fct_FactD
					ProcedureReturn PeekD(*param) * PeekD(*param+SizeOf(double))
				Case #Fct_DivD
					ProcedureReturn PeekD(*param) / PeekD(*param+SizeOf(double))
			EndSelect
		EndProcedure
	EndClass
	
	
	Procedure Chaos()
		;on ajoute les fonctions de bases
		*this.AddFunction(#Fct_Cos_Name, #Fct_Cos, #PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_Sin_Name, #Fct_Sin, #PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_Pow_Name, #Fct_Pow, #PB_Double).AddParameter(#PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_AddD_Name, #Fct_AddD, #PB_Double).AddParameter(#PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_SubD_Name, #Fct_SubD, #PB_Double).AddParameter(#PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_DivD_Name, #Fct_DivD, #PB_Double).AddParameter(#PB_Double).AddParameter(#PB_Double)
		*this.AddFunction(#Fct_FactD_Name, #Fct_FactD, #PB_Double).AddParameter(#PB_Double).AddParameter(#PB_Double)
		ProcedureReturn *this
	EndProcedure
	
	Procedure.Chaos::Varaible AddVariable(Name.s, type.l)
		Protected *variable.Chaos::Variable = New Chaos::Variable(Name, type)
		*this\variable.AddElement(*variable)
		ProcedureReturn *variable
	EndProcedure
	
	Procedure.Chaos::Function AddFunction(Name.s, const.i, RetourType.l)
		Protected *function.Chaos::Function = New Chaos::Function(Name, const, RetourType)
		*this\function.AddElement(*function)
		ProcedureReturn *function
	EndProcedure
	
	Procedure GetFunctionByName(name.s, Mode.l = 0)
		Protected *function.Chaos::Function, n
		For n=1 To *this\function.CountElement()
			*function = *this\function.GetElement(n)
			If Mode = #PB_String_NoCase
				If LCase(*function.GetName()) = LCase(name)
					ProcedureReturn *function
				EndIf
			Else
				If *function.GetName() = name
					ProcedureReturn *function
				EndIf
			EndIf
		Next n
		ProcedureReturn -1
	EndProcedure
	;
	Procedure GetVariableByName(name.s)
		Protected *variable.Chaos::Variable, n
		For n=1 To *this\variable.CountElement()
			*variable = *this\variable.GetElement(n)
			If *variable.GetName() = name
				ProcedureReturn *variable
			EndIf
		Next n
		ProcedureReturn -1
	EndProcedure
	
EndClass	
