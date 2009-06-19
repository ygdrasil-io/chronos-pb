Class StructureAttribut Extends Precompiler::Attribut
	Array.s
	Ptr.b
	
	Procedure StructureAttribut(Text.s)
		If Mid(Text, 1, 1) = "*"
			*this\Ptr = #True
			Text = Mid(Text, 2)
		EndIf
		
		
		If FindString(Text, "[", 1)
			*this\Array = StringField(StringField(Text, 2, "["), 1, "]")
			Text = StringField(Text, 1, "[")
		EndIf
		
		If FindString(Text, ".", 1)
			*this\Type = StringField(Text, 2, ".")
			*this\Name = StringField(Text, 1, ".")
		Else
			*this\Type = "i"
			*this\Name = Text
		EndIf
	EndProcedure
	
	Procedure.s GetDeclaration()
		Protected retour.s
		If *this\Ptr
			retour = "*"
		EndIf
		retour + *this\Name + "." + *this\Type
		If *this\Array
			retour + "[" + *this\Array + "]"
		EndIf
		ProcedureReturn retour
	EndProcedure
EndClass

