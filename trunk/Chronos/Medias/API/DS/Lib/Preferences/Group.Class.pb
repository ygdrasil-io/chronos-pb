IncludeImport "DS.lib.Array"

Class Group
	Name.s
	*Option.Array = New Array()
	
	Procedure Group(Name.s)
		*this\Name = Name	
	EndProcedure
	
	Procedure CreateOption(Key.s, Value.s)
		Protected *Option.Option = New Option(Key, Value)
		*this\Option.AddElement(*Option)
		ProcedureReturn *Option
	EndProcedure
	
	Procedure IsKey(Key.s)
		Protected *Option.Option, n
			For n=1 To *this\Option.CountElement()
				*Option = *this\Option.GetElement(n)
				If *Option\Name = key
					ProcedureReturn *Option
				EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
EndClass
