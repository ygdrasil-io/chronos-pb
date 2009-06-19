Structure CharacterRange
	cpMin.l
	cpMax.l
EndStructure

Structure TextToFind
	chrg.CharacterRange
	lpstrText.i
	chrgText.CharacterRange
EndStructure

Class Scintilla
	
	;Macro
	;Constructeur
	Declare Scintilla As ScintillaGadget(#PB_Any, $1, $2, $3, $4, $5)
	;Method
	Declare SetCaretLineBack As ScintillaSendMessage($1, #SCI_SETCARETLINEBACK, $2)
	Declare SetCaretLineVisible As ScintillaSendMessage($1, #SCI_SETCARETLINEVISIBLE, $2)	
	Declare StyleSetFore As ScintillaSendMessage($1, #SCI_STYLESETFORE, $2, $3)
	Declare StyleSetBack As ScintillaSendMessage($1, #SCI_STYLESETBACK, $2, $3)
	Declare StyleSetItalic As ScintillaSendMessage($1, #SCI_STYLESETITALIC, $2, $3)
	Declare StyleSetBold As ScintillaSendMessage($1, #SCI_STYLESETBOLD, $2, $3)
	Declare MarkerDefine As ScintillaSendMessage($1, #SCI_MARKERDEFINE, $2, $3)
	Declare SetMarginTypeN As ScintillaSendMessage($1, #SCI_SETMARGINTYPEN, $2, $3)
	Declare SetMarginMaskN As ScintillaSendMessage($1, #SCI_SETMARGINMASKN, $2, $3)
	Declare SetMarginWidthN As ScintillaSendMessage($1, #SCI_SETMARGINWIDTHN, $2, $3)
	Declare SetMarginSensitiveN As ScintillaSendMessage($1, #SCI_SETMARGINSENSITIVEN, $2, $3)
	Declare MarkerSetFore As ScintillaSendMessage($1, #SCI_MARKERSETFORE, $2, $3)
	Declare MarkerSetBack As ScintillaSendMessage($1, #SCI_MARKERSETBACK, $2, $3)
	Declare AutoIgnoreCase As ScintillaSendMessage($1, #SCI_AUTOCSETIGNORECASE, $2)
	Declare SetLexer As ScintillaSendMessage($1, #SCI_SETLEXER, $2, $3)
	Declare StyleSetSize As ScintillaSendMessage($1, #SCI_STYLESETSIZE, $2, $3)
	Declare StyleClearAll As ScintillaSendMessage($1, #SCI_STYLECLEARALL)
	Declare SetTabIdents As ScintillaSendMessage($1, #SCI_SETTABINDENTS, $2)
	Declare SetBackSpaceUnindents As ScintillaSendMessage($1, #SCI_SETBACKSPACEUNINDENTS, $2)
	Declare SetIndent As ScintillaSendMessage($1, #SCI_SETINDENT, $2)
	Declare SetUseTabs As ScintillaSendMessage($1, #SCI_SETUSETABS, $2)
	Declare SetTabWidth As ScintillaSendMessage($1, #SCI_SETTABWIDTH, $2)
	Declare SetEOLMode As ScintillaSendMessage($1, #SCI_SETEOLMODE, $2)
	Declare SetIndentationGuides As ScintillaSendMessage($1, #SCI_SETINDENTATIONGUIDES, $2)
	Declare GetPosition As ScintillaSendMessage($1, #SCI_GETCURRENTPOS)
	Declare GetLineEndPosition As ScintillaSendMessage($1,#SCI_GETLINEENDPOSITION, $2)
	Declare LineFromPosition As ScintillaSendMessage($1,#SCI_LINEFROMPOSITION,$2)
	Declare PositionFromLine As ScintillaSendMessage($1,#SCI_POSITIONFROMLINE,$2)
	Declare LineLength As ScintillaSendMessage($1,#SCI_LINELENGTH,$2)
	Declare GetLineCount As ScintillaSendMessage($1,#SCI_GETLINECOUNT)
	Declare GetCharAt As ScintillaSendMessage($1, #SCI_GETCHARAT, $2)
	Declare SetLineIdentation As ScintillaSendMessage($1, #SCI_SETLINEINDENTATION, $2, $3)
	Declare GetTabWidth As ScintillaSendMessage($1, #SCI_GETTABWIDTH)
	Declare GetLineIdentation As ScintillaSendMessage($1, #SCI_GETLINEINDENTATION, $2)
	Declare SetLine As ScintillaSendMessage($1, #SCI_GOTOLINE, $2)
	Declare SetPosition As ScintillaSendMessage($1, #SCI_GOTOPOS, $2)
	Declare GetPositionFromLine As ScintillaSendMessage($1, #SCI_POSITIONFROMLINE, $2)
	Declare SetTargetStart As ScintillaSendMessage($1, #SCI_SETTARGETSTART, $2)
	Declare SetTargetEnd As ScintillaSendMessage($1, #SCI_SETTARGETEND, $2)
	Declare SetSel As ScintillaSendMessage($1, #SCI_SETSEL, $2, $3)
	Declare GetSelectionStart As ScintillaSendMessage($1, #SCI_GETSELECTIONSTART)
	Declare GetSelectionEnd As ScintillaSendMessage($1, #SCI_GETSELECTIONEND)
	Declare GetEndStyled As ScintillaSendMessage($1, #SCI_GETENDSTYLED)
	Declare GetFoldLevel As ScintillaSendMessage($1, #SCI_GETFOLDLEVEL, $2)
	Declare SetFoldLevel As ScintillaSendMessage($1, #SCI_SETFOLDLEVEL, $2, $3)
	Declare CanRedo As ScintillaSendMessage($1, #SCI_CANREDO)
	Declare CanUndo As ScintillaSendMessage($1, #SCI_CANUNDO)
	Declare EmptyUndoBuffer As ScintillaSendMessage($1, #SCI_EMPTYUNDOBUFFER)
	Declare Undo As ScintillaSendMessage($1, #SCI_UNDO)
	Declare GoToPoS As ScintillaSendMessage($1, #SCI_GOTOPOS, $2)
	Declare Redo As ScintillaSendMessage($1, #SCI_REDO)
	Declare GetLength As ScintillaSendMessage($1, #SCI_GETLENGTH)
	
	
	;Methode qui néscessite un traitement	
	Procedure StyleSetFont(Style.i, Text.s)
		ScintillaSendMessage(*this, #SCI_STYLESETFONT, Style, @Text)
	EndProcedure
	
	Procedure InsertText(Position.l, Text.s)
		ScintillaSendMessage(*this, #SCI_INSERTTEXT, Position, @Text)
	EndProcedure
	
	Procedure GetLineStartPosition(line)
		ProcedureReturn *this.GetLineEndPosition(line) - *this.LINELENGTH(line)
	EndProcedure
	
	Procedure.s GetLine(line)
		Protected size = *this.LINELENGTH(line), txt.s
		If size
			Protected *text = AllocateMemory(size)
			ScintillaSendMessage(*this,#SCI_GETLINE, line, *text)
			If *this.GETLINECOUNT() = line + 1
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
	
	Procedure AddText(txt.s)
		ProcedureReturn ScintillaSendMessage(*this, #SCI_ADDTEXT, Len(txt), @txt)
	EndProcedure
	
	Procedure GetTextWidth(style, txt.s)
		ProcedureReturn ScintillaSendMessage(*this, #SCI_TEXTWIDTH, style, @txt)
	EndProcedure
	
	Procedure ResizeMargins()
		ProcedureReturn ScintillaSendMessage(*this, #SCI_SETMARGINWIDTHN, 0, 2 + *this.GetTextWidth(#STYLE_DEFAULT, Str(*this.GETLINECOUNT())))
	EndProcedure
	
	Procedure FindString(Text.s, Position.l = 0, Flag.i = #Null)
		Protected Find.TextToFind
		Find\chrg\cpMin = Position
		Find\chrg\cpMax = *this.GetLength()
		Find\lpstrText = @Text
		ProcedureReturn ScintillaSendMessage(*this, #SCI_FINDTEXT, Flag, @Find)
	EndProcedure
	
	Procedure ReplaceTarget(Text.s)
		ScintillaSendMessage(*this, #SCI_REPLACETARGET, len(Text), @Text)
	EndProcedure
	
	Procedure RemoveCharAt(Position.l)
		*this.SetTargetStart(position)
		*this.SetTargetEnd(position + 1)
		*this.ReplaceTarget("")
	EndProcedure
	
EndClass	
