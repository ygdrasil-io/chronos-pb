Procedure SCI_SetIndentationGuides(Gadget.i, Type.l)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_SETINDENTATIONGUIDES, Type)
EndProcedure

Procedure SCI_GetPosition(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETCURRENTPOS)
EndProcedure

Procedure SCI_GetLineEndPosition(Gadget, line)
	ProcedureReturn ScintillaSendMessage(gadget,#SCI_GETLINEENDPOSITION,line)
EndProcedure

Procedure SCI_LineFromPosition(Gadget, Pos)
	ProcedureReturn ScintillaSendMessage(gadget,#SCI_LINEFROMPOSITION,Pos)
EndProcedure

Procedure SCI_PositionFromLine(Gadget, Line)
	ProcedureReturn ScintillaSendMessage(gadget,#SCI_POSITIONFROMLINE,Line)
EndProcedure

Procedure SCI_LineLength(Gadget, line)
	ProcedureReturn ScintillaSendMessage(gadget,#SCI_LINELENGTH,line)
EndProcedure

Procedure SCI_GetLineStartPosition(Gadget, line)
	ProcedureReturn SCI_GetLineEndPosition(Gadget, line) - SCI_LINELENGTH(Gadget, line)
EndProcedure

Procedure SCI_GETLINECOUNT(Gadget)
	ProcedureReturn ScintillaSendMessage(gadget,#SCI_GETLINECOUNT)
EndProcedure

Procedure.s SCI_GETLINE(Gadget, line)
	Protected size = SCI_LINELENGTH(gadget, line), txt.s
	If size
		Protected *text = AllocateMemory(size)
		ScintillaSendMessage(gadget,#SCI_GETLINE, line, *text)
		If SCI_GETLINECOUNT(Gadget) = line + 1
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

Procedure SCI_GetCharAt(Gadget, Position)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETCHARAT, Position)
EndProcedure

Procedure SCI_SetLineIdentation(Gadget, Ligne, Identation)
	ScintillaSendMessage(Gadget, #SCI_SETLINEINDENTATION, Ligne, Identation)
EndProcedure

Procedure SCI_GetLineIdentation(Gadget, Ligne)
	ScintillaSendMessage(Gadget, #SCI_GETLINEINDENTATION, Ligne)
EndProcedure

Procedure SCI_GetTabWidth(Gadget)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETTABWIDTH)
EndProcedure

Procedure SCI_AddText(Gadget, txt.s)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_ADDTEXT, Len(txt), @txt)
EndProcedure

Procedure SCI_SetLine(Gadget, Line)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GOTOLINE, Line)
EndProcedure

Procedure SCI_SetPosition(Gadget, Position)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GOTOPOS, Position)
EndProcedure

Procedure SCI_GetPositionFromLine(Gadget, Line)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_POSITIONFROMLINE, Line)
EndProcedure

Procedure SCI_GetTextWidth(gadget, style, txt.s)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_TEXTWIDTH, style, @txt)
EndProcedure

Procedure SCI_ResizeMargins(Gadget)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_SETMARGINWIDTHN, 0, 2 + SCI_GetTextWidth(gadget, #STYLE_DEFAULT, Str(SCI_GETLINECOUNT(Gadget))))
EndProcedure

Procedure SCI_GetEndStyled(Gadget)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETENDSTYLED)
EndProcedure

Procedure SCI_GetFoldLevel(Gadget.i, Line.l)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETFOLDLEVEL, Line)
EndProcedure

Procedure SCI_SetFoldLevel(Gadget.i, Line.l, Level.l)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_SETFOLDLEVEL, Line, Level)
EndProcedure

Procedure SCI_CanRedo(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_CANREDO)
EndProcedure

Procedure SCI_CanUndo(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_CANUNDO)
EndProcedure

Procedure SCI_EmptyUndoBuffer(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_EMPTYUNDOBUFFER)
EndProcedure

Procedure SCI_Undo(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_UNDO)
EndProcedure

Procedure SCI_GoToPoS(Gadget.i, pos.l)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GOTOPOS, pos)
EndProcedure

Procedure SCI_Redo(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_REDO)
EndProcedure

Procedure SCI_GetLength(Gadget.i)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_GETLENGTH)
EndProcedure

Procedure SCI_FindString(Gadget.i, Text.s, Position.l = 0, Flag.i = #Null)
	Protected Find.TextToFind
	Find\chrg\cpMin = Position
	Find\chrg\cpMax = SCI_GetLength(Gadget)
	Find\lpstrText = @Text
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_FINDTEXT, Flag, @Find)
EndProcedure

