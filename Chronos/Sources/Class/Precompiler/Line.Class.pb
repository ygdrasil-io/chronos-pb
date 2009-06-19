Class LineCode
	File.s
	Line.l
	Text.s
	Procedure LineCode(Text.s, File.s, Line.l)
		*this\Text = Text
		*this\File = File
		*this\Line = Line
	EndProcedure
	
	Procedure Free()
		FreeMemory(*this)
	EndProcedure
EndClass
