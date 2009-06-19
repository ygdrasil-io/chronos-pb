XIncludeImport "DS.Lib.Array"
XIncludeImport "DS.Lib.Amphore.Ressource"

Class Amphore
	*ressource.Array = New Array()
	
	Procedure addFile(Path.s, ID)
		Protected FileID = OpenFile(#PB_Any, Path)
		If Not IsFile(FileID)	
			ProcedureReturn #False
		EndIf
		Protected *Memory = AllocateMemory(Lof(FileID))
		ReadData(FileID, *Memory, MemorySize(*Memory))
		CloseFile(FileID)
		*this.SetRessource(*Memory, GetFilePart(Path), ID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure SetRessource(*res, file.s, ID.l)
		Protected *Tres.Ressource, Found = *this.ResourceExist(ID)
		If Found
			*Tres = *this\ressource.GetElement(Found)
			*Tres.Free()
			*this\ressource.SetElement(Found, New Ressource(*res, file, ID))
		Else
			*this\ressource.AddElement(New Ressource(*res, file, ID))
		Endif
	EndProcedure
	
	Procedure ResourceExist(ID.l)
		Protected n
		Protected *YTempResource.Ressource
		for n = 1 to *this\ressource.CountElement()
			*YTempResource = *this\ressource.GetElement(n)
			If *YTempResource\ID = ID
				ProcedureReturn n
			EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
	
	Procedure.Ressource GetRessource(ID.l)
		Protected n
		Protected *YTempResource.Ressource
		for n = 1 to *this\ressource.CountElement()
			*YTempResource = *this\ressource.GetElement(n)
			If *YTempResource\ID = ID
				ProcedureReturn *YTempResource
			EndIf
		Next n
		ProcedureReturn #False
	EndProcedure
	
	Procedure Load(*ptr)
		If *ptr
			Protected Version.f = PeekF(*ptr)
			Protected id, SizeName, FileName.s, ResourceSize, Count, n
			Protected *res
			*ptr + SizeOf(float)
			Count = PeekL(*ptr)
			*ptr + SizeOf(long)
			Select Version
				Case 1.0
					For n = 0 To Count - 1
						id = PeekL(*ptr)
						*ptr + SizeOf(long)
						SizeName = PeekL(*ptr)
						*ptr + SizeOf(long)
						FileName = PeekS(*ptr, -1, #PB_Unicode)
						*ptr + SizeName
						ResourceSize = PeekL(*ptr)
						*ptr + SizeOf(long)
						*res = AllocateMemory(ResourceSize)
						CopyMemory(*ptr, *res, ResourceSize)
						*ptr + ResourceSize
						*this.SetRessource(*res, FileName,id)
					Next n
				Default
					ProcedureReturn #False
			EndSelect
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure Get()
		Protected *Buffer = AllocateMemory(SizeOf(long) + SizeOf(float)) , *FinalBuffer
		Protected Size, FinalSize, TempSize  = SizeOf(long) + SizeOf(float), ResourceSize
		Protected *Ressource.Ressource
		Protected n
		PokeF(*Buffer, 1.0)
		PokeL(*Buffer + SizeOf(float), *this\ressource.CountElement())
		For n=1 To *this\ressource.CountElement()
			Size = TempSize
			*Ressource = *this\ressource.GetElement(n)
			ResourceSize = MemorySize(*Ressource\Res)
			TempSize + SizeOf(long)*3 + ResourceSize + MemoryStringLength(@*Ressource\File, #PB_Unicode)
			*Buffer = ReAllocateMemory(*Buffer, TempSize)
			If Not *Buffer
				ProcedureReturn #False
			EndIf
			PokeL(*Buffer + Size, *Ressource\ID)
			Size + SizeOf(long)
			PokeL(*Buffer + Size, MemoryStringLength(@*Ressource\File, #PB_Unicode))
			Size + SizeOf(long)
			PokeS(*Buffer + Size, *Ressource\File, Len(*Ressource\File), #PB_Unicode)
			Size + MemoryStringLength(@*Ressource\File, #PB_Unicode)
			PokeL(*Buffer + Size, ResourceSize)
			Size + SizeOf(long)
			CopyMemory(*Ressource\Res, *Buffer + Size, ResourceSize)
		Next n
		ProcedureReturn *Buffer	
	EndProcedure
	
	Procedure.l GetMaxID()
		Protected max = 0
		Protected n
		Protected *Ressource.Ressource
		for n = 1 to *this\ressource.CountElement()
			*Ressource = *this\ressource.GetElement(n)
			If *Ressource\ID > max
				max = *Ressource\ID
			EndIf
		Next n
		ProcedureReturn max
	EndProcedure
	
	Procedure AddDirectory(Path.s, NameSpace.s = "")
		Protected IDDir = ExamineDirectory(#PB_any, Path, "*"), FileID, *Ptr
		If Not IDDir
			ProcedureReturn #False
		EndIf
		If IsDirectory(IDDir)
			While NextDirectoryEntry(IDDir)
				If Not Mid(DirectoryEntryName(IDDir), 1, 1) = "."
					Select DirectoryEntryType(IDDir)
						Case #PB_DirectoryEntry_File
							FileID = ReadFile(#PB_Any, Path + DirectoryEntryName(IDDir))
							If Not IsFile(FileID)
								ProcedureReturn #False
							EndIf
							*Ptr = AllocateMemory(Lof(FileID))
							If Not *Ptr
								ProcedureReturn #False
							EndIf
							ReadData(FileID, *Ptr, MemorySize(*Ptr))
							CloseFile(FileID)
							*this.SetRessource(*Ptr, NameSpace + DirectoryEntryName(IDDir), *this.GetMaxID() + 1)
						Default
							If Not *this.AddDirectory(Path + DirectoryEntryName(IDDir) + "/", NameSpace + DirectoryEntryName(IDDir) + "/")
								ProcedureReturn #False
							EndIf
					EndSelect
				EndIf
			Wend
		Else
			ProcedureReturn #False
		EndIf
		ProcedureReturn #True
	EndProcedure
	
	Procedure RestoreDirectory(Path.s)
		Protected n, *Ressource.Ressource, FileID
		For n = 1 To *this\ressource.CountElement()
			*Ressource = *this\ressource.getElement(n)
			If *Ressource
				If FileSize(Path + *Ressource\file) >= 0
					DeleteFile(Path + *Ressource\file)
				EndIf
				FileID = CreateFile(#PB_Any, Path + *Ressource\file)
				WriteData(FileID, *Ressource\Res, MemorySize(*Ressource\Res))
				CloseFile(FileID)
			EndIf
		Next n
	EndProcedure

	Procedure FromFile(File.s)
		Protected FileID = OpenFile(#PB_Any, File)
		If FileID
			Protected *ptr
			*ptr = AllocateMemory(Lof(FileID))
			ReadData(FileID, *ptr, MemorySize(*ptr))
			Protected Retour.b = *this.Load(*ptr)
			FreeMemory(*ptr)
			CloseFile(FileID)
			ProcedureReturn Retour
		Else
			ProcedureReturn #False
		EndIf
	EndProcedure
	
	Procedure ToFile(File.s)
		If FileSize(File) >= 0
			If Not DeleteFile(File)
				ProcedureReturn #False
			EndIf
		EndIf
		Protected FileID = CreateFile(#PB_Any, File)
		If Not IsFile(FileID)
			ProcedureReturn #False
		EndIf
		Protected *Ptr = *this.Get()
		If Not WriteData(FileID, *Ptr, MemorySize(*Ptr)) = MemorySize(*Ptr)
			ProcedureReturn #False
		EndIf
		CloseFile(FileID)
		ProcedureReturn #True
	EndProcedure
	
	Procedure Free()
		FreeMemory(*this)
	EndProcedure
EndClass




