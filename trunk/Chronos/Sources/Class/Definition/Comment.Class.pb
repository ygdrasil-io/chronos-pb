Class Comment Extends Node
	
	Class Item Extends Definition
		Procedure Item(Comment.s,  Line.i, Path.s = "")
			*this\name = Comment
			*this\Line  = Line
			*this\File = Path
			*this\Type = #Node_Comment
			*this\Child = New Array()
		EndProcedure
		
		Procedure.s GetName()
			ProcedureReturn *this\name
		EndProcedure
	EndClass
	
	Procedure Comment()
		*this\Child = New Array()
		*this\Type = #Node_RootComment
	EndProcedure
	
EndClass
