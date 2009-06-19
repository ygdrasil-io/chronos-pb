Class File Extends Node
	Path.s
	File.s
	Text.s
	Saved.b
	*Comment.Comment
	
	Procedure File()
		*this\Child = New Array()
		*this\Type = #Node_File
		*this\Saved = 1
		*this\Comment = New Comment()
		;*this.AddChild(*this\Comment)
		
	EndProcedure
	
	Procedure.s GetPath()
		ProcedureReturn *this\Path
	EndProcedure
	

EndClass


Procedure LoadStructure(*this.File)
	;	*this\Comment.RemoveAll()
	;	*this\Function.RemoveAll()
	Protected n,  text.s, position, temp.s, *ptr
	For n = 1 To  CountString(*this\Text, #LF$)
		text  = Trim(StringField(*this\Text, n,  #LF$))
		position = FindStringNotInString(text , ";-", '"')
		If position
			*ptr = New Comment::Item(Mid(text, position + 2),  n, *this\Path)
			If *Ptr
				*this\Comment.AddChild(*Ptr)
			EndIf
		EndIf
		
	Next  n
EndProcedure

Procedure File_LoadFile(Path.s)
	Path = ReplaceString(Path, "\", "/")
	If FileSize(Path) >= 0
		Protected *this.File = New File()
		*this\Path = Path
		*this\File = GetFilePart(Path)
		Protected FileID = OpenFile(#PB_Any, Path)
		If FileID
			Protected DOM = ReadStringFormat(FileID)
			Select DOM
				Case #PB_Ascii, #PB_UTF8, #PB_Unicode
				Default
					ProcedureReturn 0
			EndSelect
			While Not Eof(FileID)
				If *this\Text
					*this\Text + #LF$
				EndIf
				*this\Text + Trim(ReadString(FileID, DOM))
			Wend
			CloseFile(FileID)
			LoadStructure(*this)
		Else
			ProcedureReturn 0
		EndIf
		ProcedureReturn *this
	Else
		ProcedureReturn 0
	EndIf
EndProcedure

Procedure saveFileIn(*Gadget.Scintilla, File.s)
	Protected FileID = CreateFile(#PB_Any, File), n
	TruncateFile(FileID)
	WriteStringFormat(FileID, #PB_UTF8)
	For n=0 To *Gadget.GETLINECOUNT() - 1
		WriteStringN(FileID, *Gadget.GETLINE(n), #PB_UTF8)
	Next n
	CloseFile(FileID)
EndProcedure

Procedure SaveFile(*this.File, *Gadget.Scintilla)
	If Not *this\Path
		Protected Path.s = SaveFileRequester(GetText("Misc-SavingFile"), "", "Files Sources(*.pb;*.pbi)|*.pb;*.pbi" , 0)
		If Path = ""
			ProcedureReturn 0
		EndIf
		If Right(Path, Len(".pb")) <> ".pb" And Right(Path, Len(".pbi")) <> ".pbi"
			Path + ".pb"
		EndIf
		*this\Path= Path
		*this\File = GetFilePart(Path)
	EndIf
	Protected FileID
	If FileSize(*this\Path) = -1
		FileID = CreateFile(#PB_Any, *this\Path)
	Else
		FileID = OpenFile(#PB_Any, *this\Path)
	EndIf
	If Not FileID
		ProcedureReturn -2
	Else
		Protected n
		TruncateFile(FileID)
		WriteStringFormat(FileID, #PB_UTF8)
		For n=0 To *Gadget.GETLINECOUNT() - 1
			WriteStringN(FileID, *Gadget.GETLINE(n), #PB_UTF8)
		Next n
		CloseFile(FileID)
		*this\saved = 1
		ProcedureReturn 1
	EndIf
EndProcedure

;Procedure.s File_GetFunctionList(*this.File)
;	Protected n,  retour.s
;	For n = 1 To  *this\Function.CountElement()
;		retour  + Function_GetName(*this\Function.GetElement( n))  + "("  + " "
;	Next  n
;	ProcedureReturn retour
;EndProcedure

Procedure FreeFile(*this.File)
	FreeMemory(*this)
EndProcedure
