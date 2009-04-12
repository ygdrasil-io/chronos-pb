IncludeImport "DS.lib.Array"

Class Option
	Name.s
	Value.s
	
	Procedure Option(Name.s, Value.s)
		*this\Name = Name	
		*this\Value = Value	
	EndProcedure

	Procedure SetValue(Value.s)
		*this\Value = Value
	EndProcedure
EndClass

