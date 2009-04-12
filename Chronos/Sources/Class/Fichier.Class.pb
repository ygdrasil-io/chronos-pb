Procedure NewFile()
	Protected *this.File = AllocateMemory(SizeOf(File))
	*this\Saved = 1
	*this\Comment = new Array()
	*this\Function = new Array()
	ProcedureReturn *this
EndProcedure

Macro RemoveFileStructure(this)
	RemoveAll(this\Comment)
EndMacro

Procedure LoadStructure(*this.File)
	*this\Comment.RemoveAll()
	*this\Function.RemoveAll()
	Protected n,  text.s, position, temp.s
	For n = 1 To  CountString(*this\Text, #LF$)
		text  = Trim(StringField(*this\Text, n,  #LF$))
		position = FindStringNotInString(text , ";-", '"')
		If position
			*this\Comment.AddElement(NewComment(Mid(text, position + 2),  n, *this\Path))
		EndIf
		temp = LCase(Left(text, 10))
		If temp = "procedure " Or temp = "procedure."
			*this\Function.AddElement(NewFunction(Trim(Mid(text, FindString(text, " ", 1))),  n, *this\Path))
		EndIf
	Next  n
EndProcedure

Procedure File_LoadFile(Path.s)
	Path = ReplaceString(Path, "\", "/")
	If FileSize(Path) >= 0
		Protected *this.File = NewFile()
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

Procedure saveFileIn(Gadget.i, File.s)
	Protected FileID = CreateFile(#PB_Any, File), n
	TruncateFile(FileID)
	WriteStringFormat(FileID, #PB_UTF8)
	For n=0 To SCI_GETLINECOUNT(Gadget) - 1
		WriteStringN(FileID, SCI_GETLINE(Gadget, n), #PB_UTF8)
	Next n
	CloseFile(FileID)
EndProcedure

Procedure SaveFile(*this.File, Gadget.i)
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
		For n=0 To SCI_GETLINECOUNT(Gadget) - 1
			WriteStringN(FileID, SCI_GETLINE(Gadget, n), #PB_UTF8)
		Next n
		CloseFile(FileID)
		*this\saved = 1
		ProcedureReturn 1
	EndIf
EndProcedure

Procedure.s File_GetFunctionList(*this.File)
	Protected n,  retour.s
	For n = 1 To  *this\Function.CountElement()
		retour  + Function_GetName(*this\Function.GetElement( n))  + "("  + " "
	Next  n
	ProcedureReturn retour
EndProcedure

Procedure FreeFile(*this.File)
	FreeMemory(*this)
EndProcedure
