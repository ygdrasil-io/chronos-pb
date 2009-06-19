#Node_Directory = 1
#Node_File = 2
#Node_RootComment = 3
#Node_Comment = 10


Class Directory Extends Node
	;	*File.Array = new Array()
	Name.s
	
	Procedure Directory(Path.s)
		*this\Type = #Node_Directory
		*this\Child = New Array()
		*this\Name = ReplaceString(Path, "\", "/")
		Protected DirID = ExamineDirectory(#PB_Any, *this\Name, "*"), File.s, Ext.s
		If Not DirID
			ProcedureReturn 0
		EndIf
		While NextDirectoryEntry(DirID)
			Select DirectoryEntryType(DirID)
				Case #PB_DirectoryEntry_Directory
					File = DirectoryEntryName(DirID)
					If Not (File = "." Or File = ".." Or File = ".svn")
						File = Path + DirectoryEntryName(DirID) + "/"
						*this\Child.AddElement(New Directory(File))
					EndIf
			EndSelect
		Wend
		FinishDirectory(DirID)
		DirID = ExamineDirectory(#PB_Any, *this\Name, "*.pb")
		If Not DirID
			ProcedureReturn 0
		EndIf
		While NextDirectoryEntry(DirID)
			Select DirectoryEntryType(DirID)
				Case #PB_DirectoryEntry_File
					File = Path + DirectoryEntryName(DirID)	
					Ext = LCase(GetExtensionPart(File))
					If Ext = "pb" Or Ext = "pbi"
						*this\Child.AddElement(File_LoadFile(File))
					EndIf
			EndSelect
		Wend
		FinishDirectory(DirID)
		DirID = ExamineDirectory(#PB_Any, *this\Name, "*.pbi")
		If Not DirID
			ProcedureReturn 0
		EndIf
		While NextDirectoryEntry(DirID)
			Select DirectoryEntryType(DirID)
				Case #PB_DirectoryEntry_File
					File = Path + DirectoryEntryName(DirID)	
					Ext = LCase(GetExtensionPart(File))
					If Ext = "pb" Or Ext = "pbi"
						*this\Child.AddElement(File_LoadFile(File))
					EndIf
			EndSelect
		Wend
		FinishDirectory(DirID)
	EndProcedure
	
	Procedure.s GetNodeName()
		ProcedureReturn StringField(*this\Name, CountString(*this\Name, "/"), "/")
	EndProcedure
	
	
;	Procedure RemoveFile(Number)
;		Protected n, *Dir.Directory, Count, *File
;		For n = 1 To *this\Child.CountElement()
;			Number - 1
;			*Dir = *this\Child.GetElement(n)
;			If Number = 0
;				*this\Child.FreeElement(n)
;				ProcedureReturn *Dir
;			EndIf
;			Count = Directory_CountElement(*Dir)
;			If Number <= Count
;				ProcedureReturn Directory_RemoveFile(*Dir, Number)
;			Else
;				Number - Count
;			EndIf
;		Next n
;		*File = *this\Child.GetElement(Number)
;		*this\File.FreeElement(Number)
;		ProcedureReturn *File
;	EndProcedure
EndClass



Procedure Directory_CountElement(*this.Directory)
	Protected Count.l =*this\Child.CountElement(), n, *Dir.Directory
	For n = 1 To *this\Child.CountElement()
		*Dir = *this\Child.GetElement(n)
		Count + Directory_CountElement(*Dir)
	Next n
	ProcedureReturn Count
EndProcedure

Procedure Directory_FileIs(*this.Directory, Number.i)
	Protected n, *Dir.Directory, Count
	If Number = 0
		ProcedureReturn #Node_Directory
	EndIf
	For n = 1 To *this\Child.CountElement()
		Number - 1
		If Number = 0
			ProcedureReturn #Node_Directory
		EndIf
		*Dir = *this\Child.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_FileIs(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	ProcedureReturn 0
EndProcedure

;Procedure Directory_GetFile(*this.Directory, Number)
;	Protected n, *Dir.Directory, Count
;	If Number = 0
;		ProcedureReturn *this
;	EndIf
;	For n = 1 To *this\Child.CountElement()
;		Number - 1
;		*Dir = *this\Child.GetElement(n)
;		Count = Directory_CountElement(*Dir)
;		If Number <= Count
;			ProcedureReturn Directory_GetFile(*Dir, Number)
;		Else
;			Number - Count
;		EndIf
;	Next n
;	ProcedureReturn *this\ChildGetElement(Number)
;EndProcedure

;Procedure AddFilesToTree(*this.Directory, *IHM.IHM, Level.i)
;	Protected n, *File.File
;	AddGadgetItem(*IHM\Gadget[#GD_TreeProject], -1, *this\Name, ImageID(*IHM\Image[#ImageIcon_Directory]), Level)
;	Level + 1
;	For n = 1 To *this\Child.CountElement()
;		AddFilesToTree(*this\Child.GetElement(n), *IHM, Level)
;	Next n
;	For n = 1 To *this\File.CountElement()
;		*File = *this\File.GetElement(n)
;		AddGadgetItem(*IHM\Gadget[#GD_TreeProject], -1, GetFilePart(*File\Path), ImageID(*IHM\Image[#ImageIcon_FileTree]), Level)
;	Next n
;EndProcedure

Procedure Directory_IsFile(*this.Directory, *File)
	Protected n
	;	For n = 1 To *this\File.CountElement()
	;		If *File = *this\File.GetElement(n)
	;			ProcedureReturn #True
	;		EndIf
	;	Next n
	For n = 1 To *this\Child.CountElement()
		If Directory_IsFile(*this\Child.GetElement(n), *File)
			ProcedureReturn #True
		EndIf
	Next n
	ProcedureReturn #False
EndProcedure

Procedure.s Directory_GetFilePath(*this.Directory, Number.l)
	Protected n, *Dir.Directory, Count
	If Number = 0
		ProcedureReturn *this\Name + "/"
	EndIf
	For n = 1 To *this\Child.CountElement()
		Number - 1
		*Dir = *this\Child.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_GetFilePath(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	ProcedureReturn *this\Name + "/"
EndProcedure

;Procedure Directory_RemoveFile(*this.Directory, Number)
;	Protected n, *Dir.Directory, Count, *File
;	If Number = 0
;		ProcedureReturn #Null
;	EndIf
;	For n = 1 To *this\Child.CountElement()
;		Number - 1
;		*Dir = *this\Child.GetElement(n)
;		Count = Directory_CountElement(*Dir)
;		If Number <= Count
;			ProcedureReturn Directory_RemoveFile(*Dir, Number)
;		Else
;			Number - Count
;		EndIf
;	Next n
;	*File = *this\Child.GetElement(Number)
;	*this\File.FreeElement(Number)
;	ProcedureReturn *File
;EndProcedure

;Procedure Directory_AddFile(*this.Directory, *File)
;	*this\File.AddElement(*File)
;EndProcedure

