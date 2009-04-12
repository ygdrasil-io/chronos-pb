Structure CharacterRange
	cpMin.l;
	cpMax.l;
EndStructure
Structure TextToFind
	chrg.CharacterRange
	lpstrText.i
	chrgText.CharacterRange
EndStructure

Class Scintilla
	Gadget.i
	
	Procedure SetIndentationGuides(Type.l)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_SETINDENTATIONGUIDES, Type)
	EndProcedure
	
	Procedure GetPosition()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETCURRENTPOS)
	EndProcedure
	
	Procedure GetLineEndPosition(line)
		ProcedureReturn ScintillaSendMessage(*this\gadget,#SCI_GETLINEENDPOSITION,line)
	EndProcedure
	
	Procedure LineFromPosition(Pos)
		ProcedureReturn ScintillaSendMessage(*this\gadget,#SCI_LINEFROMPOSITION,Pos)
	EndProcedure
	
	Procedure PositionFromLine(Line)
		ProcedureReturn ScintillaSendMessage(*this\gadget,#SCI_POSITIONFROMLINE,Line)
	EndProcedure
	
	Procedure LineLength(line)
		ProcedureReturn ScintillaSendMessage(*this\gadget,#SCI_LINELENGTH,line)
	EndProcedure
	
	Procedure GetLineStartPosition(line)
		ProcedureReturn SCI_GetLineEndPosition(*this\Gadget, line) - SCI_LINELENGTH(*this\Gadget, line)
	EndProcedure
	
	Procedure GETLINECOUNT()
		ProcedureReturn ScintillaSendMessage(*this\gadget,#SCI_GETLINECOUNT)
	EndProcedure
	
	Procedure.s GETLINE(line)
		Protected size = SCI_LINELENGTH(*this\gadget, line), txt.s
		If size
			Protected *text = AllocateMemory(size)
			ScintillaSendMessage(*this\gadget,#SCI_GETLINE, line, *text)
			If SCI_GETLINECOUNT(*this\Gadget) = line + 1
				txt =  PeekS(*text, size, #PB_Ascii)
			Else
				txt =  PeekS(*text, size - 1, #PB_Ascii)
			EndIf
			FreeMemory(*text)
			ProcedureReturn txt
		Else
			ProcedureReturn ""
		EndIf
	EndProcedure
	
	Procedure GetCharAt(Position)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETCHARAT, Position)
	EndProcedure
	
	Procedure SetLineIdentation(Ligne, Identation)
		ScintillaSendMessage(*this\Gadget, #SCI_SETLINEINDENTATION, Ligne, Identation)
	EndProcedure
	
	Procedure GetLineIdentation(Ligne)
		ScintillaSendMessage(*this\Gadget, #SCI_GETLINEINDENTATION, Ligne)
	EndProcedure
	
	Procedure GetTabWidth()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETTABWIDTH)
	EndProcedure
	
	Procedure AddText(txt.s)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_ADDTEXT, Len(txt), @txt)
	EndProcedure
	
	Procedure SetLine(Line)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GOTOLINE, Line)
	EndProcedure
	
	Procedure SetPosition(Position)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GOTOPOS, Position)
	EndProcedure
	
	Procedure GetPositionFromLine(Line)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_POSITIONFROMLINE, Line)
	EndProcedure
	
	Procedure GetTextWidth(style, txt.s)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_TEXTWIDTH, style, @txt)
	EndProcedure
	
	Procedure ResizeMargins()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_SETMARGINWIDTHN, 0, 2 + SCI_GetTextWidth(*this\gadget, #STYLE_DEFAULT, Str(SCI_GETLINECOUNT(*this\Gadget))))
	EndProcedure
	
	Procedure GetEndStyled()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETENDSTYLED)
	EndProcedure
	
	Procedure GetFoldLevel(Line.l)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETFOLDLEVEL, Line)
	EndProcedure
	
	Procedure SetFoldLevel(Line.l, Level.l)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_SETFOLDLEVEL, Line, Level)
	EndProcedure
	
	Procedure CanRedo()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_CANREDO)
	EndProcedure
	
	Procedure CanUndo()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_CANUNDO)
	EndProcedure
	
	Procedure EmptyUndoBuffer()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_EMPTYUNDOBUFFER)
	EndProcedure
	
	Procedure Undo()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_UNDO)
	EndProcedure
	
	Procedure GoToPoS(pos.l)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GOTOPOS, pos)
	EndProcedure
	
	Procedure Redo()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_REDO)
	EndProcedure
	
	Procedure GetLength()
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_GETLENGTH)
	EndProcedure
	
	Procedure FindString(Text.s, Position.l = 0, Flag.i = #Null)
		Protected Find.TextToFind
		Find\chrg\cpMin = Position
		Find\chrg\cpMax = SCI_GetLength(*this\Gadget)
		Find\lpstrText = @Text
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_FINDTEXT, Flag, @Find)
	EndProcedure
	
	Procedure SetSel(anchorPos.l, currentPos.l)
		ProcedureReturn ScintillaSendMessage(*this\Gadget, #SCI_SETSEL, anchorPos, currentPos)
	EndProcedure
	
EndClass

; IDE Options = PureBasic 4.30 (Windows - x86)
; CursorPosition = 9
; Folding = ------
; EnableXP