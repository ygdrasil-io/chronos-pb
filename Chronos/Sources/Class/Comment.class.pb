Procedure NewComment(Comment.s,  Line.i, Path.s = "")
  Protected *this.Comment = AllocateMemory(SizeOf(Comment))
  *this\value = Comment
  *this\Line  = Line
  *this\File = Path
  ProcedureReturn *this
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 1
; Folding = -
; EnableXP