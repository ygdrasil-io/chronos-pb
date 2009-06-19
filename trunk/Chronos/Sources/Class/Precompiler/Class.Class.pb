Procedure.i GetClass(Name.s)
	Protected n, *Class.Precompiler::Class
	For n = 1 To *this\Class.CountElement()
		*Class = *this\Class.GetElement(n)
		If LCase(*Class\Name) = LCase(Name)
			ProcedureReturn *Class
		EndIf
	Next n
	ProcedureReturn #Null
EndProcedure

Procedure Constructor(*Class.Precompiler::Class)
	Protected *Method.Precompiler::Method = New Precompiler::Method()
	Protected *Attribut.Precompiler::Attribut = New Precompiler::Attribut()
	Protected n, *CAttribut. Precompiler::ClassAttribut
	*Method\Attribut.Array = New Array()
	*Method\LocalV.Array = New Array()
	*Method\Body.Array = New Array()
	*Method\ClassName = *Class\Name
	*Method\Name = "New_" + *Class\Name
	*Method\ProcedureMode = #Mode_Procedure
	*Class\Constructor.AddElement(*Method)
	*this\Procedure.AddElement(*Method)
	*Attribut\Name = "*this"
	*Attribut\Type = *Class\Name
	*Method\LocalV.AddElement(*Attribut)
	*Method\Body.AddElement(New LineCode(Chr(9) + "*this = AllocateMemory(SizeOf(" + *Class\Name + "))", "", #Null))
	For n = 1 To *Class\Attribut.CountElement()
		*CAttribut = *Class\Attribut.GetElement(n)
		If *CAttribut\DefaultValue
			*Method\Body.AddElement(New LineCode(Chr(9) + "*this\" + *CAttribut\Name + "=" + *CAttribut\DefaultValue, *CAttribut\File, *CAttribut\Line))
		EndIf
	Next n
	*Method\Body.AddElement(New LineCode(Chr(9) + "ProcedureReturn *this", "", #Null))
EndProcedure

Procedure LoadClass(n, NameSpace.s = "", *ClassList.Array = #Null)
	Protected *Line.LineCode = *this\LocalText.GetElement(n), i, *temp.Array
	Protected *Class.Precompiler::Class = New Precompiler::Class()
	*Line\Text = Mid(*Line\Text, FindString(*Line\Text, " ", 1) + 1)
	*Class\File = *Line\File
	*Class\Line = *Line\Line
	*Class\Attribut = New Array()
	i = FindString(LCase(*Line\Text), " extends ", 1)
	If i
		*Class\ClassName = Trim(Left(*Line\Text, i))
		*Class\Name = NameSpace + Trim(Left(*Line\Text, i))
		*Class\Extend = Trim(Mid(*Line\Text, i + Len(" extends ")))
	Else
		*Class\ClassName = Trim(*Line\Text)
		*Class\Name = NameSpace + Trim(*Line\Text)
		*Class\Extend = ""
	EndIf
	If *ClassList
		*ClassList.AddElement(*Class)
	EndIf
	*this\Class.AddElement(*Class)
	*this\Structure.AddElement(*Class)
	For i = n + 1 To *this\LocalText.CountElement()
		*Line.LineCode = *this\LocalText.GetElement(i)
		Select LineIs(*Line\Text)
			Case #Class
				i = *this.LoadClass(i, *Class\Name + "_", *Class\Class)
			Case #Procedure, #StaticProcedure
				i = *this.LoadMethod(i,*Class)
			Case #Declare
				i = *this.LoadMethod(i,*Class)
			Case #EndClass
				If *Class\Constructor.CountElement() = 0
					*this.Constructor(*Class)
				EndIf
				ProcedureReturn i
			Default
				If *Line\Text
					*Class\Attribut.AddElement(New Precompiler::ClassAttribut(*Line))
				EndIf
		EndSelect
		If i = #False
			ProcedureReturn #False
		EndIf
	Next i
	ProcedureReturn i
EndProcedure

Class Class Extends Precompiler::Structure
	*Method.Array = New Array()
	*StaticMethod.Array = New Array()
	*Constructor.Array = New Array()
	*Class.Array = New Array()
	ClassName.s
	
	Procedure GetConstructor()
		ProcedureReturn *this\Constructor.GetElement(1)
	EndProcedure
	
	Procedure GetStaticMethod(Name.s, *Precompiler.Precompiler)
		Protected *Class.Precompiler::Class
		Name = ReplaceString(Name, "::", "_")
		If MemorySize(*This) = SizeOf(Precompiler::Structure)
			If *this\Extend
				*Class = *Precompiler.GetClass(*this\Extend)
				ProcedureReturn *Class.GetMethod(Name, *Precompiler)
			Else
				ProcedureReturn #Null
			Endif
		Endif
		Name = LCase(Name)
		Protected n, *Method.Precompiler::Method
		For n = 1 To *this\StaticMethod.CountElement()
			*Method = *this\StaticMethod.GetElement(n)
			If LCase(*Method\ClassName)  = Name
				ProcedureReturn *Method
			EndIf
		Next n
		If *this\Extend
			*Class = *Precompiler.GetClass(*this\Extend)
			If *Class
				ProcedureReturn *Class.GetMethod(Name, *Precompiler)
			EndIf
		Endif
		ProcedureReturn #Null
	EndProcedure
	
	Procedure GetMethod(Name.s, *Precompiler.Precompiler)
		Protected *Class.Precompiler::Class
		If MemorySize(*This) = SizeOf(Precompiler::Structure)
			If *this\Extend
				*Class = *Precompiler.GetClass(*this\Extend)
				ProcedureReturn *Class.GetMethod(Name, *Precompiler)
			Else
				ProcedureReturn #Null
			Endif
		Endif
		Name = LCase(Name)
		Protected n, *Method.Precompiler::Method
		For n = 1 To *this\Method.CountElement()
			*Method = *this\Method.GetElement(n)
			If LCase(*Method\ClassName)  = Name
				ProcedureReturn *Method
			EndIf
		Next n
		If *this\Extend
			*Class = *Precompiler.GetClass(*this\Extend)
			If *Class
				ProcedureReturn *Class.GetMethod(Name, *Precompiler)
			EndIf
		Endif
		ProcedureReturn #Null
	EndProcedure
	
	Procedure IsConstructor( Line.s)
		Line = StringField(Line, 1, "(")
		Line = StringField(Line, CountString(Line, " ") + 1, " ")
		If LCase(Line) = LCase(*this\ClassName)
			ProcedureReturn #True
		Else
			ProcedureReturn #False
		EndIf
	EndProcedure
EndClass
