#KeyWordColor = $F90806
#MacroColor = $578A49
Global KeyWordUp.s
Global KeyWordDown.s
Global KeyWordNone.s
;Global KeyWord.s
KeyWordUp = "Macro ProcedureCDLL PorcedureC ProcedureDLL CompilerCondition Procedure If For While Repeat Reapeat"
KeyWordUp + " Class Structure Enumeration Method Select CompilerIf CompilerSelect StaticProcedure"
KeyWordDown = "EndIf EndProcedure CompilerEndCondition Next Wend Until ForEver EndClass EndMacro EndStructure EndEnumeration"
KeyWordDown + " EndMethod EndSelect CompilerEndIf CompilerEndSelect"
KeyWordNone = "Step Break And ElseIf XIncludeImport Or Not ForEach IncludeImport Else To IncludeFile EnableExplicit"
KeyWordNone + " DisableExplicit Case Default End CompilerElse ProcedureReturn Global Define Protected Debug NewList"
KeyWordNone + " XIncludeFile As New Extends CompilerCase Declare"


#KeyWordUp = "Macro ProcedureCDLL PorcedureC ProcedureDLL CompilerCondition Procedure If For While Repeat Reapeat Class Structure Enumeration Method Select CompilerIf CompilerSelect StaticProcedure"
#KeyWordUp_Number = 19
#KeyWord = "As And Break Case Class CompilerSelect CompilerCase CompilerEndIf CompilerIf CompilerElse CompilerEndSelect CompilerCondition CompilerEndCondition Debug Default Define Declare DisableExplicit DisableDebugger End EndIf Else ElseIf EndSelect Enumeration EndProcedure EndMacro EndStructure EndEnumeration EndClass Extends EnableExplicit EnableDebugger Goto For ForEach ForEver If IncludeFile IncludeImport Global Macro Not Next New NewList Protected Procedure ProcedureReturn ProcedureCDLL PorcedureC ProcedureDLL Or Repeat Select Structure Step StaticProcedure To Until While Wend XIncludeFile XIncludeImport"
#KeyWord_Number = 64

;2 As And
;1 Break
;10 Case Class CompilerSelect CompilerCase CompilerEndIf CompilerIf CompilerElse CompilerEndSelect CompilerCondition CompilerEndCondition
;6 Debug Default Define Declare DisableExplicit
;14 End EndIf Else ElseIf EndSelect Enumeration EndProcedure EndMacro EndStructure EndEnumeration EndClass Extends EnableExplicit EnableDebugger
;1 Goto
;3 For ForEach ForEver
;3 If IncludeFile IncludeImport
;1 Global
;1 Macro
;4 Not Next New NewList
;6 Protected Procedure ProcedureReturn ProcedureCDLL PorcedureC ProcedureDLL
;1 Or
;1 Repeat
;4 Select Structure Step StaticProcedure
;1 To
;1 Until
;2 While Wend
;2 XIncludeFile XIncludeImport



Enumeration 0
	#LexerState_Function
	#LexerState_Space
	#LexerState_Comment
	#LexerState_NonKeyword
	#LexerState_Keyword
	#LexerState_FoldKeyword
	#LexerState_Constant
	#LexerState_String
	#LexerState_FoldKeywordUp
	#LexerState_FoldKeywordDown
	#LexerState_Operator
EndEnumeration

