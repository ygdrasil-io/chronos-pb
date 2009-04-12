Procedure NewStructure(Comment.s,  Line.i, Path.s = "")
  Protected *this.Structure = AllocateMemory(SizeOf(Structure))
  *this\name = Comment
  *this\Line  = Line
  *this\File = Path
  ProcedureReturn *this
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 6
; Folding = -
; EnableXP