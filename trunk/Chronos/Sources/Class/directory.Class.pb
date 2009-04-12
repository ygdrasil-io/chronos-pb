Procedure NewDirectory(Path.s)
	Protected *this.Directory = AllocateMemory(SizeOf(Directory))
	*this\File = new Array()
	*this\Dir = new Array()
	*this\Name = StringField(Path, CountString(Path, "/"), "/")
	Protected DirID = ExamineDirectory(#PB_Any, Path, "*"), File.s, Ext.s
	If Not DirID
		ProcedureReturn 0
	EndIf
	While NextDirectoryEntry(DirID)
		Select DirectoryEntryType(DirID)
			Case #PB_DirectoryEntry_File
				File = Path + DirectoryEntryName(DirID)
				Ext = LCase(GetExtensionPart(File))
				If Ext = "pb" Or Ext = "pbi"
					*this\Dir.AddElement(File_LoadFile(File))
				EndIf
			Case #PB_DirectoryEntry_Directory
				File = DirectoryEntryName(DirID)
				If Not (File = "." Or File = ".." Or File = ".svn")
					File = Path + DirectoryEntryName(DirID) + "/"
					*this\Dir.AddElement(NewDirectory(File))
				EndIf
				
		EndSelect
	Wend
	FinishDirectory(DirID)
	ProcedureReturn *this
EndProcedure

Procedure Directory_CountElement(*this.Directory)
	Protected Count.l = *this\File.CountElement() + *this\Dir.CountElement(), n, *Dir.Directory
	For n = 1 To *this\Dir.CountElement()
		*Dir = *this\Dir.GetElement(n)
		Count + Directory_CountElement(*Dir)
	Next n
	ProcedureReturn Count
EndProcedure

Procedure Directory_FileIs(*this.Directory, Number.i)
	Protected n, *Dir.Directory, Count
	If Number = 0
		ProcedureReturn #Directory
	EndIf
	For n = 1 To *this\Dir.CountElement()
		Number - 1
		If Number = 0
			ProcedureReturn #Directory
		EndIf
		*Dir = *this\Dir.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_FileIs(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	ProcedureReturn 0
EndProcedure

Procedure Directory_GetFile(*this.Directory, Number)
	Protected n, *Dir.Directory, Count
	If Number = 0
		ProcedureReturn *this
	EndIf
	For n = 1 To *this\Dir.CountElement()
		Number - 1
		*Dir = *this\Dir.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_GetFile(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	ProcedureReturn *this\File.GetElement(Number)
EndProcedure

Procedure AddFilesToTree(*this.Directory, *IHM.IHM, Level.i)
	Protected n, *File.File
	AddGadgetItem(*IHM\Gadget[#GD_TreeProject], -1, *this\Name, ImageID(*IHM\Image[#ImageIcon_Directory]), Level)
	Level + 1
	For n = 1 To *this\Dir.CountElement()
		AddFilesToTree(*this\Dir.GetElement(n), *IHM, Level)
	Next n
	For n = 1 To *this\File.CountElement()
		*File = *this\File.GetElement(n)
		AddGadgetItem(*IHM\Gadget[#GD_TreeProject], -1, GetFilePart(*File\Path), ImageID(*IHM\Image[#ImageIcon_FileTree]), Level)
	Next n
EndProcedure

Procedure Directory_IsFile(*this.Directory, *File)
	Protected n
	For n = 1 To *this\File.CountElement()
		If *File = *this\File.GetElement(n)
			ProcedureReturn #True
		EndIf
	Next n
	For n = 1 To *this\Dir.CountElement()
		If Directory_IsFile(*this\Dir.GetElement(n), *File)
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
	For n = 1 To *this\Dir.CountElement()
		Number - 1
		*Dir = *this\Dir.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_GetFilePath(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	ProcedureReturn *this\Name + "/"
EndProcedure

Procedure Directory_RemoveFile(*this.Directory, Number)
	Protected n, *Dir.Directory, Count, *File
	If Number = 0
		ProcedureReturn #Null
	EndIf
	For n = 1 To *this\Dir.CountElement()
		Number - 1
		*Dir = *this\Dir.GetElement(n)
		Count = Directory_CountElement(*Dir)
		If Number <= Count
			ProcedureReturn Directory_RemoveFile(*Dir, Number)
		Else
			Number - Count
		EndIf
	Next n
	*File = *this\File.GetElement(Number)
	*this\File.FreeElement(Number)
	ProcedureReturn *File
EndProcedure

Procedure Directory_AddFile(*this.Directory, *File)
	*this\File.AddElement(*File)
EndProcedure