Procedure SCI_SetSel(Gadget.i, anchorPos.l, currentPos.l)
	ProcedureReturn ScintillaSendMessage(Gadget, #SCI_SETSEL, anchorPos, currentPos)
EndProcedure

Procedure KeyWordIs(key.s)
	Protected n
	If key=""
		ProcedureReturn -1
	EndIf
	key = LCase(key)
	For n=1 To CountString(KeyWordUp, " ") + 1
		If LCase(StringField(KeyWordUp, n, " ")) = key
			ProcedureReturn #LexerState_FoldKeywordUp
		EndIf
	Next n
	For n=1 To CountString(KeyWordDown, " ") + 1
		If LCase(StringField(KeyWordDown, n, " ")) = key
			ProcedureReturn #LexerState_FoldKeywordDown
		EndIf
	Next n
	For n=1 To CountString(KeyWordNone, " ") + 1
		If LCase(StringField(KeyWordNone, n, " ")) = key
			ProcedureReturn #LexerState_Keyword
		EndIf
	Next n
	
	ProcedureReturn -1
EndProcedure

#SCI_Folding_KEY_UP = "procedure macro class"
#SCI_Folding_KEY_Down = "endprocedure endmacro endclass"

Procedure Highlight(gadget.l, endpos.l)
	Protected char.l, keyword.s, state.i, linenumber.l
	Protected currentline.l = SCI_LINEFROMPOSITION(gadget, SCI_GetEndStyled(gadget))
	Protected currentpos.l = SCI_POSITIONFROMLINE(gadget, currentline)
	Protected endlinepos.l, startkeyword
	Protected tempPosition, level
	Protected Found, n
	If currentline = 0
		level = #SC_FOLDLEVELBASE
	Else
		level = SCI_GetFoldLevel(Gadget, currentline) & ~ #SC_FOLDLEVELHEADERFLAG	
	EndIf
	endpos = SCI_GetLineEndPosition(gadget, SCI_LineFromPosition(gadget, endpos))
	ScintillaSendMessage(gadget, #SCI_STARTSTYLING, currentpos, $1f | #INDICS_MASK)
	While currentpos <= endpos
		char = ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos)
		Select char
			Case '%', '*', '=', '+', '-', '/', '|', '&', '.', '\'
				If char = '*'
					If (currentpos + 1) > endpos Or Not SCI_LineFromPosition(gadget, currentpos) = SCI_LineFromPosition(gadget, currentpos + 1)
						ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
					Else
						Select ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos + 1)
							Case '_', 'a' To 'z', 'A' To 'Z'
								tempPosition = currentpos - 1
								While tempPosition >= 0 And ScintillaSendMessage(gadget, #SCI_GETCHARAT, tempPosition) = ' ' And SCI_LineFromPosition(gadget, tempPosition) = SCI_LineFromPosition(gadget, tempPosition + 1)
									tempPosition - 1
								Wend
								If SCI_LineFromPosition(gadget, tempPosition) = SCI_LineFromPosition(gadget, tempPosition + 1) And tempPosition > 0
									Select ScintillaSendMessage(gadget, #SCI_GETCHARAT, tempPosition)
										Case '_', 'a' To 'z', 'A' To 'Z', '0' To '9'
											ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
										Default
											ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
									EndSelect
								Else
									ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
								EndIf
							Default
								ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
						EndSelect
					EndIf
				Else
					ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
				EndIf
				
			Case 10
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
				If Not Found
					SCI_SetFoldLevel(gadget, currentline, level)
				Else
					Found = #False
				EndIf
				currentline + 1
			Case 'a' To 'z', 'A' To 'Z'
				endlinepos = SCI_GetLineEndPosition(gadget, SCI_LineFromPosition(gadget, currentpos))
				keyword = Chr(char)
				While currentpos < endlinepos
					currentpos + 1
					char = ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos)
					If Not ((char >= 'a' And char <= 'z') Or (char >= 'A' And char <= 'Z') Or char = '_' Or (char >= '0' And char <= '9'))
						currentpos-1
						Break
					EndIf
					keyword + Chr(char)
				Wend
				If Not Found
					For n = 1 To CountString(#SCI_Folding_KEY_UP, " ") + 1
						If LCase(keyword) = StringField(#SCI_Folding_KEY_UP, n, " ")
							SCI_SetFoldLevel(gadget, currentline, level | #SC_FOLDLEVELHEADERFLAG)
							Found = #True
							level + 1
							Break
						EndIf
					Next n
					If Not Found
						For n = 1 To CountString(#SCI_Folding_KEY_Down, " ") + 1
							If LCase(keyword) = StringField(#SCI_Folding_KEY_Down, n, " ")
								SCI_SetFoldLevel(gadget, currentline, level)
								Found = #True
								level - 1
								If level < #SC_FOLDLEVELBASE
									level = #SC_FOLDLEVELBASE
								EndIf
								Break
							EndIf
						Next n
					EndIf
				EndIf
				state = -1
				tempPosition = currentpos
				While tempPosition < endlinepos
					tempPosition + 1
					char = ScintillaSendMessage(gadget, #SCI_GETCHARAT, tempPosition)
					If char = '('
						state = #LexerState_Function
						Break
					EndIf
					If char <> ' '
						Break
					EndIf
				Wend
				If state = -1
					Select KeyWordIs(keyword)
						Case #LexerState_FoldKeywordUp
							state = #LexerState_Keyword
						Case #LexerState_FoldKeywordDown
							state = #LexerState_Keyword
						Case #LexerState_Keyword
							state = #LexerState_Keyword
						Default
							state = #LexerState_NonKeyword
					EndSelect
				EndIf
				
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, Len(keyword), state)
			Case '"'
				endlinepos = SCI_GetLineEndPosition(gadget, SCI_LineFromPosition(gadget, currentpos))
				startkeyword = 1
				While currentpos < endlinepos
					currentpos + 1
					startkeyword + 1
					If ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos) = '"'
						Break
					EndIf
				Wend
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, startkeyword, #LexerState_String)
			Case ';' ;commentaire
				endlinepos = SCI_GetLineEndPosition(gadget, SCI_LineFromPosition(gadget, currentpos))
				If currentpos + 1 <= endlinepos
					If ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos + 1) = '{'
						SCI_SetFoldLevel(gadget, currentline, level | #SC_FOLDLEVELHEADERFLAG)
						Level + 1
						Found = #True
					ElseIf ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos + 1) = '}'
						SCI_SetFoldLevel(gadget, currentline, level)
						Level - 1
						If level < #SC_FOLDLEVELBASE
							level = #SC_FOLDLEVELBASE
						EndIf
						Found = #True
					EndIf
				EndIf
				startkeyword = 1
				While currentpos < endlinepos - 1
					currentpos + 1
					startkeyword + 1
				Wend
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, startkeyword, #LexerState_Comment)
			Case 9, ' '
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_Space)
			Case '#'
				endlinepos = SCI_GetLineEndPosition(gadget, SCI_LineFromPosition(gadget, currentpos))
				startkeyword = 1
				While currentpos < endlinepos
					currentpos + 1
					char = ScintillaSendMessage(gadget, #SCI_GETCHARAT, currentpos)
					If Not ((char >= 'a' And char <= 'z') Or (char >= 'A' And char <= 'Z') Or char = '_' Or (char >= '0' And char <= '9'))
						currentpos-1
						Break
					EndIf
					startkeyword + 1
				Wend
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, startkeyword, #LexerState_Constant)
			Default
				ScintillaSendMessage(gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
		EndSelect
		currentpos+1
	Wend
EndProcedure


Procedure AutoComplete(Gadget.i, Pos.l)
	Protected Char, txt.s, currentpos = Pos, Line = SCI_LineFromPosition(Gadget, Pos), KeyWord.s
	Protected FirstPosition = SCI_GetPositionFromLine(Gadget, Line)
	txt = Left(SCI_GETLINE(Gadget, line), Pos - FirstPosition)
	If Not CountString(txt, Chr(34))%2 = 0
		ProcedureReturn
	EndIf
	txt = ""
	char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
	While ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_') And currentpos >= FirstPosition
		txt + Chr(char)
		currentpos + 1
		char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
	Wend
	currentpos = pos - 1
	char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
	While ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_') And currentpos >= FirstPosition
		txt = Chr(char) + txt
		currentpos - 1
		char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
	Wend
	If currentpos >= FirstPosition
		Select char
			Case ':'
				KeyWord = ""
			Case '.'
				KeyWord = " " + CompilerStructure
			Case '\'
				KeyWord = ""
			Default
				KeyWord = " " + KeyWordUp + " " + KeyWordDown + " " + KeyWordNone + " " + CompilerFunction  + " " + GetFunctionList(*System) + " "
		EndSelect
	Else
		KeyWord = " " + KeyWordUp + " " + KeyWordDown + " " + KeyWordNone + " " + CompilerFunction  + " " + GetFunctionList(*System) + " "
	EndIf
	If ScintillaSendMessage(Gadget,#SCI_AUTOCACTIVE)
		ScintillaSendMessage(Gadget,#SCI_AUTOCCANCEL)
	EndIf
	If Len(txt)
		txt = LCase(txt)
		Protected last, KeyList.s, *ptr, temp
		last = FindString(KeyWord, " ", 1)
		While last > 0
			If LCase(Mid(KeyWord, last+1, Len(txt))) = txt
				temp = FindString(KeyWord, " ", last+1)
				If Keylist
					Keylist + " "
				EndIf
				Keylist + Mid(KeyWord, last+1, temp-last-1)
			EndIf
			last = FindString(KeyWord, " ", last + 1)
		Wend
		If Len(KeyList)
			*ptr = AllocateMemory(Len(KeyList) + 1)
			PokeS(*Ptr, KeyList, Len(KeyList), #PB_Ascii)
			ScintillaSendMessage(Gadget, #SCI_AUTOCSHOW, Len(txt), *ptr)
			FreeMemory(*ptr)
		EndIf
	EndIf
EndProcedure

#SCI_Indent_KEY_UP_ = "procedure procedurec procedurecdll proceduredll"
#SCI_Indent_KEY_UP = "if while repeat procedure procedurec procedurecdll proceduredll for class compilerif structure enumeration macro  foreach compilercondition"
#SCI_Indent_KEY_UP2 = "select "
#SCI_Indent_KEY_Down = "endif endprocedure next wend forever until endclass compilerendif endstructure endenumeration endmacro compilerendcondition"
#SCI_Indent_KEY_Down2 = "endselect"
#SCI_Indent_KEY_Transition = "else case elseif compilerelse default"

Procedure AutoIdent(Gadget)
	Protected Line.l, Text.s, CurrentIdent = 0, n, Found.b
	For Line = 0 To SCI_GETLINECOUNT(Gadget)
		SCI_SetLineIdentation(Gadget, Line, 0)
		Text = LCase(SCI_GETLINE(Gadget, Line))
		Found = #False
		If Text
			For n = 1 To CountString(#SCI_Indent_KEY_UP_, " ") + 1
				If FindString(Text, StringField(#SCI_Indent_KEY_UP_, n, " ") + ".", 1) = 1
					SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
					Found = #True
					CurrentIdent + 1
				EndIf
			Next n
			If Not Found
				For n = 1 To CountString(#SCI_Indent_KEY_UP, " ") + 1
					If FindString(Text, StringField(#SCI_Indent_KEY_UP, n, " ") + " ", 1) = 1 Or Text = StringField(#SCI_Indent_KEY_UP, n, " ")
						SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
						Found = #True
						CurrentIdent + 1
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To CountString(#SCI_Indent_KEY_UP2, " ") + 1
					If FindString(Text, StringField(#SCI_Indent_KEY_UP2, n, " ") + " ", 1) = 1
						SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
						Found = #True
						CurrentIdent + 2
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To CountString(#SCI_Indent_KEY_Down, " ") + 1
					If FindString(Text, StringField(#SCI_Indent_KEY_Down, n, " ") + " ", 1) = 1 Or Text = StringField(#SCI_Indent_KEY_Down, n, " ")
						CurrentIdent - 1
						SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
						Found = #True
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To CountString(#SCI_Indent_KEY_Down2, " ") + 1
					If FindString(Text, StringField(#SCI_Indent_KEY_Down2, n, " "), 1) = 1  Or Text = StringField(#SCI_Indent_KEY_Down2, n, " ")
						CurrentIdent - 2
						SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
						Found = #True
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To CountString(#SCI_Indent_KEY_Transition, " ") + 1
					If FindString(Text, StringField(#SCI_Indent_KEY_Transition, n, " "), 1) = 1
						SCI_SetLineIdentation(Gadget, Line, (CurrentIdent - 1) * SCI_GetTabWidth(Gadget))
						Found = #True
					EndIf
				Next n
			EndIf
		EndIf
		If Not Found
			SCI_SetLineIdentation(Gadget, Line, CurrentIdent * SCI_GetTabWidth(Gadget))
		EndIf
	Next Line
EndProcedure


Procedure.s GetReciproque(Key.s)
	If Not Key
		ProcedureReturn ""
	EndIf
	Protected n
	key = LCase(Key)
	For n=1 To CountString(KeyWordUp, " ") + 1
		If LCase(StringField(KeyWordUp, n, " ")) = key
			ProcedureReturn StringField(KeyWordDown, n, " ")
		EndIf
	Next n
	ProcedureReturn ""
EndProcedure

Procedure CheckIdent(Gadget, Line)
	Protected txt.s, indent.l, n.l
	indent = SCI_GetLineIdentation(Gadget, line)
	SCI_SetLineIdentation(Gadget, line, 0)
	txt = StringField(SCI_GETLINE(Gadget, line), 1, " ")
	SCI_SetLineIdentation(Gadget, line, indent)
	txt = GetReciproque(txt)
	If txt
		SCI_AddText(Gadget, #LF$ + txt)
		SCI_SetLineIdentation(Gadget, line + 2, indent + SCI_GetTabWidth(Gadget))
		SCI_SetLineIdentation(Gadget, line + 1, indent)
		SCI_SetPosition(Gadget, SCI_GetLineEndPosition(Gadget, line + 1))
	EndIf
EndProcedure

Procedure.s GetFunctionProto(Gadget, Position)
	Protected Ligne = SCI_LineFromPosition(gadget, Position)
	Protected LigneSize = SCI_LineLength(gadget, Ligne)
	Protected Char, txt.s, LastPosition = SCI_GetLineEndPosition(gadget, Ligne) - LigneSize
	Protected Iteration, currentpos = Position
	While currentpos >= LastPosition
		Char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
		Select Char
			Case ')'
				Iteration + 1
			Case '('
				If Iteration
					Iteration - 1
				Else
					currentpos - 1
					While currentpos >= LastPosition And ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos) = ' '
						currentpos - 1
					Wend
					txt = ""
					Char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
					While currentpos >= LastPosition And ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_')
						txt = Chr(Char) + txt
						currentpos - 1
						Char = ScintillaSendMessage(Gadget, #SCI_GETCHARAT, currentpos)
					Wend
					If txt
						ProcedureReturn GetFunctionProtoFromName(*System, txt)
					EndIf
				EndIf
				
		EndSelect
		currentpos - 1
	Wend
	
	
	ProcedureReturn ""
EndProcedure


ProcedureDLL ScintillaCallBack(*Gadget, *scinotify.SCNotification)
	If Not *Gadget = GetCurrentScintillaGadget(*System)
		ProcedureReturn
	EndIf
	Protected CurrentPos = SCI_GetPosition(*Gadget), CurrentLine = SCI_LineFromPosition(*Gadget, CurrentPos)
	SetStatusBarText(*System\IHM, 0, "Ligne: " + Str(SCI_LineFromPosition(*Gadget, CurrentPos)) +  " Colone: " + Str(CurrentPos) + " Mode: " + *System\Prefs.GetPreference("GENERAL", "structure"))
	SetStatusBarText(*System\IHM, 1, GetFunctionProto(*Gadget, CurrentPos))
	Select *scinotify\nmhdr\code
		Case #SCN_DOUBLECLICK
			Protected LigneTxt.s = Trim(RemoveString(SCI_GETLINE(*Gadget, SCI_LineFromPosition(*Gadget, CurrentPos)), Chr(9)))
			TryOpenFile(*System, StringField(LigneTxt, 2, Chr(34)))
		Case #SCN_CHARADDED
			CheckUndoRedo(*System)
			If *scinotify\ch = 10
				CurrentLine = SCI_LineFromPosition(*Gadget, CurrentPos) - 1
				SCI_ResizeMargins(*Gadget)
				;CheckIdent(Gadget, CurrentLine)
			EndIf
			If ((*scinotify\ch>='A' And  *scinotify\ch<='Z') Or  (*scinotify\ch>='a' And *scinotify\ch<='z') Or *scinotify\ch='_')
				AutoComplete(*Gadget, CurrentPos)
			EndIf
		Case #SCN_MODIFIED
			Select *scinotify\modificationType
				Case #SC_PERFORMED_USER | #SC_MOD_BEFOREINSERT, #SC_PERFORMED_UNDO | #SC_MOD_BEFOREINSERT, #SC_PERFORMED_REDO | #SC_MOD_BEFOREINSERT
					CurrentFileModified(*System, *Gadget)
					CheckUndoRedo(*System)
				Case #SC_PERFORMED_USER | #SC_MOD_BEFOREDELETE, #SC_PERFORMED_UNDO | #SC_MOD_BEFOREDELETE, #SC_PERFORMED_REDO | #SC_MOD_BEFOREDELETE
					CurrentFileModified(*System, *Gadget)
					CheckUndoRedo(*System)
			EndSelect
		Case #SCN_STYLENEEDED
			Highlight(*Gadget, *scinotify\position)
		Case #SCN_MARGINCLICK
			ScintillaSendMessage(*Gadget, #SCI_TOGGLEFOLD, ScintillaSendMessage(*Gadget, #SCI_LINEFROMPOSITION, *scinotify\Position))
		Default
	EndSelect
EndProcedure
