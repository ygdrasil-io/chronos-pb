Class ClassAttribut Extends Precompiler::StructureAttribut
DefaultValue.s
	
	
	Procedure ClassAttribut(*Line.LineCode)
		*this\Line = *Line\Line
		*this\File = *Line\File
		*this\Text = *Line\Text
		*this\Text = ReplaceString(*this\Text, "::", "_")
		If Mid(*this\Text, 1, 1) = "*"
			*this\Ptr = #True
			*this\Text = Mid(*this\Text, 2)
		EndIf
		If FindString(*this\Text, "=", 1)
			*this\DefaultValue = Trim(Mid(*this\Text, FindString(*this\Text, "=", 1) + 1))
			*this\Text = StringField(*this\Text, 1, "=")
		EndIf
		If FindString(*Line\Text, "[", 1)
			*this\Array = StringField(StringField(*this\Text, 1, "]"), 2, "[")
			*this\Text = StringField(*this\Text, 1, "[") + StringField(*this\Text, 2, "]")
		EndIf
		If FindString(*this\Text, ".", 1)
			*this\Name = StringField(*this\Text, 1, ".")
			*this\Type = StringField(*this\Text, 2, ".")
		Else
			*this\Name = *this\Text
			*this\Type = "i"
		EndIf
	EndProcedure
EndClass	
