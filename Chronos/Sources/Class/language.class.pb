Global *Lang.Preference


Procedure NewLanguage(File.s)
	Protected Current.s, FileID.i, Langue.s = GetFilePart(File), Position.l, Section.s
	FileID = OpenFile(#PB_Any, File)
	If IsFile(FileID)
		ReadString(FileID, #PB_Unicode)
		While Eof(FileID) = 0
			Current = ReadString(FileID, #PB_Unicode)
			Current = Trim(Current)
			If Not (Left(Current, 1) = ";" Or Len(Current) = 0)
				If Left(Current, 1) = "[" And Right(Current, 1) = "]"
					Section = Mid(Current, 2, Len(Current) - 2)
				Else
					Position = FindString(Current, ":", 1)
					If Position > 0
						*Lang.SetPreference(Langue, Section + "-" +Left(Current, Position - 1) , Right(Current, Len(Current) - Position))
					EndIf
				EndIf
			EndIf
		Wend
		CloseFile(FileID)
	Else
		MessageRequester("Error", "Language Loading Error")
		SystemEnd(*System)
	EndIf
EndProcedure

Procedure LoadLanguage()
	*Lang = New Preference("lang")
	Protected Dir.i = ExamineDirectory(#PB_Any, *System\Prefs.GetPreference("GENERAL", "MainPath") + "Language", "")
	If Dir
		While NextDirectoryEntry(Dir)
			If DirectoryEntryType(Dir) = #PB_DirectoryEntry_File
				NewLanguage(*System\Prefs.GetPreference("GENERAL", "MainPath")  + "/Language/" + DirectoryEntryName(Dir))
			EndIf
		Wend
		FinishDirectory(Dir)
	Else
		MessageRequester("Error", "Language Loading Error")
		SystemEnd(*System)
	EndIf
EndProcedure

Procedure.s GetText(Key.s)
	ProcedureReturn *Lang.GetPreference(*System\Prefs.GetPreference("GENERAL", "Lang"), Key)
EndProcedure