Procedure KeyWordIs(key.s)
	Protected n
	If key=""
		ProcedureReturn -1
	EndIf
	key = LCase(key)
	For n=1 To #KeyWordUp_Number
		If LCase(StringField(#KeyWordUp, n, " ")) = key
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

#SCI_Folding_KEY_UP = "procedure macro class proceduredll procedurec procedurecdll staticprocedure"
#SCI_Folding_KEY_UP_Number = 7
#SCI_Folding_KEY_Down = "endprocedure endmacro endclass"
#SCI_Folding_KEY_Down_Number = 3

Procedure IsBreakLine(*Gadget.Scintilla, line)
	Protected Text.s, n
	Protected Position = *Gadget.POSITIONFROMLINE(Line)
	Protected char = *Gadget.GetCharAt(Position)
	While char = 9 Or char = ' '
		Position + 1
		char = *Gadget.GetCharAt(Position)
	Wend
	char = Asc(LCase(Chr(char)))
	While char >= 'a' and char <= 'z'
		Text + LCase(Chr(char))
		Position + 1
		char = Asc(LCase(Chr(*Gadget.GetCharAt(Position))))
	Wend
	Select char
		Case '.', ' ', 9, 10,'(', ';'
		Default
			ProcedureReturn #False
	EndSelect
	For n = 1 To #SCI_Folding_KEY_Down_Number
		If Text = StringField(#SCI_Folding_KEY_Down, n, " ")
			ProcedureReturn #True
		EndIf
	Next n	
	ProcedureReturn #False
EndProcedure

Procedure Highlight(*Gadget.Scintilla, endpos.l)
	Protected char.l, keyword.s, state.i, linenumber.l
	Protected currentline.l = *Gadget.LINEFROMPOSITION(*Gadget.GetEndStyled())
	Protected currentpos.l = *Gadget.POSITIONFROMLINE(currentline)
	Protected endlinepos.l, startkeyword
	Protected tempPosition, level
	Protected Found, n
	If currentline = 0
		level = #SC_FOLDLEVELBASE
	Else
		level = *Gadget.GetFoldLevel(currentline - 1) & ~ #SC_FOLDLEVELHEADERFLAG
		If  *Gadget.GetFoldLevel(currentline - 1) & #SC_FOLDLEVELHEADERFLAG = #SC_FOLDLEVELHEADERFLAG
			level + 1
		EndIf
		If IsBreakLine(*Gadget, currentline - 1)
			level - 1
		EndIf
	EndIf
	endpos = *Gadget.GetLineEndPosition(*Gadget.LineFromPosition(endpos))
	ScintillaSendMessage(*Gadget, #SCI_STARTSTYLING, currentpos, $1f | #INDICS_MASK)
	While currentpos <= endpos
		char = *Gadget.GetCharAt(currentpos)
		Select char
			Case '%', '*', '=', '+', '-', '/', '|', '&', '.', '\'
				If char = '*'
					If (currentpos + 1) > endpos Or Not *Gadget.LineFromPosition(currentpos) = *Gadget.LineFromPosition(currentpos + 1)
						ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
					Else
						Select ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1)
							Case '_', 'a' To 'z', 'A' To 'Z'
								tempPosition = currentpos - 1
								While tempPosition >= 0 And ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, tempPosition) = ' ' And *Gadget.LineFromPosition(tempPosition) = *Gadget.LineFromPosition(tempPosition + 1)
									tempPosition - 1
								Wend
								If *Gadget.LineFromPosition(tempPosition) = *Gadget.LineFromPosition(tempPosition + 1) And tempPosition > 0
									Select ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, tempPosition)
										Case '_', 'a' To 'z', 'A' To 'Z', '0' To '9'
											ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
										Default
											ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
									EndSelect
								Else
									ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
								EndIf
							Default
								ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
						EndSelect
					EndIf
				Else
					ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_Operator)
				EndIf
				
			Case 10
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
				If Not Found
					*Gadget.SetFoldLevel(currentline, level)
				Else
					Found = #False
				EndIf
				currentline + 1
			Case 'a' To 'z', 'A' To 'Z'
				endlinepos = *Gadget.GetLineEndPosition(*Gadget.LineFromPosition(currentpos))
				keyword = Chr(char)
				While currentpos < endlinepos
					currentpos + 1
					char = *Gadget.GetCharAt(currentpos)
					If Not ((char >= 'a' And char <= 'z') Or (char >= 'A' And char <= 'Z') Or char = '_' Or (char >= '0' And char <= '9'))
						currentpos-1
						Break
					EndIf
					keyword + Chr(char)
				Wend
				If Not Found
					For n = 1 To #SCI_Folding_KEY_UP_Number
						If LCase(keyword) = StringField(#SCI_Folding_KEY_UP, n, " ")
							*Gadget.SetFoldLevel(currentline, level | #SC_FOLDLEVELHEADERFLAG)
							Found = #True
							level + 1
							Break
						EndIf
					Next n
					If Not Found
						For n = 1 To #SCI_Folding_KEY_DOWN_Number
							If LCase(keyword) = StringField(#SCI_Folding_KEY_Down, n, " ")
								*Gadget.SetFoldLevel(currentline, level)
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
					char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, tempPosition)
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
				
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, Len(keyword), state)
			Case '"'
				endlinepos = *Gadget.GetLineEndPosition(*Gadget.LineFromPosition(currentpos))
				startkeyword = 1
				While currentpos < endlinepos
					currentpos + 1
					startkeyword + 1
					If ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos) = '"'
						Break
					EndIf
				Wend
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, startkeyword, #LexerState_String)
			Case 39
				startkeyword = 1
				If Not ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1) = 10
					startkeyword + 1
					currentpos + 1
					If ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1) = 39
						startkeyword + 1
						currentpos + 1
					EndIf
				EndIf
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, startkeyword, #LexerState_String)
			Case ';' ;commentaire
				startkeyword = 1
				If ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1) = '{'
					*Gadget.SetFoldLevel(currentline, level | #SC_FOLDLEVELHEADERFLAG)
					Level + 1
					Found = #True
					currentpos + 1
					startkeyword + 1
				ElseIf ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1) = '}'
					*Gadget.SetFoldLevel(currentline, level)
					Level - 1
					If level < #SC_FOLDLEVELBASE
						level = #SC_FOLDLEVELBASE
					EndIf
					Found = #True
					currentpos + 1
					startkeyword + 1
				EndIf
				
				While Not ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos + 1) = 10 And currentpos <= endpos
					currentpos + 1
					startkeyword + 1
				Wend
				
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, startkeyword, #LexerState_Comment)
			Case 9, ' '
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_Space)
			Case '#'
				endlinepos = *Gadget.GetLineEndPosition(*Gadget.LineFromPosition(currentpos))
				startkeyword = 1
				While currentpos < endlinepos
					currentpos + 1
					char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos)
					If Not ((char >= 'a' And char <= 'z') Or (char >= 'A' And char <= 'Z') Or char = '_' Or (char >= '0' And char <= '9'))
						currentpos-1
						Break
					EndIf
					startkeyword + 1
				Wend
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, startkeyword, #LexerState_Constant)
			Default
				ScintillaSendMessage(*Gadget, #SCI_SETSTYLING, 1, #LexerState_NonKeyword)
		EndSelect
		currentpos+1
	Wend
EndProcedure


Procedure AutoComplete(*Gadget.Scintilla, Pos.l)
	Protected Char, txt.s, currentpos = Pos, Line = *Gadget.LineFromPosition(Pos), KeyWord.s
	Protected FirstPosition = *Gadget.GetPositionFromLine(Line)
	txt = Left(*Gadget.GETLINE(line), Pos - FirstPosition)
	If Not CountString(txt, Chr(34))%2 = 0
		ProcedureReturn
	EndIf
	txt = ""
	char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos)
	While ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_') And currentpos >= FirstPosition
		txt + Chr(char)
		currentpos + 1
		char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos)
	Wend
	currentpos = pos - 1
	char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos)
	While ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_') And currentpos >= FirstPosition
		txt = Chr(char) + txt
		currentpos - 1
		char = ScintillaSendMessage(*Gadget, #SCI_GETCHARAT, currentpos)
	Wend
	If currentpos >= FirstPosition
		Select char
			Case '#'
				KeyWord = ""
			Case ':'
				KeyWord = ""
			Case '.'
				KeyWord = " " + CompilerStructure
			Case '\'
				KeyWord = ""
			Default
				KeyWord = " " + #KeyWord + " " + CompilerFunction  + " " + GetFunctionList(*System) + " "
		EndSelect
	Else
		KeyWord = " " + KeyWordUp + " " + KeyWordDown + " " + KeyWordNone + " " + CompilerFunction  + " " + GetFunctionList(*System) + " "
	EndIf
	If ScintillaSendMessage(*Gadget,#SCI_AUTOCACTIVE)
		ScintillaSendMessage(*Gadget,#SCI_AUTOCCANCEL)
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
			ScintillaSendMessage(*Gadget, #SCI_AUTOCSHOW, Len(txt), *ptr)
			FreeMemory(*ptr)
		EndIf
	EndIf
EndProcedure

;#SCI_Indent_KEY_UP_ = "procedure procedurec procedurecdll proceduredll staticprocedure"
;#SCI_Indent_KEY_UP__Number = 5
#SCI_Indent_KEY_UP = "if while repeat procedure procedurec procedurecdll proceduredll for class compilerif structure enumeration macro  foreach compilercondition staticprocedure"
#SCI_Indent_KEY_UP_Number = 17
#SCI_Indent_KEY_UP2 = "select "
#SCI_Indent_KEY_Down = "endif endprocedure next wend forever until endclass compilerendif endstructure endenumeration endmacro compilerendcondition"
#SCI_Indent_KEY_Down_Number = 12
#SCI_Indent_KEY_Down2 = "endselect"
#SCI_Indent_KEY_Transition = "else case elseif compilerelse default"
#SCI_Indent_KEY_Transition_Number = 5

Procedure AutoIdent(*Gadget.Scintilla)
	Protected Line.l , Text.s, CurrentIdent = 0, n, Position.l, char.l
	Protected TabWidth.b = *Gadget.GetTabWidth(), MaxLine = *Gadget.GETLINECOUNT()
	Protected Found.b
	For Line = 0 To MaxLine
		Text = ""
		Found = #False
		Position = *Gadget.POSITIONFROMLINE(Line)
		char = *Gadget.GetCharAt(Position)
		While char = 9 Or char = ' '
			Position + 1
			char = *Gadget.GetCharAt(Position)
		Wend
		char = Asc(LCase(Chr(char)))
		While char >= 'a' and char <= 'z'
			Text + LCase(Chr(char))
			Position + 1
			char = Asc(LCase(Chr(*Gadget.GetCharAt(Position))))
		Wend
		Select char
			Case '.', ' ', 9, 10,'(', ';'
			Default
				*Gadget.SetLineIdentation(Line, CurrentIdent * TabWidth)
				Found = #True
		EndSelect
		If Text
			If Not Found
				For n = 1 To #SCI_Indent_KEY_UP_Number
					If Text = StringField(#SCI_Indent_KEY_UP, n, " ")
						*Gadget.SetLineIdentation(Line, CurrentIdent * TabWidth)
						CurrentIdent + 1
						Found = #True
						Break
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To 1
					If Text = StringField(#SCI_Indent_KEY_UP2, n, " ")
						*Gadget.SetLineIdentation(Line, CurrentIdent * TabWidth)
						CurrentIdent + 2
						Found = #True
						Break
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To #SCI_Indent_KEY_Down_Number
					If Text = StringField(#SCI_Indent_KEY_Down, n, " ")
						CurrentIdent - 1
						*Gadget.SetLineIdentation(Line, CurrentIdent * TabWidth)
						Found = #True
						Break
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To 1
					If Text = StringField(#SCI_Indent_KEY_Down2, n, " ")
						CurrentIdent - 2
						*Gadget.SetLineIdentation(Line, CurrentIdent * TabWidth)
						Found = #True
						Break
					EndIf
				Next n
			EndIf
			If Not Found
				For n = 1 To #SCI_Indent_KEY_Transition_Number
					If FindString(Text, StringField(#SCI_Indent_KEY_Transition, n, " "), 1) = 1
						*Gadget.SetLineIdentation(Line, (CurrentIdent - 1) * TabWidth)
						Found = #True
						Break
					EndIf
				Next n
			EndIf
		EndIf
		If Not Found
			*Gadget.SetLineIdentation(Line, CurrentIdent * *Gadget.GetTabWidth())
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

Procedure CheckIdent(*Gadget.Scintilla, Line)
	Protected txt.s, indent.l, n.l
	indent = *Gadget.GetLineIdentation(line)
	*Gadget.SetLineIdentation(line, 0)
	txt = StringField(*Gadget.GETLINE(line), 1, " ")
	*Gadget.SetLineIdentation(line, indent)
	txt = GetReciproque(txt)
	If txt
		*Gadget.AddText(#LF$ + txt)
		*Gadget.SetLineIdentation(line + 2, indent + *Gadget.GetTabWidth())
		*Gadget.SetLineIdentation(line + 1, indent)
		*Gadget.SetPosition(*Gadget.GetLineEndPosition(line + 1))
	EndIf
EndProcedure

Procedure.s GetFunctionProto(*Gadget.Scintilla, Position)
	Protected Ligne = *Gadget.LineFromPosition(Position)
	Protected LigneSize = *Gadget.LineLength(Ligne)
	Protected Char, txt.s, LastPosition = *Gadget.GetLineEndPosition(Ligne) - LigneSize
	Protected Iteration, currentpos = Position
	If *Gadget.GetCharAt(currentpos) = ')'
		currentpos - 1
	EndIf
	While currentpos >= LastPosition
		Char = *Gadget.GetCharAt(currentpos)
		Select Char
			Case ')'
				Iteration + 1
			Case '('
				If Iteration
					Iteration - 1
				Else
					currentpos - 1
					While currentpos >= LastPosition And  *Gadget.GetCharAt(currentpos) = ' '
						currentpos - 1
					Wend
					txt = ""
					Char =*Gadget.GetCharAt(currentpos)
					While currentpos >= LastPosition And ((char>='A' And  char<='Z') Or  (char>='a' And char<='z') Or char='_')
						txt = Chr(Char) + txt
						currentpos - 1
						Char = *Gadget.GetCharAt(currentpos)
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


ProcedureDLL ScintillaCallBack(*Gadget.Scintilla, *scinotify.SCNotification)
	If Not *Gadget = GetCurrentScintillaGadget(*System)
		ProcedureReturn
	EndIf
	Protected CurrentPos = *Gadget.GetPosition()
	protected CurrentLine = *Gadget.LineFromPosition(CurrentPos)
	protected Indent.l
	SetStatusBarText(*System, 0, "Ligne: " + Str(*Gadget.LineFromPosition(CurrentPos)) +  " Colone: " + Str(CurrentPos) + " Mode: " + *System\Prefs.GetPreference("GENERAL", "structure"))
	SetStatusBarText(*System, 1, GetFunctionProto(*Gadget, CurrentPos))
	Select *scinotify\nmhdr\code
		Case #SCN_DOUBLECLICK
			Protected LigneTxt.s = Trim(RemoveString(*Gadget.GETLINE(*Gadget.LineFromPosition(CurrentPos)), Chr(9)))
			TryOpenFile(*System, StringField(LigneTxt, 2, Chr(34)))
		Case #SCN_CHARADDED
			CheckUndoRedo(*System)
			If *scinotify\ch = 10
				Indent = *Gadget.GetLineIdentation(CurrentLine - 1)
				*Gadget.ResizeMargins()
				*Gadget.SetLineIdentation(CurrentLine, Indent)
				*Gadget.SetPosition(*Gadget.PositionFromLine(CurrentLine) + (Indent / *Gadget.GetTabWidth()))
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
