Class Structure Extends Definition
	StructureAtribut.Array
EndClass


Procedure NewStructure(Comment.s,  Line.i, Path.s = "")
	Protected *this.Structure = AllocateMemory(SizeOf(Structure))
	*this\name = Comment
	*this\Line  = Line
	*this\File = Path
	ProcedureReturn *this
EndProcedure

